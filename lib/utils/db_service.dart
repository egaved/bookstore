import 'package:flutter_practice/models/cart_item.dart';
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

  Future<List<Map<String, dynamic>>> getCartMap() async {
    Database db = await database;
    var res = await db.query('cart');
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

  Future<int?> getCartItemsAmount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('''SELECT COUNT (*) FROM cart''');
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

    bookList.sort((a, b) => a.title.compareTo(b.title));

    return bookList;
  }

  Future<List<Stationery>> fetchAllStationery() async {
    var stMapList = await getStationeryMapList();
    int count = stMapList.length;

    List<Stationery> stationeryList = List<Stationery>.empty(growable: true);

    for (int i = 0; i < count; i++) {
      stationeryList.add(Stationery.fromMapObject(stMapList[i]));
    }

    stationeryList.sort((a, b) => a.name.compareTo(b.name));

    return stationeryList;
  }

  Future<bool> isItemInCart(int id) async {
    final db = await database;
    final result = await db.query(
      'cart',
      where: 'product_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<void> addBookToCart(int bookId, int quantity) async {
    final db = await database;
    await db.insert(
      'cart',
      {'product_id': bookId, 'product_type': 'book', 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addStationeryToCart(int stationeryId, int quantity) async {
    final db = await database;
    await db.insert(
      'cart',
      {
        'product_id': stationeryId,
        'product_type': 'stationery',
        'quantity': quantity
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Book>> fetchBooksByName(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'book',
      where: 'title LIKE ? OR genre LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Book.fromMapObject(maps[i]);
    });
  }

  Future<List<Stationery>> fetchStationeryByName(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stationery',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Stationery.fromMapObject(maps[i]);
    });
  }

  Future<Map<Object, dynamic>> getBookById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'book',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }

  Future<Map<Object, dynamic>> getStationeryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'stationery',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return {};
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    List<CartItem> cartItems = [];

    for (var map in maps) {
      if (map['product_type'] == 'book') {
        final book = await getBookById(map['product_id']);
        cartItems.add(CartItem.fromMapObject(map, book));
      } else if (map['product_type'] == 'stationery') {
        final stationery = await getStationeryById(map['product_id']);
        cartItems.add(CartItem.fromMapObject(map, stationery));
      }
    }

    return cartItems;
  }

  Future<void> deleteFromCart(int id) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
