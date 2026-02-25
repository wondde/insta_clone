import 'package:flutter/material.dart';
import 'package:insta_clone/screens/feed_screen.dart';

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
