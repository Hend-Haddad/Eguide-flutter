import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/models/end_user.dart';
import 'package:eguideapp/pages/core/profile.dart';
import 'package:eguideapp/servises/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
TextEditingController _mediaLinkController= TextEditingController();
TextEditingController _bioController= TextEditingController();
TextEditingController _emailController= TextEditingController();
TextEditingController _livingInController= TextEditingController();
TextEditingController _fromController= TextEditingController();
TextEditingController _nameController= TextEditingController();
  
AuthServices _authServices = AuthServices();
FirebaseAuth _firebaseAuth =FirebaseAuth.instance;

class EditProfile extends StatefulWidget {
   
   const EditProfile({super.key,  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

String finalURL ='';
String downloadURL ='';

class _EditProfileState extends State<EditProfile> {
  
  //
 firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
 
 XFile myImg =XFile('');
 File? selectedFile;
 String selectedFileName='';
 PlatformFile platformFile = PlatformFile(name:"name",size:2048);
 //


 _pickImgGallery()async{
    XFile? userImg = await ImagePicker().pickImage(
      source:ImageSource.gallery,maxWidth: 3000,maxHeight: 3000);
      if(userImg != null){
        setState(() {
          myImg =XFile(userImg.path);
        });
      }
  }

  Future uploadFile()async{
    
    final fileName =DateTime.now().toString();
    final destination ='files/$fileName';

    try{
      final ref =firebase_storage.FirebaseStorage.instance.ref(destination).child('avatar/');
      await ref.putFile(File(myImg.path));
      setState(() async {
        downloadURL =(await ref.getDownloadURL()).toString();
        finalURL =downloadURL;
      });
    }catch(e){
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: 
      SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
           future: _authServices.getUserData(_firebaseAuth.currentUser!.uid),
           builder: (context, snapshot){
              if (snapshot.hasData){
                 print('response: ${snapshot.data!["username"]}');
             EndUser userInfo = EndUser(
              uid: '',
              username: snapshot.data!["username"],
              avatarUrl:snapshot.data!["avatarUrl"]??'',
              from: snapshot.data!["from"],
              livingIn: snapshot.data!["livingIn"],
              email: snapshot.data!["email"] ,
              mediaLink: snapshot.data!["mediaLink"]??'' ,
              bio: snapshot.data!["bio"] ??''

             );
               _nameController.text=userInfo.username!;
               _emailController.text=userInfo.email!;
               _livingInController.text=userInfo.livingIn!;
               _fromController.text=userInfo.from!;
               _mediaLinkController.text=userInfo.mediaLink!;
               _bioController.text=userInfo.bio!;
             return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                          Navigator.pop(context, CupertinoPageRoute(builder: (context) =>  const ProfileScreen()));
                        }, icon: const Icon(CupertinoIcons.xmark,size: 26,)),
                       
                      const  Text('Edit Profile',style: TextStyle(fontSize: 24)),
                      IconButton(onPressed: () async{
                         EndUser newUser = EndUser(
                              uid: 'uid',
                              username: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              from: _fromController.text.trim(),
                              livingIn: _livingInController.text.trim(),
                              mediaLink: _mediaLinkController.text.trim(),
                              bio: _bioController.text.trim(),
                              avatarUrl: finalURL
                              
                              );
                              if(_nameController.text.trim().isNotEmpty &&
                               _livingInController.text.trim().isNotEmpty &&
                                _emailController.text.trim().isNotEmpty &&
                                _fromController.text.trim().isNotEmpty ){
                                   
                                   _authServices.addUserToCollection(newUser,_firebaseAuth.currentUser!.uid);
                                     Navigator.pop(context, CupertinoPageRoute(builder: (context) =>  const ProfileScreen()));
                                    
                                }
                      }, icon:const Icon(CupertinoIcons.check_mark,color: Colors.blue,))
                  ],
                ),
                 const SizedBox(height: 10,),
                  InkWell(
                    onTap: () {
                      uploadFile(); 
                    },
                    child: CircleAvatar(radius: 60,
                    foregroundImage: NetworkImage(userInfo.avatarUrl!),
                    backgroundColor: Colors.blue.shade50,
                    
                    backgroundImage:NetworkImage(finalURL) ,
                    ),
                  ),
                  const SizedBox(height: 4,),
                 TextButton(onPressed: (){
                   _pickImgGallery();
                   
                 }, child:const Text('Edit profile photo',style: TextStyle(color: Colors.blue,fontSize: 18)),),
                
                  Padding(
                   padding:const EdgeInsets.symmetric(horizontal:26.0),
                   child: TextField(
                    controller: _nameController,
                     cursorColor: Colors.teal,
                    decoration: const InputDecoration(
                      label: Text('User name',style: TextStyle(color: Colors.black54),),
                       enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       ),
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       )
                    ),

                   ),
                 ),
                   Padding(
                   padding: const EdgeInsets.symmetric(horizontal:26.0,vertical: 5),
                   child: TextField(
                    controller: _emailController,
                     cursorColor: Colors.teal,
                    decoration: const InputDecoration(
                      label: Text('Email',style: TextStyle(color: Colors.black54),),
                       enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       ),
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       )
                    ),
                    
                   ),
                 ),
                  
                   Padding(
                   padding: const EdgeInsets.symmetric(horizontal:26.0,vertical: 5),
                   child: TextField(
                    controller: _fromController,
                      cursorColor: Colors.teal,
                    decoration: const InputDecoration(
                       label: Text('Your mother country',style: TextStyle(color: Colors.black54),),
                        enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       ),
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       )
                    ),
                   ),
                 ),
                   Padding(
                   padding: const EdgeInsets.symmetric(horizontal:26.0,vertical: 5),
                   child: TextField(
                    controller: _livingInController,
                      cursorColor: Colors.teal,
                    decoration: const InputDecoration(
                       label: Text('Country you\'re living in',style: TextStyle(color: Colors.black54),),
                        enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       ),
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       )
                    ),
                   ),
                 ),

                
                  Padding(
                   padding: const EdgeInsets.symmetric(horizontal:26.0,vertical: 5),
                   child: TextField(
                    controller: _mediaLinkController,
                    cursorColor: Colors.teal,
                    cursorHeight: 22,
                    decoration: const InputDecoration(
                       label: Text('Web Site',style: TextStyle(color: Colors.black54),),
                       enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       ),
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       )
                    ),
                    
                   ),
                 ),
                  Padding(
                   padding: const EdgeInsets.symmetric(horizontal:26.0,vertical: 5),
                   child: TextField(
                    /*onTap: () {
                       Navigator.push(context, CupertinoPageRoute(builder: (context) => Bio()));
                    },*/
                    controller: _bioController,
                    cursorColor: Colors.teal,
                    cursorHeight: 22,
                    maxLines: 12,
                    minLines: 1,
                    decoration: const InputDecoration(
                       label: Text('Bio',style: TextStyle(color: Colors.black54),),
                       enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       ),
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                       )
                    ),
                    
                   ),
                 ),

              ],

            );
              }else {
            return Container();
          }
           }
        ),

      )),
    );
  }
}
 