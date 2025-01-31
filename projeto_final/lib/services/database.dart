import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/picture.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'nasa.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE pictures(
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              author TEXT NOT NULL,
              date TEXT NOT NULL,
              explanation TEXT NOT NULL,
              url TEXT NOT NULL)''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertPicture(List<Picture> pictures) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var picture in pictures) {
      result = await db.insert('pictures', picture.toMap());
    }
    return result;
  }

  Future<List<Picture>> retrievePictures() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('pictures');
    return queryResult.map((e) => Picture.fromMap(e)).toList();
  }

  Future<void> deletePhrase(int id) async {
    final db = await initializeDB();
    await db.delete(
      'phrases',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<bool> checkIfPictureExists(String author) async {
    final db = await initializeDB();  // Corrigindo a referência para usar DatabaseHandler
    
    List<Map<String, dynamic>> result = await db.query(
      'pictures',  
      where: 'author = ?',
      whereArgs: [author],
    );

    return result.isNotEmpty;
  }

}