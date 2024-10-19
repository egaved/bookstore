import 'package:flutter/material.dart';
import 'package:flutter_practice/models/book.dart';
import 'package:flutter_practice/models/category.dart';
import 'package:flutter_practice/models/stationery.dart';
import 'package:flutter_practice/utils/db_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];

  final TextEditingController _searchController = TextEditingController();
  final DbService _dbService = DbService();
  List<dynamic> _foundItems = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _foundItems = [];
      });
      return;
    }

    _searchItems(query);
  }

  Future<void> _searchItems(String query) async {
    final books = await _dbService.fetchBooksByName(query);
    final stationery = await _dbService.fetchStationeryByName(query);

    setState(() {
      _foundItems = [...books, ...stationery];
    });
  }

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          if (_searchController.text.isEmpty) ...[
            SizedBox(
              height: 40,
            ),
            _categorySection(),
          ] else
            _searchResultsSection(),
        ],
      ),
    );
  }

  Column _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 23),
          child: Text(
            'Категории',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                width: 25,
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String categoryName = categories[index].name;
                return InkWell(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: categories[index].boxColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: SvgPicture.asset(categories[index].iconPath),
                        ),
                        Text(
                          categories[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/item_list',
                      arguments: categoryName,
                    );
                  },
                );
              },
            ))
      ],
    );
  }

  Expanded _searchResultsSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: _foundItems.length,
        itemBuilder: (context, index) {
          final item = _foundItems[index];
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
                ],
              ).then((value) {
                if (value == 'toCart') {}
              });
            },
            child: item is Book ? _bookCard(item) : _stationeryCard(item),
          );
        },
      ),
    );
  }

  Card _stationeryCard(Stationery item) {
    return Card(
      color: Color.fromARGB(255, 229, 195, 255),
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(item.name, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Канцелярия\nНа складе: ${item.quantity}'),
        trailing: Text(
          '${item.price} ₽',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Card _bookCard(Book item) {
    return Card(
      color: Color.fromARGB(255, 245, 235, 188),
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            'Автор: ${item.author}\nЖанр: ${item.genre}\nНа складе: ${item.quantity} '),
        trailing: Text(
          '${item.price} ₽',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0,
        )
      ]),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Поиск товаров',
            hintStyle: TextStyle(
              color: Color(0xffDDDADA),
              fontSize: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/Search.svg'),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Книжный магазин',
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
          icon: SvgPicture.asset('assets/icons/cart.svg'),
        ),
      ],
    );
  }
}
