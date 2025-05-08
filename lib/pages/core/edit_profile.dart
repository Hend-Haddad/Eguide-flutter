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
      // Stockage dans le dossier files/
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

      // Mise à jour immédiate dans Firestore
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: _authServices.getUserData(_firebaseAuth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Profil non trouvé'));
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
                        icon: const Icon(CupertinoIcons.xmark, size: 26),
                      ),
                      const Text('Modifier le profil', style: TextStyle(fontSize: 24)),
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
                        icon: const Icon(CupertinoIcons.check_mark, color: Colors.blue),
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
                          backgroundColor: Colors.blue.shade50,
                          backgroundImage: _getAvatarImage(currentAvatarUrl),
                          child: _getAvatarImage(currentAvatarUrl) == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        if (_isUploading)
                          const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text(
                      'Changer la photo',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                  _buildTextField(_nameController, 'Nom d\'utilisateur'),
                  _buildTextField(_emailController, 'Email'),
                  _buildTextField(_fromController, 'Pays d\'origine'),
                  _buildTextField(_livingInController, 'Pays de résidence'),
                  _buildTextField(_mediaLinkController, 'Site web'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 5),
                    child: TextField(
                      controller: _bioController,
                      maxLines: 5,
                      minLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}