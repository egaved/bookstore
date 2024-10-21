import 'package:flutter/material.dart';
import 'package:flutter_practice/models/cart_item.dart';
import 'package:flutter_practice/utils/db_service.dart';
import 'package:flutter_practice/widgets/custom_appbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DbService _dbService = DbService();

  late Future<List<CartItem>> _items;
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    _items = _dbService.getCartItems();
  }

  void _updateQuantity(CartItem cartItem, int newQuantity) async {
    final db = await DbService().database;
    await db.update(
      'cart',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );
    setState(() {
      _items = DbService().getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Корзина'),
      body: FutureBuilder<List<CartItem>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Корзина пуста'));
          } else {
            final cartItems = snapshot.data!;
            final totalPrice = cartItems.fold(
              0.0,
              (previousValue, cartItem) =>
                  previousValue +
                  (cartItem.price != null
                      ? cartItem.price! * cartItem.quantity
                      : 0.0),
            );

            return Stack(
              children: [
                ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final itemTotalPrice = cartItem.price != null
                        ? cartItem.price! * cartItem.quantity
                        : 0.0;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.productType == 'book'
                                  ? '${cartItem.title} (${cartItem.author})'
                                  : '${cartItem.name}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Количество: ${cartItem.quantity}\nЦена: ${itemTotalPrice.toStringAsFixed(2)} ₽',
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (cartItem.quantity > 1) {
                                      _updateQuantity(
                                          cartItem, cartItem.quantity - 1);
                                    }
                                  },
                                ),
                                Text('${cartItem.quantity}'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (cartItem.remains != null &&
                                        cartItem.quantity < cartItem.remains!) {
                                      _updateQuantity(
                                          cartItem, cartItem.quantity + 1);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // Удаление элемента из корзины
                                    DbService().deleteFromCart(cartItem.id);
                                    setState(() {
                                      _items = DbService().getCartItems();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      'Общая стоимость: ${totalPrice.toStringAsFixed(2)} ₽',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
