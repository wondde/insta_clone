import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const FeedScreen(),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram', style: TextStyle(fontSize: 28)),
      ),
      body: ListView.builder(
        itemCount: mockPosts.length,
        itemBuilder: (context, index) {
          return PostCard(post: mockPosts[index]);
        },
      ),
    );
  }
}

// 목데이터 영역
final List<Map<String, dynamic>> mockPosts = [
  {
    'username': 'wondde',
    'userImage': 'https://picsum.photos/200',
    'postImage': 'https://picsum.photos/200',
    'caption': 'dkdk',
    'likes': 99,
    'comments': 13,
    'isLiked': true,
  },
  {
    'username': 'wondde',
    'userImage': 'https://picsum.photos/200',
    'postImage': 'https://picsum.photos/200',
    'caption': 'dkdk',
    'likes': 99,
    'comments': 13,
    'isLiked': false,
  },
  {
    'username': 'wondde',
    'userImage': 'https://picsum.photos/200',
    'postImage': 'https://picsum.photos/200',
    'caption': 'dkdk',
    'likes': 99,
    'comments': 13,
    'isLiked': true,
  },
  {
    'username': 'wondde',
    'userImage': 'https://picsum.photos/200',
    'postImage': 'https://picsum.photos/200',
    'caption': 'dkdk',
    'likes': 13,
    'comments': 13,
    'isLiked': false,
  },
];

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (프로필 사진, 이름, 더보기)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(post['userImage']),
              ),
              SizedBox(width: 10),
              Text(
                post['username'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Icon(Icons.more_horiz),
            ],
          ),
        ),

        // 게시물
        Image.network(
          post['postImage'],
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

        // 액션 버튼 (일단 재투고버튼이랑 공유 횟수는 생략)
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                color: post['isLiked'] ? Colors.red : Colors.black,
              ),
              SizedBox(width: 5),
              Text(post['likes'].toString()),
              SizedBox(width: 10),
              Icon(Icons.mode_comment_outlined),
              SizedBox(width: 5),
              Text(post['comments'].toString()),
              SizedBox(width: 10),
              Icon(Icons.send_outlined),
              Spacer(),
              Icon(Icons.bookmark_border),
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
                  text: post['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post['caption']),
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
