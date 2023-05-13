import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharethegood/ui/main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key, required this.accountType})
      : super(key: key);
  final String accountType;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _registerKey = GlobalKey<FormState>();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  final name = TextEditingController();
  final address = TextEditingController();

  bool isLoading = false;
  String? libraryProof;

  @override
  void dispose() {
    name.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _registerKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                  width: double.infinity,
                ),
                Text(
                  "Register your ${widget.accountType}",
                  style: const TextStyle(fontSize: 25),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    "To prevent scam and fraud account registration is required",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  "assets/uploadimage.jpg",
                  height: 250,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          pickImage().then((value) {
                            setState(() {
                              libraryProof = value;
                            });
                          });
                        },
                        child: const Text("Organisation Proof")),
                    libraryProof != null
                        ? const Icon(
                            Icons.check_box,
                            color: Colors.green,
                            size: 30,
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: name,
                  validator: validateName,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: "${widget.accountType} Full Name",
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: address,
                  validator: validateAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: "${widget.accountType} Address",
                      prefixIcon: const Icon(Icons.location_on),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () {
                      register();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoading ? "Uploading Image" : "Register",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 20),
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "enter valid name";
    } else {
      return null;
    }
  }

  String? validateAddress(String? address) {
    if (address == null || address.isEmpty) {
      return "enter valid address";
    } else {
      return null;
    }
  }

  Future<void> register() async {
    final navigator = Navigator.of(context);
    final storage = FirebaseStorage.instance;
    final firestore = FirebaseFirestore.instance;

    //validate user details
    _registerKey.currentState?.save();
    if (!_registerKey.currentState!.validate()) {
      return;
    }
    //show loading indicator
    setState(() {
      isLoading = true;
    });
    try {
      if (libraryProof != null) {

        final proof = File(libraryProof!);
        final proofName = libraryProof?.split("/").last;
        final proofRef = storage.ref("users").child(uid!).child(proofName!);

        final metaData = SettableMetadata(contentType: "image/jpeg");
        // upload image to firebase storage database
        await proofRef.putFile(proof, metaData);

        //get url of uploaded image
        final proofUrl = await proofRef.getDownloadURL();

        //save user data to firestore
        await firestore.collection("users").doc(uid).update({
          "orgProof": proofUrl,
          "orgName": name.text.trim(),
          "address": address.text.trim(),
        }).then((value) {
          // stop loading indicator
          setState(() {
            isLoading = false;
          });
          // navigate to HomeScreen
          navigator.pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen()));
        });
      }
      //catch error
    } on FirebaseException catch (e) {
      //stop loading indicator
      setState(() {
        isLoading = false;
      });
      //show error in snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Something went wrong")),
      );
    }
  }
}
