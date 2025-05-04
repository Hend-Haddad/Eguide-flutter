import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/models/comment.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../models/post.dart';


class PostServices{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
 
  addPost(Post post)async{
    await _firebaseFirestore.collection('posts').doc().set(post.toJson());
  }
Stream<DocumentSnapshot> fetchPostComments(String postId) {
    return _firebaseFirestore.collection('posts').doc(postId).snapshots();
  }
  addComment(Comment comment ,String postId)async{
    await _firebaseFirestore.collection('posts').doc(postId).update(
    {
      "comments":FieldValue.arrayUnion([comment.toJson()])
    }
    );
  }
  Future<void> toggleCommentLike(String postId, int commentIndex, String userId) async {
  final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
  
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(postRef);
    final comments = List<Map<String, dynamic>>.from(snapshot.data()?['comments'] ?? []);
    
    if (commentIndex < comments.length) {
      final comment = Map<String, dynamic>.from(comments[commentIndex]);
      final likes = List<String>.from(comment['likes'] ?? []);
      
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }
      
      comment['likes'] = likes;
      comments[commentIndex] = comment;
      
      transaction.update(postRef, {'comments': comments});
    }
  });
}
Future<DocumentSnapshot> fetchPost(String postId) {
  return FirebaseFirestore.instance.collection('posts').doc(postId).get();
}
   Stream <QuerySnapshot>fetchAllCommentsByPost () {
    return _firebaseFirestore.collection('posts').snapshots();
  } 
   
  
  Stream <QuerySnapshot>fetchAllPosts () {
    return _firebaseFirestore.collection('posts').snapshots();
  }


   Stream <QuerySnapshot>fetchSavedPosts () {
    final user=FirebaseAuth.instance.currentUser;
    return _firebaseFirestore.collection('posts').where("savedPosts",arrayContains: user!.uid).snapshots();
  }
   
   Stream <QuerySnapshot>fetchMyPosts () {
    final user=FirebaseAuth.instance.currentUser;
    return _firebaseFirestore.collection('posts').where("author",isEqualTo: user!.uid).snapshots();
  }

  Future <void> likePost(String documentId) async {
    _firebaseFirestore.collection('posts').doc(documentId).update({
      "liked":FieldValue.arrayUnion([_firebaseAuth.currentUser!.uid])
    });
  }

  Future <void> dislikePost(String documentId) async {
    _firebaseFirestore.collection('posts').doc(documentId).update({
      "liked":FieldValue.arrayRemove([_firebaseAuth.currentUser!.uid])
    });
  }



  Future <void> savedPost(String documentId) async {
    _firebaseFirestore.collection('posts').doc(documentId).update({
      "savedPosts":FieldValue.arrayUnion([_firebaseAuth.currentUser!.uid])
    });
  }

  Future <void> unsavedPost(String documentId) async {
    _firebaseFirestore.collection('posts').doc(documentId).update({
      "savedPosts":FieldValue.arrayRemove([_firebaseAuth.currentUser!.uid])
    });
  }
}