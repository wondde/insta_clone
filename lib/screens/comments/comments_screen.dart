import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final userData = userDoc.data()!;

    await FirebaseFirestore.instance.collection('comments').add({
      'postId': widget.postId,
      'userId': uid,
      'username': userData['username'],
      'userImage': userData['photoUrl'] ?? '',
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': [],
    });

    // 게시물 댓글 수 증가
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({'commentCount': FieldValue.increment(1)});

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('댓글')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .where('postId', isEqualTo: widget.postId)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (cotext, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;

                if (comments.isEmpty) {
                  return const Center(child: Text("아직 댓글이 없습니다!"));
                }
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment =
                        comments[index].data() as Map<String, dynamic>;
                    return _CommentTile(
                      comment: comment,
                      commentId: comments[index].id,
                    );
                  },
                );
              },
            ),
          ),

          //댓글 입력
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: '댓글 달기',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(onPressed: _addComment, child: const Text('게시')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final String commentId;

  const _CommentTile({required this.comment, required this.commentId});

  @override
  Widget build(BuildContext context) {
    final isMycomment =
        comment['userId'] == FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              comment['userImage']?.isEmpty == false
                  ? comment['userImage']
                  : 'https://i.pravatar.cc/150',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '${comment['username']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: comment['text']),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '방금',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          if (isMycomment)
            IconButton(
              onPressed: () => _deleteComment(context),
              icon: Icon(Icons.close, size: 16, color: Colors.grey[500]),
            ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(BuildContext context) async {
    // 댓글 삭제
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(commentId)
        .delete();

    // 댓글 갯수 감소
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(comment['postId'])
        .update({'commentCount': FieldValue.increment(-1)});
  }
}
