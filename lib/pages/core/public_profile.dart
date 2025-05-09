import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/models/end_user.dart';
import 'package:eguideapp/utils/dims.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicProfileScreen extends StatelessWidget {
  final String userId;
  
  const PublicProfileScreen({super.key, required this.userId});

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary,
                  ),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text('User not found',
                      style: theme.textTheme.bodyLarge),
                );
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final userInfo = EndUser(
                uid: userId,
                username: userData['username'] ?? 'No username',
                email: userData['email'] ?? 'No email',
                avatarUrl: userData['avatarUrl'] ?? '',
                from: userData['from'] ?? 'Unknown',
                livingIn: userData['livingIn'] ?? 'Unknown',
                mediaLink: userData['mediaLink'] ?? '',
                bio: userData['bio'] ?? '',
              );

              return Container(
                margin: AppDims.globalMargin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.cardColor,
                      backgroundImage: userInfo.avatarUrl != null &&
                              userInfo.avatarUrl!.isNotEmpty
                          ? NetworkImage(userInfo.avatarUrl!)
                          : null,
                      child: userInfo.avatarUrl == null ||
                              userInfo.avatarUrl!.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: theme.colorScheme.onBackground,
                            )
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      userInfo.username!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (userInfo.email != null && userInfo.email!.isNotEmpty)
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
                          userInfo.from!,
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
                          userInfo.livingIn!,
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
                            userInfo.mediaLink!,
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
                          userInfo.bio!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}