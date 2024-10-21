import 'dart:developer';

import 'package:flutter_practice/models/stationery.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/book.dart';
import 'package:flutter_practice/utils/db_service.dart';
import 'package:flutter_svg/svg.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});
  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String? categoryName;

  late DbService dbService = DbService();

  List<Book> bookList = List.empty(growable: true);
  List<Stationery> stationeryList = List.empty(growable: true);

  int itemCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      log('provide args');
      return;
    }
    if (args is! String) {
      log('provide string arg');
      return;
    }
    categoryName = args;
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (categoryName == 'Книги') ...[
            _buildBookList(),
          ] else if (categoryName == 'Канцелярия') ...[
            _buildStationeryList(),
          ],
        ],
      ),
      floatingActionButton: buildFloatingButton(),
    );
  }

  ListView _buildStationeryList() {
    updateListView();
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPressStart: (details) {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                details.globalPosition.dy,
                details.globalPosition.dx + 1,
                details.globalPosition.dy + 1,
              ),
              items: [
                PopupMenuItem(
                  value: 'toCart',
                  child: Text('Добавить в корзину'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Удалить'),
                ),
              ],
            ).then((value) {
              if (value == 'toCart') {
                _addItemToCart(stationeryList[index]);
              } else if (value == 'delete') {
                setState(() {
                  deleteStationery(stationeryList[index].id);
                });
              }
            });
          },
          child: stationeryCard(index, context),
        );
      },
    );
  }

  Card stationeryCard(int index, BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 229, 195, 255),
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(stationeryList[index].name,
            style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('На складе: ${stationeryList[index].quantity}'),
        trailing: Text(
          '${stationeryList[index].price} ₽',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  ListView _buildBookList() {
    updateListView();
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPressStart: (details) {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                details.globalPosition.dx,
                details.globalPosition.dy,
                details.globalPosition.dx + 1,
                details.globalPosition.dy + 1,
              ),
              items: [
                PopupMenuItem(
                  value: 'toCart',
                  child: Text('Добавить в корзину'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Удалить'),
                ),
              ],
            ).then((value) {
              if (value == 'toCart') {
                _addItemToCart(bookList[index]);
              } else if (value == 'delete') {
                setState(() {
                  deleteBook(bookList[index].id);
                });
              }
            });
          },
          child: bookCard(index, context),
        );
      },
    );
  }

  Card bookCard(int index, BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 245, 235, 188),
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(bookList[index].title,
            style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            'Автор: ${bookList[index].author}\nЖанр: ${bookList[index].genre}\nНа складе: ${bookList[index].quantity} '),
        trailing: Text(
          '${bookList[index].price} ₽',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed('/add_item', arguments: categoryName);
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(categoryName!,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
            icon: SvgPicture.asset('assets/icons/cart.svg')),
      ],
    );
  }

  void deleteBook(int id) async {
    int res = await dbService.deleteBook(id);
    if (res != 0) {
      _showAlertDialog('Удалено!');
    } else {
      _showAlertDialog('Ошибка удаления');
    }
  }

  void deleteStationery(int id) async {
    int res = await dbService.deleteStationery(id);
    if (res != 0) {
      _showAlertDialog('Удалено!');
    } else {
      _showAlertDialog('Ошибка удаления');
    }
  }

  _showAlertDialog(String msg) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _addItemToCart(dynamic item) async {
    bool isInCart = false;

    if (item is Book) {
      isInCart = await DbService().isItemInCart(item.id);
      if (isInCart) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Товар уже в корзине')),
          );
        }
      } else {
        await DbService().addBookToCart(item.id, 1);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Книга добавлена в корзину')),
          );
        }
      }
    } else if (item is Stationery) {
      isInCart = await DbService().isItemInCart(item.id);
      if (isInCart) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Товар уже в корзине')),
          );
        }
      } else {
        await DbService().addStationeryToCart(item.id, 1);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Товар добавлен в корзину')),
          );
        }
      }
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dbService.initDatabase();
    dbFuture.then((database) {
      if (categoryName == 'Книги') {
        Future<List<Book>> bookListFuture = dbService.fetchAllBooks();
        bookListFuture.then((bookList) {
          setState(() {
            this.bookList = bookList;
            this.itemCount = bookList.length;
          });
        });
      } else if (categoryName == 'Канцелярия') {
        Future<List<Stationery>> stationeryListFuture =
            dbService.fetchAllStationery();
        stationeryListFuture.then((stationeryList) {
          setState(() {
            this.stationeryList = stationeryList;
            this.itemCount = stationeryList.length;
          });
        });
      }
    });
  }
}
