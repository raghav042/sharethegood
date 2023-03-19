import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static final String? uid = FirebaseAuth.instance.currentUser?.uid;
  static late final DocumentSnapshot userSnapshot;
  static late final String name;
  static late final String firstname;
  static late final String email;
  static late final String photoUrl;

  static Future<void> getUserData() async {
    userSnapshot = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    name = userSnapshot['name'];
    firstname = userSnapshot['name'].toString().split(" ").first;
    email = userSnapshot['email'];
    photoUrl = userSnapshot['photoUrl'];
  }
}
