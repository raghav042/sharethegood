import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethegood/core/notification/fcm_helper.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/main_screen.dart';
import 'donation_details.dart';

class AvailableDonationTile extends StatelessWidget {
  const AvailableDonationTile({Key? key, required this.snapshot})
      : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DonationDetails(snapshot: snapshot)));
      },
      onLongPress: snapshot['receiverId'] == FirebaseHelper.userData!['uid']
          ? () {
              updateRecord(context);
            }
          : null,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            snapshot["image"] != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: snapshot['image'],
                      filterQuality: FilterQuality.none,
                      height: 200,
                      width: 150,
                      maxHeightDiskCache: 200,
                      maxWidthDiskCache: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
            const Spacer(),
            SizedBox(
              width: snapshot["image"] != ""
                  ? MediaQuery.of(context).size.width - 205
                  : MediaQuery.of(context).size.width - 50,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(snapshot['photoUrl']),
                      ),
                      const Spacer(),
                      Text(
                        snapshot['quantity'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        snapshot['product'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot['label'].toString().toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot['shortDesc'],
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot['longDesc'],
                    maxLines: 3,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateRecord(BuildContext context) {
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
              child: Text("Is this product Successfully donated"),
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
                      backgroundColor: colorScheme.surfaceVariant,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UploadProductimage(
                                  donationId: snapshot['donationId'])));
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Yes Received"),
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
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Not Received"),
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
}

class UploadProductimage extends StatefulWidget {
  const UploadProductimage({Key? key, required this.donationId})
      : super(key: key);
  final String donationId;

  @override
  State<UploadProductimage> createState() => _UploadProductimageState();
}

class _UploadProductimageState extends State<UploadProductimage> {
  String? imagePath;
  bool isUploading = false;
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  String? photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Procuct Image"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
            width: double.infinity,
          ),
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
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: 300,
            child: OutlinedButton.icon(
                onPressed: () {
                  showImagePicker(context);
                },
                icon: Icon(Icons.upload),
                label: Text("Pick Image")),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: 300,
            child: ElevatedButton.icon(
                onPressed: () {
                  updateDonationEntry();
                },
                icon: Icon(Icons.upload),
                label: Text(isUploading ? "Uploading" : "Upload Image")),
          )
        ],
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
                      Navigator.of(context).pop();
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
                      Navigator.of(context).pop();
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

  Future<void> updateDonationEntry() async {
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
      await FirebaseHelper.donationCol
          .doc(widget.donationId)
          .update({"complete": true});
      // save data to firestore
      await firestore.collection("media").doc(timeStamp.toString()).set({
        "postedBy": FirebaseHelper.userData!['uid'],
        "photoUrl": FirebaseHelper.userData!['photoUrl'],
        "name": FirebaseHelper.userData!['name'],
        "phone": FirebaseHelper.userData!['phone'],
        "complete": false,
        "receiverId": "",
        "likes": 0,
        "dislikes": 0,
        "donationId": widget.donationId,
        "id": timeStamp.toString(),
        "imageUrl": imageUrl ?? "",
        "quote": "I received the product",
      });

      //show error in snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entery closed successfully")),
      );
      await FcmHelper.sendPushMessage(
          title: "donation entry closed successfully");
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
