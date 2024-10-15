import 'package:flutter_practice/models/stationery.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_practice/models/book.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  static Database? _database;

  factory DbService() {
    return _instance;
  }

  DbService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'bookstore.db');
    var bookStoreDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return bookStoreDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS book(
      "id" INTEGER NOT NULL,
      "title" TEXT NOT NULL,
      "author" TEXT NOT NULL,
      "genre" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "quantity" INTEGER NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<List<Map<String, dynamic>>> getBookMapList() async {
    Database db = await database;
    var res = await db.query('book');
    return res;
  }

  Future<int> createBook(Book book) async {
    var db = await database;
    var res = await db.insert('book', book.toMap());
    return res;
  }

  Future<int> deleteBook(int id) async {
    var db = await database;
    int res = await db.rawDelete('''DELETE FROM book WHERE id = $id''');
    return res;
  }

  Future<int?> getBookAmount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('''SELECT COUNT (*) FROM book''');
    int? res = Sqflite.firstIntValue(x);
    return res;
  }

  Future<List<Book>> fetchAll() async {
    var bookMapList = await getBookMapList();
    int count = bookMapList.length;

    List<Book> bookList = List<Book>.empty(growable: true);

    for (int i = 0; i < count; i++) {
      bookList.add(Book.fromMapObject(bookMapList[i]));
    }

    return bookList;
  }
}
