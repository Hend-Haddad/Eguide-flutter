// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sort_child_properties_last, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../utils/app_styles.dart';

import '../../widgets/post_widget.dart';


TextEditingController _searchController= TextEditingController();

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
PostServices _postServices =PostServices();
class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
     body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 10,bottom: 4,),
          child: Column(
            children: [
             SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Discover the country \n      Live like a native',style: AppStyles.authTitleStyle,),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  controller:_searchController ,
                  placeholder: '  Search a question...',
                  
                ),
              ),
              SizedBox(height: 1,),
                StreamBuilder<QuerySnapshot>(
                            stream: _postServices.fetchAllPosts(),
                            builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.separated(
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
                          )
               
            
            
            ],
          ),
        )),
      
    );
  }
}