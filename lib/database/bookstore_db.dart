import 'dart:ffi';

import 'package:flutter_practice/models/book_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_practice/database/db_service.dart';
import 'package:flutter_practice/database/bookstore_db.dart';

class BookstoreDB {
  final tableName = 'book';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
      "id" INTEGER NOT NULL,
      "title" TEXT NOT NULL,
      "author" TEXT NOT NULL,
      "genre" TEXT NOT NULL,
      "price" REAL NOT NULL,
      "quantity" INTEGER NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create(
      {required String title,
      required String author,
      required String genre,
      required Float price,
      required int quantity}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert('''
        INSERT INTO $tableName (title, author, genre, price, quantity)
        VALUES (?,?,?,?,?)
      ''', [title, author, genre, price, quantity]);
  }

  Future<List<BookModel>> fetchAll() async {
    final database = await DatabaseService().database;
    final books = await database.rawQuery('''SELECT * from $tableName''');
    return books.map((book) => BookModel.fromSqfliteDB(book)).toList();
  }

  Future<BookModel> fetchById(int id) async {
    final database = await DatabaseService().database;
    final book = await database.rawQuery('''
        SELECT * from $tableName
        WHERE id = ?
        ''', [id]);
    return BookModel.fromSqfliteDB(book.first);
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}
