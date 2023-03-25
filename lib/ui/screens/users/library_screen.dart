import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sharethegood/ui/screens/profile/profile_screen.dart';

class LibraryScreen extends StatelessWidget {
   LibraryScreen({Key? key}) : super(key: key);

  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("type", isEqualTo: "Library")
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else if (snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  return uid != snapshot.data!.docs[index]['uid']
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        snapshot: snapshot.data!.docs[index])));
                          },
                          leading: CircleAvatar(
                            child: Text((snapshot.data!.docs[index]['name']
                                .toString()
                                .toUpperCase()[0])),
                          ),
                          title: Text(snapshot.data!.docs[index]['name']),
                          subtitle: Text(snapshot.data!.docs[index]['email']),
                        )
                      : const SizedBox();
                });
          } else {
            return const Center(child: Text("No data found"));
          }
        });
  }
}