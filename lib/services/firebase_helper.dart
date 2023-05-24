import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharethegood/services/preferences.dart';

class FirebaseHelper {
  const FirebaseHelper._();
  static Map<String, dynamic>? userData = Preferences.getUserData();

  // collection reference
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final CollectionReference usersCol =
      FirebaseFirestore.instance.collection("users");
  static final CollectionReference donationCol =
      FirebaseFirestore.instance.collection("donations");
  static CollectionReference commentCol(String donationId) =>
      donationCol.doc(donationId).collection("comments");
  static CollectionReference receiverCol(String donationId) =>
      donationCol.doc(donationId).collection("receivers");

  static final String userType = userData!['type'];
  static final String productType = userType == "Ngo" ? "clothes" : "books";

  static final _giverStream =
      usersCol.where("type", isEqualTo: "Individual").snapshots();
  static final _takerStream =
      usersCol.where("type", isNotEqualTo: "Individual").snapshots();
  static final userStream =
      userType == "Individual" ? _giverStream : _takerStream;

  static final _ngoDonationStream = donationCol
      .where("product", isEqualTo: "clothes")
      .where("donate", isEqualTo: true)
      .where("complete", isEqualTo: false)
      .snapshots();
  static final _libraryDonationStream = donationCol
      .where("product", isEqualTo: "books")
      .where("donate", isEqualTo: true)
      .where("complete", isEqualTo: false)
      .snapshots();
  static final _takerDonationStream = userType != "Individual" ? userType == "Ngo"
      ? _ngoDonationStream
          : _libraryDonationStream
      : null;
  static final _giverDonationStream = donationCol
      .where("donate", isEqualTo: true)
      .where("complete", isEqualTo: false)
      .snapshots();
  static final donationStream = userType == "Individual" ? _giverDonationStream : _takerDonationStream;

  static final _takerRequirementStream = donationCol
      .where("product", isEqualTo: productType)
      .where("donate", isEqualTo: false)
      .where("complete", isEqualTo: false)
      .snapshots();
  static final _giverRequirementStream = donationCol
      .where("donate", isEqualTo: false)
      .where("complete", isEqualTo: false)
      .snapshots();
  static final requirementStream = userType == "Individual"
      ? _giverRequirementStream
      : _takerRequirementStream;

  // helper functions

  static Future<Map<String, dynamic>?> getUserData(String? uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return snapshot.data();
  }

  static Future<void> saveUserData(Map<String, dynamic>? data) async {
    await Preferences.saveUserData(data);
    userData = data;
  }
}
