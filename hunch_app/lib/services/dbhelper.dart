//Ananya Singhal

// BASIC SQL Commands check
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static const dbName = "mydatabase.db";
//   static const dbVersion = 1;
//   static const dbTable = "first";
//   static const col_id = "person id";
//   static const col_name = "person name";

//   //constructor
//   static final DatabaseHelper instance = DatabaseHelper();

//   //initialise database...sqflite.. private obj
//   late Database _database;

//   //initialise obj
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await initDB();
//     return _database;
//   }

//   initDB() async {
//     //folder of files regarding the app
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = join(directory.path, dbName);
//     return await openDatabase(path, version: dbVersion, onCreate: onCreate);
//   }

//   Future onCreate(Database db, int version) async {
//     db.execute('''
//       create table $dbTable(
//         $col_id integer primary key,
//         $col_name text not null
//       );
//  ''');
//   }

//   //insert
//   insert(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     return await db.insert(dbTable, row);
//   }

//   //read.. time
//   Future<List<Map<String, dynamic>>> query() async {
//     Database db = await instance.database;
//     return await db.query(dbTable);
//   }

//   //update
//   Future<int> update(Map<String, dynamic> row) async {
//     Database db = await instance.database;
//     int id = row[col_id];
//     return await db.update(dbTable, row, where: '$col_id = ?', whereArgs: [id]);
//   }

//   //delete
//   Future<int> delete(int id) async {
//     Database db = await instance.database;
//     return await db.delete(dbTable,where: '$col_id = ?',whereArgs: [id]);
//   }
// }

import 'package:hunch_app/model/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._data();

  DatabaseHelper._data();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderId TEXT,
        senderEmail TEXT,
        receiverId TEXT,
        message TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> insertMessage(Message message) async {
    Database db = await instance.database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessages() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }
}
