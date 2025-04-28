
import 'package:eguideapp/models/comment.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:eguideapp/widgets/comment_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
   final String postId;
   final int pidx;
  const AddComment({super.key, required this.postId, required this.pidx,});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
   final PostServices _postServices =PostServices();
    final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  final TextEditingController _commentController =TextEditingController();
  bool isTextEmpty=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
        icon:const  Icon(CupertinoIcons.arrow_left,color: Colors.black87,)
        ),
        title:const Text('Comments',style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: SafeArea(child:
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: CommentSection(postId: widget.pidx,)),
         
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
               Container(
                margin:const EdgeInsets.all(10),
                width: 318,
                height: 58,
                 child: TextField(
                  onChanged: (value) {
                    setState(() {
                      isTextEmpty = value.isEmpty?true:false;
                    });
                  },
                  decoration: const InputDecoration(
                    
                     border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(1))),
                            hintText: '  add a comment.....'
                           
                  ),
                   cursorColor: Colors.black87,
                  controller: _commentController,
                  maxLines: 6,
                  
                  
                  
              ),
               ),
               
                CircleAvatar(
                radius: 24,  
                 backgroundColor: Colors.blue.shade100,
              child: IconButton(
                onPressed: (){
                  
                   Comment newComment = Comment( 
                    author:_firebaseAuth.currentUser!.uid ,
                    text: _commentController.text, );
                      
                    _postServices.addComment(newComment , widget.postId);
                        
                        
                }, 
                icon:const Icon(CupertinoIcons.paperplane)),
               
                      ),
                   
              ],),
            ],
          )
           
         
       ],)),
    );
    
  }
}