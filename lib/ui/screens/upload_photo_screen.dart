import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  late String imagePath;
  bool isSelected = false;
  double uploadProgress = 0.0;

  @override
  void initState() {
    imagePath = widget.imagePath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 60,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Upload Profile Picture",
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 20),
                Text(
                  "For verification it is mandatory to upload your profile picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          CircleAvatar(
              radius: 150, backgroundImage: FileImage(File(imagePath))),
          const SizedBox(
            height: 200,
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              onPressed: imagePath != "" ? () {} : null,
              style: TextButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Upload ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Icon(Icons.arrow_upward)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadPic() async {
    final image = File(imagePath);
    final imageName = imagePath.split("/").last;
    final fileRef = storage.ref("users").child(uid!).child(imageName);
    final metaData = SettableMetadata(contentType: "image/jpeg");

    try {
      // upload image to firebase storage database
      UploadTask uploadTask = fileRef.putFile(image, metaData);

      // track upload status and progress
      uploadTask.snapshotEvents.listen((snapshot) {
        switch (snapshot.state) {
          case TaskState.paused:
            // TODO: Handle this case.
            break;
          case TaskState.running:
            setState(() {
              uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
            });

            break;
          case TaskState.success:
            {
              setState(() {
                uploadProgress = 1.0;
              });
            }
            break;
          case TaskState.canceled:
            // TODO: Handle this case.
            break;
          case TaskState.error:
            // TODO: Handle this case.
            break;
        }
      });

      //get url of uploaded image
      final photoUrl = await fileRef.getDownloadURL();

      // save photoUrl to firestore
      await firestore
          .collection("users")
          .doc(uid)
          .update({"photoUrl": photoUrl});
    } on FirebaseException catch (e) {
      //show error in snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    }
  }
}
