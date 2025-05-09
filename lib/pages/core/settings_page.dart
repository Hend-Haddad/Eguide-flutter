import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eguideapp/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Settings'),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.white, // Couleur de la flèche
        ),
         backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDarkMode ? Colors.white : Colors.white,
            ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mode sombre
          ListTile(
            title: const Text('Mode Sombre'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) async {
                await themeProvider.toggleDarkMode(value);
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const Divider(),

          // Modifier le Profil
          ListTile(
            title: const Text('Modifier le Profil'),
            leading: const Icon(Icons.account_circle),
            onTap: () {
              // Naviguer vers la page de modification du profil
            },
          ),
          const Divider(),

          // Notifications
          ListTile(
            title: const Text('Notifications'),
            leading: const Icon(Icons.notifications),
            trailing: Switch(
              value: true, // Remplacer par un vrai paramètre pour activer/désactiver les notifications
              onChanged: (value) {
                // Activer ou désactiver les notifications
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const Divider(),

          // Langue
          ListTile(
            title: const Text('Langue'),
            leading: const Icon(Icons.language),
            onTap: () {
              // Naviguer vers une page de sélection de langue
            },
          ),
          const Divider(),

          // Gérer la sécurité
          ListTile(
            title: const Text('Sécurité et confidentialité'),
            leading: const Icon(Icons.lock),
            onTap: () {
              // Naviguer vers la page de sécurité ou confidentialité
            },
          ),
          const Divider(),

          // À propos de l'application
          ListTile(
            title: const Text('À propos de l\'application'),
            leading: const Icon(Icons.info),
            onTap: () {
              // Naviguer vers la page À propos
            },
          ),
          const Divider(),

          // Support et Aide
          ListTile(
            title: const Text('Support et Aide'),
            leading: const Icon(Icons.help),
            onTap: () {
              // Naviguer vers une page d'aide ou contact
            },
          ),
        ],
      ),
    );
  }
}
