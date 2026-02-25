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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FeedScreen(),
    Center(child: Text('검색부분')), // 아직 빈 화면
    Center(child: Text('새 게시물')),
    Center(child: Text('릴스')),
    Center(child: Text('프로필')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ), // body에 그냥 _screens[_currentIndex] 주면 현재 탭만 빌드함. 메모리는 절약하겠지만 상태 유실,,
      // indexedStack 쓰면 모든 탭을 빌드해서 메모리는 더 쓰지만 상태는 유지함.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: '투고',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            activeIcon: Icon(Icons.video_collection),
            label: '릴스',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            activeIcon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
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
