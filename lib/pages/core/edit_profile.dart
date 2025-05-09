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

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final AuthServices _authServices = AuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  late TextEditingController _mediaLinkController;
  late TextEditingController _bioController;
  late TextEditingController _emailController;
  late TextEditingController _livingInController;
  late TextEditingController _fromController;
  late TextEditingController _nameController;
  
  File? _pickedImage;
  String? _avatarUrl;
  bool _isUploading = false;
  bool _controllersInitialized = false;

  @override
  void initState() {
    super.initState();
    _mediaLinkController = TextEditingController();
    _bioController = TextEditingController();
    _emailController = TextEditingController();
    _livingInController = TextEditingController();
    _fromController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _mediaLinkController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _livingInController.dispose();
    _fromController.dispose();
    _nameController.dispose();
    super.dispose();
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
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_pickedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('files')
          .child('${_firebaseAuth.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(_pickedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _avatarUrl = downloadUrl;
        _isUploading = false;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'avatarUrl': downloadUrl});

    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: _authServices.getUserData(_firebaseAuth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Erreur: ${snapshot.error}',
                      style: theme.textTheme.bodyLarge),
                );
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text('Profil non trouvé',
                      style: theme.textTheme.bodyLarge),
                );
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final currentAvatarUrl = userData['avatarUrl'] as String?;

              if (!_controllersInitialized) {
                _nameController.text = userData['username'] ?? '';
                _emailController.text = userData['email'] ?? '';
                _livingInController.text = userData['livingIn'] ?? '';
                _fromController.text = userData['from'] ?? '';
                _mediaLinkController.text = userData['mediaLink'] ?? '';
                _bioController.text = userData['bio'] ?? '';
                _controllersInitialized = true;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(CupertinoIcons.xmark, 
                            size: 26, 
                            color: theme.colorScheme.onBackground),
                      ),
                      Text('Modifier le profil', 
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onBackground,
                          )),
                      IconButton(
                        onPressed: () async {
                          final newUser = EndUser(
                            uid: _firebaseAuth.currentUser!.uid,
                            username: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            from: _fromController.text.trim(),
                            livingIn: _livingInController.text.trim(),
                            mediaLink: _mediaLinkController.text.trim(),
                            bio: _bioController.text.trim(),
                            avatarUrl: _avatarUrl ?? currentAvatarUrl ?? '',
                          );

                          if (_nameController.text.trim().isNotEmpty &&
                              _emailController.text.trim().isNotEmpty) {
                            await _authServices.addUserToCollection(
                              newUser, 
                              _firebaseAuth.currentUser!.uid
                            );
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(CupertinoIcons.check_mark, 
                            color: theme.colorScheme.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: theme.cardColor,
                          backgroundImage: _getAvatarImage(currentAvatarUrl),
                          child: _getAvatarImage(currentAvatarUrl) == null
                              ? Icon(Icons.person, 
                                  size: 50, 
                                  color: theme.colorScheme.onBackground)
                              : null,
                        ),
                        if (_isUploading)
                          CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      'Changer la photo',
                      style: TextStyle(
                        color: theme.colorScheme.secondary, 
                        fontSize: 16
                      ),
                    ),
                  ),
                  _buildTextField(_nameController, 'Nom d\'utilisateur', theme),
                  _buildTextField(_emailController, 'Email', theme),
                  _buildTextField(_fromController, 'Pays d\'origine', theme),
                  _buildTextField(_livingInController, 'Pays de résidence', theme),
                  _buildTextField(_mediaLinkController, 'Site web', theme),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 5),
                    child: TextField(
                      controller: _bioController,
                      style: TextStyle(color: theme.colorScheme.onBackground),
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ImageProvider? _getAvatarImage(String? storedUrl) {
    if (_pickedImage != null) {
      return FileImage(_pickedImage!);
    } else if (storedUrl != null && storedUrl.isNotEmpty) {
      return NetworkImage(storedUrl);
    }
    return null;
  }

  Widget _buildTextField(TextEditingController controller, String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8),
      child: TextField(
        controller: controller,
        style: TextStyle(color: theme.colorScheme.onBackground),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.colorScheme.onBackground),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}