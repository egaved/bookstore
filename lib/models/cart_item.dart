class CartItem {
  final int id;
  final int productId;
  final String productType;
  final int quantity;
  final String? title;
  final String? author;
  final String? genre;
  final String? name;
  final double? price;
  final int? remains;

  CartItem(
      {required this.id,
      required this.productId,
      required this.productType,
      required this.quantity,
      this.title,
      this.author,
      this.genre,
      this.name,
      this.price,
      this.remains});

  factory CartItem.fromMapObject(
      Map<String, dynamic> map, Map<Object, dynamic> product) {
    return CartItem(
        id: map['id'],
        productId: map['product_id'],
        productType: map['product_type'],
        quantity: map['quantity'],
        title: product['title'],
        author: product['author'],
        genre: product['genre'],
        name: product['name'],
        price: product['price'],
        remains: product['quantity']);
  }
}
