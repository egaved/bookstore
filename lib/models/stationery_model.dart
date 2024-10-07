import 'package:flutter/material.dart';

/*
  Информация о каждом товаре следующая: название, цена, количество единиц
  товара в магазине
*/

class StationeryModel {
  final int id;
  final String name;
  final double price;
  final int quantity;

  StationeryModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});
}
