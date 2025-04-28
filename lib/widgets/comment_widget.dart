import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/servises/auth_services.dart';

import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
 
  final String userId;
  final String content;
  const CommentWidget({super.key,  required this.userId, required this.content, });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  final AuthServices _authServices =AuthServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20,top: 20 ,right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           FutureBuilder<DocumentSnapshot>(
                future: _authServices.getUserData(widget.userId),
                builder: (context, snapshot) {
                  if(snapshot.hasData){ 
                    return CircleAvatar(
                    radius: 25,
                    foregroundImage:
                    NetworkImage(snapshot.data!["avatarUrl"],),
              ) ;
                    }else{
                      return Container();
                    }
                 
                }
              ),
           const SizedBox(width: 12,),
           Expanded(
             child: SizedBox(
             
               child: Column(
               
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: _authServices.getUserData(widget.userId),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){ 
                        return Text(snapshot.data!["username"], 
                        style:const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),);
                        }else{
                          return Container();
                        }
                     
                    }
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Flexible(
                        child: Text(widget.content,
                        style: const TextStyle(color: Colors.black87,fontSize: 14),)),
                    ],
                  ),
                ],
                     ),
             ),
           ),
        ],
      ),
    );
  }
}