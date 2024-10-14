import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/book.dart';

class CreateBookWidget extends StatefulWidget {
  final Book? bookModel;
  final ValueChanged<String> onSumbit;

  const CreateBookWidget({
    Key? key,
    this.bookModel,
    required this.onSumbit,
  }) : super(key: key);

  @override
  State<CreateBookWidget> createState() => _CreateBookWidgetState();
}

class _CreateBookWidgetState extends State<CreateBookWidget> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.text = widget.bookModel?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Добавить книгу',
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: const InputDecoration(hintText: 'Title'),
          validator: (value) => value != null && value.isEmpty
              ? 'Некоторые поля не заполнены'
              : null,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Отмена',
              style: TextStyle(fontFamily: 'Poppins'),
            )),
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onSumbit(controller.text);
              }
            },
            child: const Text(
              'ОК',
              style: TextStyle(fontFamily: 'Poppins'),
            ))
      ],
    );
  }
}
