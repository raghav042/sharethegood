import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentSnapshot> getUserData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  return await FirebaseFirestore.instance.collection("users").doc(uid).get();
}
