import 'package:flutter/material.dart';

class ItemInfoPage extends StatefulWidget {
  const ItemInfoPage({super.key});

  @override
  State<ItemInfoPage> createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          height: 300,
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
            padding: const EdgeInsets.all(15.0), // Добавьте отступы, если нужно
            // child: ListView.separated(

            // )
          ),
        ),
      ]),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Действия',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: false,
    );
  }
}
