import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_practice/database/bookstore_db.dart';
import 'package:flutter_practice/models/book_model.dart';
import 'package:flutter_svg/svg.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String? categoryName;
  Future<List<BookModel>>? futureBooks;
  final bookstoreDB = BookstoreDB();
  int itemCount = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchBooks();
  }

  void fetchBooks() {
    setState(() {
      futureBooks = bookstoreDB.fetchAll();
    });
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
    TextTheme titleStyle = Theme.of(context).textTheme;
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
                    'Название. (Фамилия)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    'Жанр | На складе: 0',
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
                        '0.00 р.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  )));
        },
      );
    }
    return null;
  }

  FloatingActionButton buildFloatingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {},
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
}
