import 'package:flutter/material.dart';

/// 프로필 스크린
class ProfileScreen extends StatelessWidget {
  final String username;
  final String userImage;
  final bool isMyProfile;

  const ProfileScreen({
    super.key,
    this.username = 'my_username',
    this.userImage = 'https://i.pravatar.cc/150?img=5',
    this.isMyProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.add_box_outlined)),
          IconButton(onPressed: null, icon: Icon(Icons.menu)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            _buildProfileHeader(),

            // 바이오
            _buildBio(),

            // 프로필 편집 버튼
            _buildEditButton(),

            // 게시물 그리드
            _buildPostGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '게시물\n ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '12'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '팔로워\n ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '122'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '팔로잉\n ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '132'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("안녕하세요"),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: null, child: Text('프로필 편집')),
      ),
    );
  }

  Widget _buildPostGrid() {
    final List<String> postImages = List.generate(
      90,
      (index) => 'https://picsum.photos/seed/grid$index/300/300',
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: postImages.length,
      itemBuilder: (context, index) {
        return Image.network(postImages[index], fit: BoxFit.cover);
      },
    );
  }
}
