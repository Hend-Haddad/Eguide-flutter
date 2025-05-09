import 'package:eguideapp/pages/core/add_comment.dart';
import 'package:eguideapp/pages/core/public_profile.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../servises/auth_services.dart';

PostServices _postServices = PostServices();
AuthServices _authServices = AuthServices();
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class PostWidget extends StatelessWidget {
  final int postIdx;
  final String postId;
  final Post post;

  const PostWidget({
    super.key,
    required this.post,
    required this.postId,
    required this.postIdx,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Dans la classe PostWidget, modifiez le FutureBuilder
FutureBuilder<DocumentSnapshot>(
  future: _authServices.getUserData(post.author),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return UserMetaData(
        avatar: snapshot.data!["avatarUrl"] ?? '',
        username: snapshot.data!["username"],
        addedAt: post.addedAt,
        userId: post.author, // Ajoutez l'ID de l'utilisateur
      );
    } else {
      return const Text("Loading...");
    }
  },
),
          const SizedBox(height: 14),
          PostBody(
            question: post.question,
            text: post.text!,
            mediaUrl: post.media!,
          ),
          PostActions(
            likes: post.liked,
            savedPosts: post.savedPosts,
            comments: post.comments,
            pid: postId,
            pidx: postIdx,
          ),
        ],
      ),
    );
  }
}

// Dans le fichier post_widget.dart, modifiez la classe UserMetaData
class UserMetaData extends StatelessWidget {
  final String avatar;
  final String username;
  final String addedAt;
  final String userId; // Ajoutez ce champ

  const UserMetaData({
    super.key,
    required this.avatar,
    required this.username,
    required this.addedAt,
    required this.userId, // Ajoutez ce paramètre
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(addedAt);
    String formattedDate = DateFormat('MMM d, yyyy \'at\' h:mm a').format(parsedDate);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PublicProfileScreen(userId: userId),
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            foregroundImage: NetworkImage(avatar),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(CupertinoIcons.globe, size: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostBody extends StatelessWidget {
  final String question;
  final String text;
  final String mediaUrl;

  const PostBody({
    super.key,
    required this.text,
    required this.mediaUrl,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                question,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        mediaUrl.isEmpty
            ? const SizedBox.shrink()
            : Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(mediaUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ],
    );
  }
}

class PostActions extends StatefulWidget {
  final int pidx;
  final String pid;
  final List<dynamic> likes;
  final List<dynamic> comments;
  final List<dynamic> savedPosts;

  const PostActions({
    super.key,
    required this.likes,
    required this.pid,
    required this.pidx,
    required this.comments,
    required this.savedPosts,
  });

  @override
  _PostActionsState createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkResponse(
            onTap: () {
              if (widget.likes.contains(_firebaseAuth.currentUser!.uid)) {
                _postServices.dislikePost(widget.pid);
              } else {
                _postServices.likePost(widget.pid);
              }
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.likes.contains(_firebaseAuth.currentUser!.uid)
                      ? Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.blue.shade200,
                        )
                      : const Icon(CupertinoIcons.heart, color: Colors.black54),
                  const SizedBox(width: 7),
                  Text(
                    '${widget.likes.length}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkResponse(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      AddComment(postId: widget.pid, pidx: widget.pidx),
                ),
              );
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.chat_bubble, color: Colors.black54),
                  const SizedBox(width: 7),
                  Text(
                    '${widget.comments.length}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkResponse(
            onTap: () {
              if (widget.savedPosts.contains(_firebaseAuth.currentUser!.uid)) {
                _postServices.unsavedPost(widget.pid);
              } else {
                _postServices.savedPost(widget.pid);
              }
            },
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: widget.savedPosts.contains(_firebaseAuth.currentUser!.uid)
                  ? const Icon(CupertinoIcons.bookmark_fill, color: Colors.black87)
                  : const Icon(CupertinoIcons.bookmark, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
