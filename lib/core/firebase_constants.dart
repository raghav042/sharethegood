import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConstants {
  const FirebaseConstants._();
  static final auth = FirebaseAuth.instance;
  static final fcm = FirebaseMessaging.instance;
  static final storage = FirebaseStorage.instance;
  static final firestore = FirebaseFirestore.instance;

  static final User? user = auth.currentUser;
  static final String? uid = user?.uid;

  static final CollectionReference usersRef = firestore.collection("users");
}
