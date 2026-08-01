import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicament.dart';
import '../data/medicaments_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medicaments.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE medicaments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            labo TEXT NOT NULL,
            posologie TEXT NOT NULL,
            prix TEXT NOT NULL,
            categorie TEXT NOT NULL,
            couleur TEXT NOT NULL DEFAULT 'bleu'
          )
        ''');
        // Insertion des données initiales
        for (final med in medicamentsData) {
          await db.insert('medicaments', med.toMap());
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS medicaments');
        await db.execute('''
          CREATE TABLE medicaments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            labo TEXT NOT NULL,
            posologie TEXT NOT NULL,
            prix TEXT NOT NULL,
            categorie TEXT NOT NULL,
            couleur TEXT NOT NULL DEFAULT 'bleu'
          )
        ''');
        for (final med in medicamentsData) {
          await db.insert('medicaments', med.toMap());
        }
      },
    );
  }

  Future<List<Medicament>> getByCategorie(String categorie) async {
    final db = await database;
    final maps = await db.query(
      'medicaments',
      where: 'categorie = ?',
      whereArgs: [categorie],
    );
    return maps.map((m) => Medicament.fromMap(m)).toList();
  }

  Future<int> insert(Medicament med) async {
    final db = await database;
    return await db.insert('medicaments', med.toMap());
  }

  Future<int> update(Medicament med) async {
    final db = await database;
    return await db.update(
      'medicaments',
      med.toMap(),
      where: 'id = ?',
      whereArgs: [med.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('medicaments', where: 'id = ?', whereArgs: [id]);
  }
}
