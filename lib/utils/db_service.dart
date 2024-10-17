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
    var bookStoreDb = await openDatabase(path,
        version: 2, onCreate: _createDb, onUpgrade: _upgradeDb);
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

  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(''' CREATE TABLE IF NOT EXISTS stationery (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "quantity" INTEGER NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );''');
      await db.execute('''CREATE TABLE IF NOT EXISTS cart (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "product_id" INTEGER,
        "product_type" TEXT,
        "quantity" INTEGER,
        FOREIGN KEY (product_id) REFERENCES book (id) 
          ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES stationery (id) 
          ON DELETE CASCADE
    );''');
    }
  }

  Future<List<Map<String, dynamic>>> getBookMapList() async {
    Database db = await database;
    var res = await db.query('book');
    return res;
  }

  Future<List<Map<String, dynamic>>> getStationeryMapList() async {
    Database db = await database;
    var res = await db.query('stationery');
    return res;
  }

  Future<int> createBook(Book book) async {
    var db = await database;
    var res = await db.insert('book', book.toMap());
    return res;
  }

  Future<int> createStationery(Stationery st) async {
    var db = await database;
    var res = await db.insert('stationery', st.toMap());
    return res;
  }

  Future<int> deleteBook(int id) async {
    var db = await database;
    int res = await db.rawDelete('''DELETE FROM book WHERE id = $id''');
    return res;
  }

  Future<int> deleteStationery(int id) async {
    var db = await database;
    int res = await db.rawDelete('''DELETE FROM stationery WHERE id = $id''');
    return res;
  }

  Future<int?> getBookAmount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('''SELECT COUNT (*) FROM book''');
    int? res = Sqflite.firstIntValue(x);
    return res;
  }

  Future<int?> getStationeryAmount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('''SELECT COUNT (*) FROM stationery''');
    int? res = Sqflite.firstIntValue(x);
    return res;
  }

  Future<List<Book>> fetchAllBooks() async {
    var bookMapList = await getBookMapList();
    int count = bookMapList.length;

    List<Book> bookList = List<Book>.empty(growable: true);

    for (int i = 0; i < count; i++) {
      bookList.add(Book.fromMapObject(bookMapList[i]));
    }

    return bookList;
  }

  Future<List<Stationery>> fetchAllStationery() async {
    var stMapList = await getStationeryMapList();
    int count = stMapList.length;

    List<Stationery> stationeryList = List<Stationery>.empty(growable: true);

    for (int i = 0; i < count; i++) {
      stationeryList.add(Stationery.fromMapObject(stMapList[i]));
    }

    return stationeryList;
  }
}
