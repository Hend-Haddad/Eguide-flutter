import 'package:eguideapp/servises/auth_services.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  final String userId;
  final String content;
  final DateTime? timestamp;
  final String postId;
  final int commentIndex;

  const CommentWidget({
    Key? key,
    required this.userId,
    required this.content,
    this.timestamp,
    required this.postId,
    required this.commentIndex,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final PostServices _postServices = PostServices();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
  try {
    final postDoc = await _postServices.fetchPost(widget.postId);
    if (postDoc.exists) {
      final data = postDoc.data() as Map<String, dynamic>? ?? {};
      final comments = data['comments'] as List<dynamic>? ?? [];
      
      if (widget.commentIndex < comments.length) {
        final comment = comments[widget.commentIndex] as Map<String, dynamic>? ?? {};
        final likes = comment['likes'] as List<dynamic>? ?? [];
        
        setState(() {
          _isLiked = likes.contains(_currentUser?.uid);
          _likeCount = likes.length;
        });
      }
    }
  } catch (e) {
    print('Error checking like status: $e');
  }
}

  Future<void> _toggleLike() async {
    if (_currentUser == null) return;

    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      await _postServices.toggleCommentLike(
        widget.postId, 
        widget.commentIndex, 
        _currentUser!.uid
      );
    } catch (e) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? -1 : 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: AuthServices().getUserData(widget.userId),
      builder: (context, snapshot) {
        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final username = userData['username'] as String? ?? 'Utilisateur';
        final avatarUrl = userData['avatarUrl'] as String?;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: avatarUrl != null 
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null
                    ? Text(username.isNotEmpty ? username[0].toUpperCase() : '?')
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(widget.content),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (widget.timestamp != null)
                          Text(
                            DateFormat('dd/MM/yy at HH:mm').format(widget.timestamp!),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        const Spacer(),
                        InkWell(
                          onTap: _toggleLike,
                          child: Row(
                            children: [
                              Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? Colors.red : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_likeCount',
                                style: TextStyle(
                                  color: _isLiked ? Colors.red : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}