import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .where("receiver", isEqualTo: FirebaseHelper.userData!['uid'])
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 6),
                    child: ListTile(
                      title: Text(snapshot.data?.docs[index]['sender']),
                      subtitle: Text(snapshot.data?.docs[index]['message']),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      tileColor: Colors.pink.shade100,
                    ),
                  );
                });
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.notifications,
                    size: 120,
                    color: Colors.grey.shade400,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "No notification found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
