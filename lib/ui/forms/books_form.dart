import 'package:flutter/material.dart';
import '../widgets/input_text.dart';

class BooksForm extends StatefulWidget {
  const BooksForm({Key? key}) : super(key: key);

  @override
  State<BooksForm> createState() => _BooksFormState();
}

class _BooksFormState extends State<BooksForm> {
  final bookName = TextEditingController();
  final price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Form"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputText(
            label: 'Book Name',
            controller: bookName,
          ),
          InputText(label: "Price", controller: price),
          InputText(label: "Author name", controller: price),
          InputText(label: "Book Name", controller: price),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 55,
              width: 300,
              child: ElevatedButton(onPressed: () {}, child: Text("send data")),
            ),
          )
        ],
      ),
    );
  }
}
