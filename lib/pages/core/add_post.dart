import 'dart:io';
import 'package:eguideapp/pages/core/navpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../servises/post_services.dart';
import '../../utils/dims.dart';
import '../../widgets/disabled_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class addPostPage extends StatefulWidget {
  const addPostPage({super.key});

  @override
  State<addPostPage> createState() => _addPostPageState();
}

String finalURL = '';
String downloadURL = '';
TextEditingController _postTextController = TextEditingController();
TextEditingController _questionController = TextEditingController();
PostServices _postServices = PostServices();
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _addPostPageState extends State<addPostPage> {
  bool isTextEmpty = true;
  bool imageUploaded = false; // Flag to track if image has been uploaded

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  XFile myImg = XFile('');
  File? selectedFile;
  String selectedFileName = '';
  PlatformFile platformFile = PlatformFile(name: "name", size: 2048);

  @override
  void initState() {
    _postTextController = TextEditingController();
    _questionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _postTextController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  _pickImgGallery() async {
    XFile? userImg = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 3000, maxHeight: 3000);
    if (userImg != null) {
      setState(() {
        myImg = XFile(userImg.path);
        imageUploaded = true; // Set to true once the image is selected
      });
    }
  }

  Future uploadFile() async {
    final fileName = DateTime.now().toString();
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(File(myImg.path));
      setState(() async {
        downloadURL = (await ref.getDownloadURL()).toString();
        finalURL = downloadURL;
      });
    } catch (e) {
      print('error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: AppDims.globalMargin,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Write your question :',
                      style: TextStyle(color: Color.fromARGB(255, 94, 142, 206), fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      isTextEmpty = value.isEmpty ? true : false;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  controller: _questionController,
                  cursorColor: Colors.teal,
                  cursorHeight: 22,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Write your Post :',
                      style: TextStyle(color: Color.fromARGB(255, 94, 142, 206), fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      isTextEmpty = value.isEmpty ? true : false;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  controller: _postTextController,
                  cursorColor: Colors.teal,
                  cursorHeight: 22,
                  maxLines: 8,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _pickImgGallery();
                      },
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.photo,
                            color: Color.fromARGB(255, 217, 173, 225),
                          ),
                          Text(
                            ' Add photo',
                            style: TextStyle(
                                color: Color.fromARGB(255, 217, 173, 225),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: imageUploaded, // Show only if image is uploaded
                      child: Row(
                        children: const [
                          Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: Colors.teal,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'image added',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                DisabledButton(
                  isDisabled: isTextEmpty,
                  onClick: () {
                    uploadFile().then((value) {
                      print(value);
                      print(finalURL);
                      Post newPost = Post(
                        author: _firebaseAuth.currentUser!.uid,
                        addedAt: DateTime.now().toString(),
                        text: _postTextController.text,
                        question: _questionController.text,
                        liked: List.empty(),
                        comments: List.empty(),
                        savedPosts: List.empty(),
                        media: finalURL,
                      );
                      _postServices.addPost(newPost);
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const NavPage()));
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool DisableButton() {
  return false;
}
