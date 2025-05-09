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
    _postTextController.addListener(_updateButtonState);
    _questionController.addListener(_updateButtonState);
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
        _updateButtonState();
      });
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
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  children: [
                    Text(
                      'Write your question :',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => _updateButtonState(),
                  keyboardType: TextInputType.multiline,
                  controller: _questionController,
                  cursorColor: theme.colorScheme.secondary,
                  cursorHeight: 22,
                  maxLines: 3,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary, 
                        width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Write your Post :',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) => _updateButtonState(),
                  keyboardType: TextInputType.multiline,
                  controller: _postTextController,
                  cursorColor: theme.colorScheme.secondary,
                  cursorHeight: 22,
                  maxLines: 8,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.cardColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary, 
                        width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: _pickImage,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.photo,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add photo',
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
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
                        children: [
                          Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'image added',
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    if (_isUploading)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.secondary,
                          ),
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