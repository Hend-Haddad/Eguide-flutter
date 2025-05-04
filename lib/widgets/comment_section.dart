import 'package:eguideapp/servises/post_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eguideapp/widgets/comment_widget.dart';
import 'package:eguideapp/models/comment.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  
  const CommentSection({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final PostServices _postServices = PostServices();
  final TextEditingController _commentController = TextEditingController();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty || _currentUser == null) return;

    try {
      final newComment = Comment(
        author: _currentUser.uid,
        text: commentText,
        createdAt: DateTime.now(),
      );

      await _postServices.addComment(newComment, widget.postId);
      
      _commentController.clear();
      FocusScope.of(context).unfocus();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _buildCommentsList(),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _postServices.fetchPostComments(widget.postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Aucun commentaire trouvé'));
        }

        final comments = (snapshot.data!['comments'] as List<dynamic>?) ?? [];

        if (comments.isEmpty) {
          return const Center(
            child: Text(
              'Soyez le premier à commenter',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index] as Map<String, dynamic>;
            return CommentWidget(
              userId: comment['author']?.toString() ?? '',
              content: comment['text']?.toString() ?? '',
              timestamp: (comment['createdAt'] as Timestamp?)?.toDate(),
              postId: widget.postId,
              commentIndex: index,
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInput() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
   
    child: Row(
      children: [
       
       
        // Zone de texte
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'add comment...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _addComment(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // Bouton d'envoi externe
        IconButton(
          icon: Icon(Icons.send, 
            color: _commentController.text.isEmpty 
              ? Color.fromARGB(230, 94, 142, 206)
              : Theme.of(context).primaryColor,
          ),
          onPressed: _commentController.text.isEmpty ? null : _addComment,
          splashRadius: 20,
        ),
      ],
    ),
  );
} }