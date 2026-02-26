import 'package:flutter/material.dart';

/// 피드 스크린
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

/// 포스트카드 위젯
class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;

  /// 포스트카드 생성자
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late bool isLiked;
  late int likedCount;
  bool _showHeartOverlay = false;

  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimaion;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post['isLiked'];
    likedCount = widget.post['likes'];

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

  void _toggleLike() {
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

        // 게시물
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: Stack(
            children: [
              Image.network(
                widget.post['postImage'],
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
