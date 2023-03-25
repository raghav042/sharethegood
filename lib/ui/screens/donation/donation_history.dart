import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationHistory extends StatelessWidget {
  const DonationHistory({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Donations"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("donations")
              .where("uid", isEqualTo: uid)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            } else if (snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      tileColor: snapshot.data!.docs[index]['donate']
                          ? Colors.teal[50]
                          : Colors.pink[50],
                      leading: CircleAvatar(
                          child: Text(snapshot.data!.docs[index]['quantity'])),
                      title: Text(snapshot.data!.docs[index]['label']),
                      subtitle: Text(snapshot.data!.docs[index]['shortDesc']),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(snapshot.data!.docs[index]['donate']
                              ? "donate"
                              : "take"),
                          Text(snapshot.data!.docs[index]['product']),
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("no data found"));
            }
          }),
    );
  }
}
