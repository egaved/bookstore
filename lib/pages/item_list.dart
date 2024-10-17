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
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: buildItemList(),
      floatingActionButton: buildFloatingButton(),
    );
  }

  ListView? buildItemList() {
    if (categoryName == 'Книги') {
      updateListView();
      return _buildBookList();
    } else if (categoryName == 'Канцелярия') {
      updateListView();
      return _buildStationeryList();
    }
    return null;
  }

  ListView _buildStationeryList() {
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
              if (value == 'delete') {
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
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
          leading: Icon(Icons.mode_edit),
          title: Text(
            stationeryList[index].name,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: Column(
            // spacing: 10.0,
            children: [
              Text(
                '${stationeryList[index].price}₽',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                '${stationeryList[index].quantity.toString()} шт.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ));
  }

  ListView _buildBookList() {
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
              if (value == 'delete') {
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
        color: Colors.white,
        elevation: 2.0,
        child: ListTile(
          leading: Icon(Icons.book_rounded),
          title: Text(
            bookList[index].title,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle: Text(
            '${bookList[index].author} | ${bookList[index].genre}',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          trailing: Column(
            // spacing: 10.0,
            children: [
              Text(
                '${bookList[index].price}₽',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              Text(
                '${bookList[index].quantity.toString()} шт.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ));
  }

  FloatingActionButton buildFloatingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed('/add_item', arguments: categoryName);
      },
    );
  }

  AppBar buildAppBar() {
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
            onPressed: () {}, icon: SvgPicture.asset('assets/icons/cart.svg')),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset('assets/icons/search-alt-1-svgrepo-com.svg'),
        ),
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
