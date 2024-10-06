import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/cart.dart';
import 'package:flutter_practice/pages/item_list.dart';

import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      routes: {
        '/': (context) => HomePage(),
        '/itemlist': (context) => ItemListPage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}
