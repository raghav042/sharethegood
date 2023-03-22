import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethegood/ui/screens/home_screen.dart';
import '../widgets/input_text.dart';
import '../../core/data/app_constants.dart';

class BooksForm extends StatefulWidget {
  const BooksForm({Key? key}) : super(key: key);

  @override
  State<BooksForm> createState() => _BooksFormState();
}

class _BooksFormState extends State<BooksForm> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final bookName = TextEditingController();
  final authorName = TextEditingController();
  final number = TextEditingController();
  String? imagePath;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${donate ? "Donate" : "Take"} Book Form"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            donate
                ? ElevatedButton(
                    onPressed: () {
                      updateImage(context);
                    },
                    child: Text(
                      imagePath != null ? "Replace Images" : "Pick Image",
                    ),
                  )
                : const SizedBox(),
            donate && imagePath != null
                ? Image.file(
                    File(imagePath!),
                    height: 250,
                    filterQuality: FilterQuality.low,
                  )
                : const SizedBox(),
            InputText(
              label: 'Book Name',
              controller: bookName,
            ),
            InputText(label: "Author name", controller: authorName),
            InputText(label: "Number of Books", controller: number),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 55,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      createDonation();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isUploading ? "Uploading Data" : "send data"),
                        const SizedBox(width: 20),
                        isUploading
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 50,
                child: Divider(
                  thickness: 3,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text("Pick image from"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.tertiaryContainer,
                      foregroundColor: colorScheme.onTertiaryContainer,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.tertiaryContainer,
                      foregroundColor: colorScheme.onTertiaryContainer,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Gallery"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      constraints: const BoxConstraints(maxHeight: 200),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    setState(() {
      imagePath = image?.path;
    });
  }

  Future<void> createDonation() async {
    final navigator = Navigator.of(context);
    String? imageUrl;
    setState(() {
      isUploading = true;
    });
    if (donate) {
      imageUrl = await uploadImageToStorage();
    }
    saveToFirestore(imageUrl);
    setState(() {
      isUploading = false;
    });
    navigator
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Future<String?> uploadImageToStorage() async {
    final image = File(imagePath!);
    final imageName = imagePath?.split("/").last;
    final fileRef =
        FirebaseStorage.instance.ref("users").child(uid!).child(imageName!);
    final metaData = SettableMetadata(contentType: "image/jpeg");

    try {
      // upload image to firebase storage database
      var snapshot = await fileRef.putFile(image, metaData);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      showError(e);
      return null;
    }
  }

  Future<void> saveToFirestore(String? imageUrl) async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    try {
      // save data to firestore
      await FirebaseFirestore.instance
          .collection("donations")
          .doc(timeStamp.toString())
          .set({
        "uid": uid,
        "complete": false,
        "donate": donate,
        "image": imageUrl ?? "",
        "product": "book",
        "label": bookName.text.trim(),
        "description": authorName.text.trim(),
        "number": number.text.trim(),
      });
    } on FirebaseException catch (e) {
      showError(e);
    }
  }

  void showError(FirebaseException e) {
    setState(() {
      isUploading = false;
    });
    //show error in snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Something went wrong")),
    );
  }
}
