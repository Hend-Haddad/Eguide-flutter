import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/pages/core/navpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../servises/post_services.dart';
import '../../utils/dims.dart';
import '../../widgets/disabled_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final PostServices _postServices = PostServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late TextEditingController _postTextController;
  late TextEditingController _questionController;

  File? _pickedImage;
  String? _imageUrl;
  bool _isTextEmpty = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _postTextController = TextEditingController();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    _postTextController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isTextEmpty = _questionController.text.trim().isEmpty &&
          _postTextController.text.trim().isEmpty &&
          _pickedImage == null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      _updateButtonState();
    }
  }

  Future<String?> _uploadImage() async {
    if (_pickedImage == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child(fileName);

      await storageRef.putFile(_pickedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'upload: ${e.toString()}')),
      );
      return null;
    }
  }

  Future<void> _createPost() async {
    if (_postTextController.text.trim().isEmpty &&
        _questionController.text.trim().isEmpty &&
        _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter une question, un post ou une image.')),
      );
      return;
    }

    final imageUrl = _pickedImage != null ? await _uploadImage() : null;

    final newPost = Post(
      author: _firebaseAuth.currentUser!.uid,
      addedAt: DateTime.now().toString(),
      text: _postTextController.text.trim(),
      question: _questionController.text.trim(),
      liked: [],
      comments: [],
      savedPosts: [],
      media: imageUrl,
    );

    await _postServices.addPost(newPost);
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const NavPage()),
    );
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
                      style: TextStyle(
                          color: Color.fromARGB(255, 94, 142, 206),
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => _updateButtonState(),
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
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Write your Post :',
                      style: TextStyle(
                          color: Color.fromARGB(255, 94, 142, 206),
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => _updateButtonState(),
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
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: _pickImage,
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
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (_pickedImage != null)
                      Row(
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
                    if (_isUploading)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                DisabledButton(
                  isDisabled: _isTextEmpty || _isUploading,
                  onClick: _createPost,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
