/*
  Сведения о каждой книге содержат: фамилию автора, название, жанр, цену,
  количество книг в магазине.
*/

class Book {
  late int id;

  late String author;
  late String title;
  late String genre;
  late double price;
  late int quantity;

  Book(
      {required this.id,
      required this.author,
      required this.title,
      required this.genre,
      required this.price,
      required this.quantity});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    map['author'] = author;
    map['title'] = title;
    map['genre'] = genre;
    map['price'] = price;
    map['quantity'] = quantity;

    return map;
  }

  Book.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    author = map['author'];
    title = map['title'];
    genre = map['genre'];
    price = map['price'];
    quantity = map['quantity'];
  }
}
