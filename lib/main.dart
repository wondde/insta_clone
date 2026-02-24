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
      body: Center(child: Text("피드 자리")),
    );
  }
}

// 목데이터 영역
final List<Map<String, dynamic>> mockPosts = [
  {
    'username': 'wondde',
    'userIamge': 'https://placehold.co/400',
    'postImage': 'https://placehold.co/400',
    'caption': 'dkdk',
    'likes': 99,
    'isLiked': true,
  },
  {
    'username': 'wondde',
    'userIamge': 'https://placehold.co/400',
    'postImage': 'https://placehold.co/400',
    'caption': 'dkdk',
    'likes': 99,
    'isLiked': false,
  },
  {
    'username': 'wondde',
    'userIamge': 'https://placehold.co/400',
    'postImage': 'https://placehold.co/400',
    'caption': 'dkdk',
    'likes': 99,
    'isLiked': true,
  },
  {
    'username': 'wondde',
    'userIamge': 'https://placehold.co/400',
    'postImage': 'https://placehold.co/400',
    'caption': 'dkdk',
    'likes': 13,
    'isLiked': false,
  },
];
