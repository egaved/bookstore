/*
  Информация о каждом товаре следующая: название, цена, количество единиц
  товара в магазине
*/

class Stationery {
  final int id;
  final String name;
  final double price;
  final int quantity;

  Stationery(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});
}
