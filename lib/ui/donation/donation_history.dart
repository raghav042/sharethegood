import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';

class DonationHistory extends StatelessWidget {
  const DonationHistory({Key? key}) : super(key: key);
  static final String uid = FirebaseHelper.userData!['uid'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Donations"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("donations")
              .where("postedBy", isEqualTo: uid)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            } else if (snapshot.data != null) {

              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(backgroundColor: Colors.teal.shade100), const Text("Give item completed"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(backgroundColor: Colors.pink.shade100), const Text("Take item completed"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        CircleAvatar(backgroundColor: Colors.amber.shade200), const Text("pending"),
                      ],
                    ),
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            tileColor:
                                snapshot.data!.docs[index]['complete'] == true
                                    ? snapshot.data!.docs[index]['donate']
                                        ? Colors.teal.shade100
                                        : Colors.pink.shade100
                                    : Colors.amber.shade200,
                            leading: CircleAvatar(
                                child: Text(snapshot.data!.docs[index]['quantity'])),
                            title: Text(snapshot.data!.docs[index]['label']),
                            subtitle: Text(snapshot.data!.docs[index]['shortDesc']),
                            trailing: Text(snapshot.data!.docs[index]['product']),
                          ),
                        );
                      }),
                ],
              );
            } else {
              return const Center(child: Text("no data found"));
            }
          }),
    );
  }
}
