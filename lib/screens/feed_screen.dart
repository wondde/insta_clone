import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_screen.dart';

/// 피드 스크린
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram', style: TextStyle(fontSize: 28)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 로딩
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 에러
          if (snapshot.hasError) {
            return Center(child: Text('에러 메시지: ${snapshot.error}'));
          }
          // 데이터가 없는 경우
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('게시물이 없습닌다.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              return PostCard(post: post, postId: posts[index].id);
            },
          );
        },
      ),
    );
  }
}

/// 포스트카드 위젯
class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final String postId;

  /// 포스트카드 생성자
  const PostCard({super.key, required this.post, required this.postId});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late bool isLiked;
  late int likedCount;
  bool _showHeartOverlay = false;
  late bool _isBookmarked;

  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimaion;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post['isLiked'] ?? false;
    final likes = widget.post['likes'] as List<dynamic>? ?? [];
    likedCount = likes.length;
    _isBookmarked = false;

    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heartAnimaion = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _heartAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartAnimationController.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _showHeartOverlay = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  /* void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likedCount += isLiked ? 1 : -1;
    });
  } */

  Future<void> _toggleLike() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId);

    if (isLiked) {
      //좋아요 취소
      await postRef.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      //좋아요 추가
      await postRef.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }

    setState(() {
      isLiked = !isLiked;
      likedCount += isLiked ? 1 : -1;
    });
  }

  void _onDoubleTap() {
    if (!isLiked) {
      setState(() {
        isLiked = true;
        likedCount += 1;
      });
    }

    setState(() {
      _showHeartOverlay = true;
    });
    _heartAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (프로필 사진, 이름, 더보기)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.post['userImage']),
                ),
                SizedBox(width: 10),
                Text(
                  widget.post['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
        ),

        // 게시물
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Stack(
            children: [
              Image.network(
                widget.post['postImage'] ??
                    'https://picsum.photos/seed/real1/600/600',
                width: double.infinity,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.grey,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              if (_showHeartOverlay)
                Positioned.fill(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _heartAnimaion,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _heartAnimaion.value,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 100,
                            shadows: [
                              Shadow(blurRadius: 20, color: Colors.black26),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 액션 버튼 (일단 재투고버튼이랑 공유 횟수는 생략)
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
              SizedBox(width: 5),
              Text(
                likedCount.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Icon(Icons.mode_comment_outlined),
              SizedBox(width: 5),
              Text(widget.post['comments'].toString()),
              SizedBox(width: 10),
              Icon(Icons.send_outlined),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                },
                child: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
              ),
            ],
          ),
        ),

        // 캡션
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: widget.post['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: widget.post['caption']),
              ],
            ),
          ),
        ),

        // 시간
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 4),
          child: Text(
            '3시간 전',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
