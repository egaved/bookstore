import 'package:flutter/material.dart';

/*
  Сведения о каждой книге содержат: фамилию автора, название, жанр, цену,
  количество книг в магазине.
*/

class BookModel {
  final int id;

  final String author;
  final String title;
  final String genre;
  final double price;
  final int quantity;

  BookModel(
      {required this.id,
      required this.author,
      required this.title,
      required this.genre,
      required this.price,
      required this.quantity});

  factory BookModel.fromSqfliteDB(Map<String, dynamic> map) => BookModel(
        id: map['id']?.toInt() ?? 0,
        author: map['author'] ?? '',
        title: map['title'] ?? '',
        genre: map['genre'] ?? '',
        price: map['price'] ?? 0.0,
        quantity: map['quantity'] ?? 0,
      );
}
