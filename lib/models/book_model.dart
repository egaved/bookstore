import 'package:flutter/material.dart';

/*
  Сведения о каждой книге содержат: фамилию автора, название, жанр, цену,
  количество книг в магазине.
*/

class BookModel {
  String authorSurname;
  String title;
  String genre;
  double price;
  int quantity;

  BookModel(
      {required this.authorSurname,
      required this.title,
      required this.genre,
      required this.price,
      required this.quantity});
}
