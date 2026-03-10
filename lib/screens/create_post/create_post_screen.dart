import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  final File imageFile;

  const CreatePostScreen({super.key, required this.imageFile});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _sharePost() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 1. 유저 정보 가져오기
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final userData = userDoc.data()!;

      // 2. 이미지 파베 스토리지에 업로드
      final postId = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child(postId)
          .child('image.jpg');

      final uploadTask = ref.putFile(widget.imageFile);

      // 업로드 진행률
      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      // 업로드 완료 대기
      await uploadTask;

      // 3. 다운로드 url
      final imageUrl = await ref.getDownloadURL();

      // 4. 파이어스토어에 게시물 문서 생성
      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        'postId': postId,
        'userId': uid,
        'username': userData['username'],
        'userImage': userData['photoUrl'] ?? '',
        'imageUrl': imageUrl,
        'caption': _captionController.text,
        'likes': [],
        'commentCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 5. 완료
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("게시물이 공유되었습니다.")));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("업로드 실패 $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 게시물'),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _sharePost,
            child: const Text('공유', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Column(
        children: [
          //업로드 진행률
          if (_isUploading) LinearProgressIndicator(value: _uploadProgress),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 선택 이미지 미리 볼 수 있음
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    widget.imageFile,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // 캡션
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: '문구 입력',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
