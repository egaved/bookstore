import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
          name: 'Книги',
          iconPath: 'assets/icons/book.svg',
          boxColor: Color.fromARGB(255, 241, 224, 143)),
    );

    categories.add(
      CategoryModel(
          name: 'Канцелярия',
          iconPath: 'assets/icons/pen.svg',
          boxColor: Color(0xffC58BF2)),
    );
    return categories;
  }
}
