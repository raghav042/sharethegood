import 'package:flutter/material.dart';
import 'package:sharethegood/ui/widgets/input_text.dart';

class ClothesForm extends StatefulWidget {
  const ClothesForm({Key? key}) : super(key: key);

  @override
  State<ClothesForm> createState() => _ClothesFormState();
}

class _ClothesFormState extends State<ClothesForm> {
  final cloth = TextEditingController();
  final clothSize = TextEditingController();
  final clothGender = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Form"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputText(
            label: 'Cloth Name',
            controller: cloth,
          ),
          InputText(label: "Price", controller: clothSize),
          InputText(label: "Author name", controller: clothGender),
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
