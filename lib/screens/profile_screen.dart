import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// 프로필 스크린
class ProfileScreen extends StatelessWidget {
  final bool isMyProfile;

  const ProfileScreen({super.key, this.isMyProfile = true});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        final username = snapshot.data!.data()?['username'];
        final userImage = snapshot.data!.data()?['photoUrl'];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: null, icon: Icon(Icons.add_box_outlined)),
              IconButton(onPressed: null, icon: Icon(Icons.menu)),
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 프로필 헤더
                _buildProfileHeader(userImage),

                // 바이오
                _buildBio(username),

                // 프로필 편집 버튼 or 팔로우 버튼
                _buildActionButton(),

                // 탭바
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.grid_on)),
                          Tab(icon: Icon(Icons.person_pin_outlined)),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            // 게시물 그리드
                            _buildPostGrid(),
                            const Center(child: Text('태그된 사진이 없습니당')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 프로필 헤더 영역
  Widget _buildProfileHeader(String userImage) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(userImage)),
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

  // 프로필 바이오
  Widget _buildBio(String username) {
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

  // 프로필 편집 버튼
  Widget _buildEditButton() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: null, child: Text('프로필 편집')),
      ),
    );
  }

  // 게시물 그리드
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

  // 액션 버튼 (프로필 편집 or 팔로우 버튼)
  Widget _buildActionButton() {
    if (isMyProfile) {
      return _buildEditButton();
    } else {
      return _buildFollowButton();
    }
  }

  // 팔로우 버튼
  Widget _buildFollowButton() {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
          ),
          child: Text('팔로우'),
        ),
      ),
    );
  }
}
