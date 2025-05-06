import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eguideapp/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
        ],
      ),
    );
  }
}