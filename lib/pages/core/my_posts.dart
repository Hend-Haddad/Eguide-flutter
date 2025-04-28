import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/models/post.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:eguideapp/widgets/post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PostServices _postServices =PostServices();
class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
        icon:const  Icon(CupertinoIcons.arrow_left,color: Colors.black87,)
        ),
        title:const Text('My Posts',style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
       body: SafeArea(
        child: Column(
          children: [
           
            StreamBuilder<QuerySnapshot>(
             stream: _postServices.fetchMyPosts(),
             builder: (context, snapshot) {
               if(snapshot.hasData){
                 return Expanded(
                   child:  ListView.separated(
                     itemCount: snapshot.data!.docs.length,
                     shrinkWrap: true,
                     scrollDirection: Axis.vertical,
                     physics: const AlwaysScrollableScrollPhysics(),
                     separatorBuilder: (context, index) => Container(
                           height: 1,
                           color: Colors.grey.shade300,
                         ),
                     itemBuilder: (context, index) {
                       Post p = Post(
                        author: snapshot.data!.docs[index]["author"],
                        text: snapshot.data!.docs[index]["text"],
                        question: snapshot.data!.docs[index]["question"],
                        media: snapshot.data!.docs[index]["media"]??'',
                        addedAt: snapshot.data!.docs[index]["addedAt"],
                        liked: snapshot.data!.docs[index]["liked"],
                       comments: snapshot.data!.docs[index]["comments"],
                       savedPosts: snapshot.data!.docs[index]["savedPosts"]
                        
                       );
                       
                       return PostWidget(
                      postIdx: index,
                       postId:snapshot.data!.docs[index].id,
                       post: p,
                       
                       );
                     }),
                 );
                 
               }else{
                 return Text('loading');
               }
              }
            ),
          ],
        )),
    );
  }
}