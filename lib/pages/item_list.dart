import 'dart:developer';

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
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: Icon(Icons.book_rounded),
                title: Text(
                  'Название',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  'Фамилия | Жанр',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                trailing: Wrap(
                  spacing: 10.0,
                  children: [
                    Text(
                      '0 ₽',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/item_info',
                  );
                },
              ));
        },
      );
    }
    return null;
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
          onPressed: () {},
          icon: SvgPicture.asset('assets/icons/search-bold.svg'),
        ),
      ],
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = dbService.initializeDb();
    dbFuture.then((database) {
      Future<List<Book>> bookListFuture = dbService.fetchAll();
      bookListFuture.then((bookList) {
        setState(() {
          this.bookList = bookList;
          this.itemCount = bookList.length;
        });
      });
    });
  }
}
