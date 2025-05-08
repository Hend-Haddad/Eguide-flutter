import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/main.dart';
import 'package:eguideapp/models/end_user.dart';
import 'package:eguideapp/pages/core/edit_profile.dart';
import 'package:eguideapp/pages/core/my_posts.dart';
import 'package:eguideapp/pages/core/saved_posts.dart';
import 'package:eguideapp/pages/core/settings_page.dart';
import 'package:eguideapp/utils/dims.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../servises/auth_services.dart';

import '../auth/login.dart';

AuthServices _authServices = AuthServices();
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: AppDims.globalMargin,
            child: FutureBuilder<DocumentSnapshot>(
              future: _authServices.getUserData(_firebaseAuth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('response: ${snapshot.data!["username"]}');
                  EndUser userInfo = EndUser(
                    uid: '',
                    username: snapshot.data!["username"],
                    avatarUrl: snapshot.data!["avatarUrl"] ?? '',
                    from: snapshot.data!["from"],
                    livingIn: snapshot.data!["livingIn"],
                    email: snapshot.data!["email"],
                    mediaLink: snapshot.data!["mediaLink"] ?? '',
                    bio: snapshot.data!["bio"] ?? '',
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Profile', style: TextStyle(fontSize: 24)),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const EditProfile(),
                                ),
                              );
                            },
                            icon: const Icon(CupertinoIcons.pencil, size: 26),
                          ),
                          const SizedBox(width: 2),
                          IconButton(
                            onPressed: () async {
                              await _authServices.logout().then(
                                (value) => Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipOval(
                        child: Container(
                          color: Colors.blue.shade200,
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
  radius: 60,
  foregroundImage: NetworkImage(userInfo.avatarUrl ?? ''),
  backgroundColor: Colors.blue.shade50,
  child: userInfo.avatarUrl == null || userInfo.avatarUrl!.isEmpty
      ? const Icon(Icons.person, size: 50)
      : null,
),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            '${userInfo.username}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userInfo.email!,
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.placemark, size: 18),
                              const SizedBox(width: 4),
                              const Text(
                                'from ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${userInfo.from}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Text(
                                ', living in  ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${userInfo.livingIn}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: TextButton(
                              onPressed: () async {
                                final Uri url = Uri.parse(userInfo.mediaLink!);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              },
                              child:
                                  userInfo.mediaLink != ''
                                      ? Text(
                                        '${userInfo.mediaLink}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue.shade700,
                                        ),
                                      )
                                      : Container(color: Colors.white12),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child:
                                userInfo.bio != ''
                                    ? Text(
                                      '${userInfo.bio}',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                    : Container(color: Colors.white12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const MyPosts(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.collections, size: 18),
                            const SizedBox(width: 5),
                            const Text(
                              'My posts',
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              color: Colors.blue.shade700,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const SavedPosts(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.bookmark, size: 18),
                            const SizedBox(width: 4),
                            const Text(
                              'Saved posts',
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Icon(
                              CupertinoIcons.chevron_forward,
                              color: Colors.blue.shade700,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                     InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  },
  child: Row(
    children: const [
      Icon(CupertinoIcons.gear, size: 20),
      SizedBox(width: 12),
      Text('Settings', style: TextStyle(fontSize: 22)),
      Spacer(),
      Icon(
        CupertinoIcons.chevron_forward,
        color: Colors.blue,
      ),
    ],
  ),
),

                      const SizedBox(height: 24),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
