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
  Future<DocumentSnapshot>? _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userFuture = _authServices.getUserData(_firebaseAuth.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const EditProfile()),
              );
              _loadUserData(); // Rafraîchir les données après retour
            },
            icon: Icon(CupertinoIcons.pencil, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await _authServices.logout().then(
                (value) => Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()),
                ),
              );
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: AppDims.globalMargin,
            child: FutureBuilder<DocumentSnapshot>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
                      const SizedBox(height: 20),
                      ClipOval(
                        child: Container(
                          color: theme.colorScheme.secondary,
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: theme.cardColor,
                            backgroundImage:
                                userInfo.avatarUrl != null &&
                                        userInfo.avatarUrl!.isNotEmpty
                                    ? NetworkImage(userInfo.avatarUrl!)
                                    : null,
                            child:
                                userInfo.avatarUrl == null ||
                                        userInfo.avatarUrl!.isEmpty
                                    ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: theme.colorScheme.onBackground,
                                    )
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${userInfo.username}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        userInfo.email!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.placemark,
                            size: 18,
                            color: theme.colorScheme.onBackground,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'from ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          Text(
                            '${userInfo.from}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          Text(
                            ', living in  ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          Text(
                            '${userInfo.livingIn}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),


                      if (userInfo.mediaLink != null &&
                          userInfo.mediaLink!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(userInfo.mediaLink!);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: Text(
                              '${userInfo.mediaLink}',
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),


                        
                      if (userInfo.bio != null && userInfo.bio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${userInfo.bio}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                      const SizedBox(height: 28),
                      _buildProfileOption(
                        context,
                        icon: CupertinoIcons.collections,
                        text: 'My posts',
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const MyPosts(),
                          ),
                        ),
                      ),
                      _buildProfileOption(
                        context,
                        icon: CupertinoIcons.bookmark,
                        text: 'Saved posts',
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const SavedPosts(),
                          ),
                        ),
                      ),
                      _buildProfileOption(
                        context,
                        icon: CupertinoIcons.gear,
                        text: 'Settings',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.secondary,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onBackground),
            const SizedBox(width: 12),
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.chevron_forward,
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}