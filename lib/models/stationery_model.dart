import 'package:flutter/material.dart';

/*
  Информация о каждом товаре следующая: название, цена, количество единиц
  товара в магазине
*/

class StationeryModel {
  String name;
  double price;
  int quantity;

  StationeryModel(
      {required this.name, required this.price, required this.quantity});
}
