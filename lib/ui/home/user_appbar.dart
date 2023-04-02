import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';

class UserAppBar extends StatelessWidget {
  const UserAppBar({Key? key}) : super(key: key);
  static final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.data != null) {
            String firstName =
                (snapshot.data!['name']).toString().split(" ").first;
            return AppBar(
              title: Text(" Hi $firstName"),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            ProfileScreen(snapshot: snapshot.data!)));
                  },
                  icon: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        snapshot.data!['photoUrl']),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}
