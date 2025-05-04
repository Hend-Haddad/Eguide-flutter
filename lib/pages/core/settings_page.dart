import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eguideapp/servises/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login.dart';

AuthServices _authServices = AuthServices();
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsOption(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Gérer les notifications
            },
          ),
          _buildSettingsOption(
            icon: Icons.privacy_tip,
            title: 'Privacy',
            onTap: () {
              // Gérer la confidentialité
            },
          ),
          _buildSettingsOption(
            icon: Icons.security,
            title: 'Security',
            onTap: () {
              // Gérer la sécurité
            },
          ),
          _buildSettingsOption(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // Afficher l'aide
            },
          ),
          _buildSettingsOption(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // Afficher les infos
            },
          ),
          const SizedBox(height: 24),
         
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}