import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'profile_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userData = FirebaseHelper.userData;

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  bool isUploading = false;
  double uploadProgress = 0.0;
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
              width: double.infinity,
            ),
            SizedBox(
              height: 210,
              width: 210,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Hero(
                    tag: "profile_pic",
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: imagePath != null
                            ? Image.file(
                                File(imagePath!),
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: userData!['photoUrl'],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  isUploading
                      ? uploadProgress != 0
                          ? SizedBox(
                              height: 210,
                              width: 210,
                              child: CircularProgressIndicator(
                                value: uploadProgress,
                              ),
                            )
                          : const SizedBox(
                              height: 210,
                              width: 210,
                              child: CircularProgressIndicator(),
                            )
                      : const SizedBox(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      elevation: 0.5,
                      onPressed: () {
                        updateImage(context);
                      },
                      child: const Icon(Icons.camera),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 4),
              child: Text(
                userData!['name'],
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Text(
              "Email :  ${userData!['email']}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Account Type :  ${userData!['type']}",
              style: const TextStyle(fontSize: 16),
            ),
            ProfileSettings(uid: userData!['uid']),
            imagePath != null
                ? Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        uploadPic();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: isUploading
                            ? colorScheme.tertiaryContainer
                            : colorScheme.primaryContainer,
                        foregroundColor: isUploading
                            ? colorScheme.onTertiaryContainer
                            : colorScheme.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isUploading
                                ? "Uploading"
                                : uploadProgress != 1
                                    ? "Upload "
                                    : "Uploaded",
                            style: const TextStyle(fontSize: 18),
                          ),
                          isUploading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.arrow_upward)
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 50),
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

  Future<void> uploadPic() async {
    final image = File(imagePath!);
    final imageName = imagePath?.split("/").last;
    final fileRef =
        storage.ref("users").child(userData!['uid']).child(imageName!);

    final metaData = SettableMetadata(contentType: "image/jpeg");

    setState(() {
      isUploading = true;
    });

    try {
      // upload image to firebase storage database
      await fileRef.putFile(image, metaData).then((snapshot) async {
        // track upload status and progress

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
              //get url of uploaded image
              final photoUrl = await fileRef.getDownloadURL();

              // save photoUrl to firestore
              await firestore
                  .collection("users")
                  .doc(userData!['uid'])
                  .update({"photoUrl": photoUrl});
              setState(() {
                isUploading = false;
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
    } on FirebaseException catch (e) {
      setState(() {
        isUploading = false;
      });
      //show error in snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    }
  }
}
