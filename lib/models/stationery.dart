/*
  Информация о каждом товаре следующая: название, цена, количество единиц
  товара в магазине
*/

class Stationery {
  late int id;
  late String name;
  late double price;
  late int quantity;

  Stationery({required this.name, required this.price, required this.quantity});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['name'] = name;
    map['price'] = price;
    map['quantity'] = quantity;

    return map;
  }

  Stationery.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    price = map['price'];
    quantity = map['quantity'];
  }
}
