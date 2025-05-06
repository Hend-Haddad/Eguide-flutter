import 'package:eguideapp/main.dart';
import 'package:eguideapp/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test du chargement initial de l\'application', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(false),
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    
    expect(find.byType(SplashPage), findsOneWidget);
  });

  testWidgets('Test du changement de thème', (WidgetTester tester) async {
    final themeProvider = ThemeProvider(false);
    
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => themeProvider,
        child: const MyApp(),
      ),
    );
    
    // Vérifier le thème initial
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.brightness, Brightness.light);
    
    // Changer le thème
    await themeProvider.toggleDarkMode(true);
    await tester.pump();
    
    // Vérifier que le thème a changé
    final updatedMaterialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedMaterialApp.theme?.brightness, Brightness.dark);
  });
}