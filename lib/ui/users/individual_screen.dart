import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';
import 'package:sharethegood/ui/users/other_user_profile_screen.dart';

class IndividualScreen extends StatelessWidget {
  IndividualScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("type", isEqualTo: "Individual")
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
                  return FirebaseHelper.userData!['uid'] != snapshot.data!.docs[index]['uid']
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherUserProfileScreen(snapshot: snapshot.data!.docs[index])));
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
