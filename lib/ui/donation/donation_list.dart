import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/donation/donation_tile.dart';

class DonationList extends StatelessWidget {
  const DonationList({
    Key? key,
    required this.userType,
    required this.available,
  }) : super(key: key);
  final String userType;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final individualStream = FirebaseFirestore.instance
        .collection("donations")
        .where("donate", isEqualTo: available)
        .where("complete", isEqualTo: false)
        .snapshots();

    final otherStream = FirebaseFirestore.instance
        .collection("donations")
        .where("product", isEqualTo: userType == "NGO" ? "clothes" : "books")
        .where("donate", isEqualTo: available)
        .where("complete", isEqualTo: false)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: userType == "Individual" ? individualStream : otherStream,
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
                    return DonationTile(snapshot: snapshot.data!.docs[index]);
                  });
            } else {
              return const Center(child: Text("no data found"));
            }
          }),
    );
  }
}
