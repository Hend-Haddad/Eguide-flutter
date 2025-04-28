

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/models/comment.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:eguideapp/widgets/comment_widget.dart';

import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final int postId;
  const CommentSection({super.key, required this.postId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final PostServices _postServices = PostServices();
  @override
  Widget build(BuildContext context) {
    return 
     
      SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: _postServices.fetchAllCommentsByPost(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.separated(
                  itemCount: snapshot.data!.docs[widget.postId]["comments"].length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Container(
                        height: 2,
                        //color: Colors.grey.shade300,
                        color: Colors.white,
                      ),
                  itemBuilder: (context, index) {
                    Comment c = Comment(
                     author: snapshot.data!.docs[widget.postId]["comments"][index]["author"],
                     text: snapshot.data!.docs[widget.postId]["comments"][index]["text"],
                     
                    );
                    return CommentWidget(
                      userId: c.author,
                      content : c.text,
                    );
                  });
      
              }else{
                return const Text('loading');
               
              }
            }
          ),
      );
   
  }
}