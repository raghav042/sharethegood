import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/donation/available_donation_tile.dart';

class DonationAvailableScreen extends StatelessWidget {
  const DonationAvailableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseHelper.donationStream,
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
                    return AvailableDonationTile(
                        snapshot: snapshot.data!.docs[index]);
                  });
            } else {
              return const Center(child: Text("no data found"));
            }
          }),
    );
  }
}
