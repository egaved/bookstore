import 'package:flutter_practice/models/stationery.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_practice/models/book.dart';

class DbService {
  static late DbService _dbService;
  static late Database _database;

  DbService._createInstance();

  factory DbService() {
    if (_dbService == null) {
      _dbService = DbService._createInstance();
    }
    return _dbService;
  }

  Future<Database> initializeDb() async {
    Directory directory = await getApplicationCacheDirectory();
    String path = directory.path + 'bookstore.db';
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

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDb();
    }
    return _database;
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
