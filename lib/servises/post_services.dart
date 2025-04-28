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

  addComment(Comment comment ,String postId)async{
    await _firebaseFirestore.collection('posts').doc(postId).update(
    {
      "comments":FieldValue.arrayUnion([comment.toJson()])
    }
    );
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