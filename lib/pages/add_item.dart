import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/book.dart';
import 'package:flutter_practice/utils/db_service.dart';
import 'package:flutter_practice/widgets/custom_appbar.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String? categoryName;
  late DbService dbService = DbService();

  TextEditingController bookTitleController = TextEditingController();
  TextEditingController bookAuthorController = TextEditingController();
  TextEditingController bookGenreController = TextEditingController();
  TextEditingController bookPriceController = TextEditingController();
  TextEditingController bookQuantityController = TextEditingController();

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
      appBar: CustomAppBar(title: categoryName!, showActions: false),
      backgroundColor: Colors.white,
      body: Container(
        height: 475,
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xff1D1617).withOpacity(0.25),
                blurRadius: 40,
                spreadRadius: 0.0,
              )
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: TextField(
                  controller: bookAuthorController,
                  decoration: InputDecoration(
                      hintText: 'Фамилия автора',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: TextField(
                  controller: bookTitleController,
                  decoration: InputDecoration(
                      hintText: 'Название книги',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: TextField(
                  controller: bookGenreController,
                  decoration: InputDecoration(
                      hintText: 'Жанр',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: TextField(
                  controller: bookPriceController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  decoration: InputDecoration(
                      hintText: 'Цена (₽)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onChanged: (value) {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 15),
                child: TextField(
                  controller: bookQuantityController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: InputDecoration(
                      hintText: 'Количество в магазине',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onChanged: (value) {},
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // Получаем значения из контроллеров
                    String title = bookTitleController.text;
                    String author = bookAuthorController.text;
                    String genre = bookGenreController.text;
                    double price =
                        double.tryParse(bookPriceController.text) ?? 0.0;
                    int quantity =
                        int.tryParse(bookQuantityController.text) ?? 0;

                    // Создаем объект Book
                    Book book = Book(
                      title: title,
                      author: author,
                      genre: genre,
                      price: price,
                      quantity: quantity,
                    );
                    dbService.createBook(book);
                    debugPrint(dbService.getBookAmount().toString() +
                        '@@@@@@@@@@@@@@@@@@@');
                  },
                  child: Text('Добавить'))
            ],
          ),
        ),
      ),
    );
  }
}
