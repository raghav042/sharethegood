import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethegood/core/notification/fcm_helper.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/main_screen.dart';
import 'input_text.dart';
import 'package:sharethegood/core/labels.dart';

class DonationForm extends StatefulWidget {
  const DonationForm({Key? key, required this.donate}) : super(key: key);
  final bool donate;

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  String? photoUrl;
  final label = TextEditingController();
  final shortDesc = TextEditingController();
  final longDesc = TextEditingController();
  final quantity = TextEditingController();
  String? imagePath;
  bool isUploading = false;
  String product = "books";

  @override
  void initState() {
    getUserImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.donate ? "Donate" : "Required")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isUploading ? const LinearProgressIndicator() : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 300,
                child: imagePath == null
                    ? Image.asset(
                        "assets/upload_media.jpg",
                        height: 300,
                      )
                    : Image.file(File(imagePath!)),
              ),
            ),
            InputText(label: 'Title', controller: label),
            buildProductType(colorScheme),
            InputText(label: "Short Description", controller: shortDesc),
            InputText(label: "Long Description", controller: longDesc),
            InputText(label: "Quantity", controller: quantity),
            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.donate
                      ? imagePath != null
                          ? () {
                              createDonation();
                            }
                          : null
                      : () {
                          createDonation();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isUploading ? "Uploading" : "Upload",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 20),
                      isUploading
                          ? CircularProgressIndicator(
                              backgroundColor: colorScheme.primary,
                              color: colorScheme.onPrimary,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showImagePicker(context);
        },
        icon: const Icon(Icons.image),
        label: Text(imagePath == null ? "Add image" : "Change Image"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget buildProductType(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 25,
      ),
      child: InputDecorator(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(6),
          border: OutlineInputBorder(),
        ),
        child: DropdownButton<String>(
            isExpanded: true,
            value: product,
            hint: const Row(
              children: [
                Icon(Icons.category),
                SizedBox(width: 15),
                Text("User Type"),
              ],
            ),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onBackground,
            ),
            borderRadius: BorderRadius.circular(8.0),
            underline: const SizedBox(),
            items: donationLabels
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Row(
                        children: [
                          const Icon(Icons.category),
                          const SizedBox(width: 15),
                          Text(e),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                product = value!;
              });
            }),
      ),
    );
  }

  void showImagePicker(BuildContext context) {
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
    final image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 1000,
      maxWidth: 1000,
      imageQuality: 50,
    );
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
    if (imagePath != null) {
      imageUrl = await uploadImageToStorage();
    }
    await saveToFirestore(imageUrl);
    setState(() {
      isUploading = false;
    });
    navigator.pushAndRemoveUntil(
        (MaterialPageRoute(builder: (_) => const MainScreen())),
        (route) => false);
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
      await firestore.collection("donations").doc(timeStamp.toString()).set({
        "postedBy": FirebaseHelper.userData!['uid'],
        "photoUrl": FirebaseHelper.userData!['photoUrl'],
        "name": FirebaseHelper.userData!['name'],
        "phone": FirebaseHelper.userData!['phone'],
        "complete": false,
        "donate": widget.donate,
        "receiverId": "",
        "likes": 0,
        "dislikes": 0,
        "donationId": timeStamp.toString(),
        "image": imageUrl ?? "",
        "product": product,
        "label": label.text.trim(),
        "shortDesc": shortDesc.text.trim(),
        "longDesc": longDesc.text.trim(),
        "quantity": quantity.text.trim(),
      });

      String val = widget.donate == true ? "give" : "take";
      await firestore.collection("users").doc(uid).get().then((value) async {
        await firestore
            .collection("users")
            .doc(uid)
            .update({val: value[val] + 1});
      });
      //show error in snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your product added successfully")),
      );
      await FcmHelper.sendPushMessage(
        title: widget.donate == true
            ? "${label.text.trim()} available"
            : "${label.text.trim()} required",
        content: shortDesc.text.trim(),
      );
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

  Future<void> getUserImage() async {
    final userData = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    photoUrl = userData['photoUrl'];
  }
}
