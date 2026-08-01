import 'package:flutter/material.dart';
import 'pages/detail_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

void main() {
  // Initialise sqflite pour Linux/Windows/macOS desktop
  sqfliteFfiInit();

  // Force un chemin fixe et stable pour la base de données,
  // indépendant du répertoire de lancement de l'app
  final home = Platform.environment['HOME'] ?? '.';
  final dbDir = join(home, '.local', 'share', 'medicaments');
  Directory(dbDir).createSync(recursive: true);

  databaseFactory = databaseFactoryFfi;
  databaseFactoryFfi.setDatabasesPath(dbDir);

  runApp(const MedicamentsApp());
}

class MedicamentsApp extends StatelessWidget {
  const MedicamentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Médicaments',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> boutons = [
    'Vit D',
    'Mg',
    'Vit C',
    'Zinc',
    'Fer',
    'Selenium',
    'Energie',
    'Toux',
    'AINS',
    'Charbon',
  ];

  void _onPressed(BuildContext context, String label) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(categorie: label)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: const Text('Médicaments'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3,
          children: boutons.map((label) {
            return ElevatedButton(
              onPressed: () => _onPressed(context, label),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(label),
            );
          }).toList(),
        ),
      ),
    );
  }
}
