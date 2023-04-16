import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/core/color_constant.dart';
import 'package:sharethegood/ui/donation/dashboard_tile.dart';
import 'package:sharethegood/ui/donation/donation_dashboard.dart';

class DashboardRow extends StatelessWidget {
  const DashboardRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("donations").snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.data != null) {
            // Available
            var totalAvailableItems = snapshot.data!.docs.length;
            var booksAvailable = snapshot.data!.docs
                .where((element) =>
                    element['product'] == 'books' && element["donate"] == true)
                .length;
            var clothesAvailable = snapshot.data!.docs
                .where((element) =>
                    element['product'] == 'clothes' &&
                    element["donate"] == true)
                .length;
            var othersAvailable =
                totalAvailableItems - booksAvailable - clothesAvailable;

            // Required
            var totalRequiredItems = snapshot.data!.docs.length;
            var booksRequired = snapshot.data!.docs
                .where((element) =>
                    element['product'] == 'books' && element["donate"] == false)
                .length;
            var clothesRequired = snapshot.data!.docs
                .where((element) =>
                    element['product'] == 'clothes' &&
                    element["donate"] == false)
                .length;
            var othersRequired =
                totalRequiredItems - booksRequired - clothesRequired;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dashboard"),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const DonationDashboard()));
                        },
                        icon: const Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Available
                      DashboardTile(
                        available: true,
                        width: 150,
                        gradient: ColorConstants.blueGradient,
                        quantity: booksAvailable.toString(),
                        label: "books",
                        progress: booksAvailable / totalAvailableItems,
                      ),
                      DashboardTile(
                        available: true,
                        width: 150,
                        gradient: ColorConstants.pinkGradient,
                        quantity: clothesAvailable.toString(),
                        label: "clothes",
                        progress: clothesAvailable / totalAvailableItems,
                      ),
                      //Required
                      DashboardTile(
                        available: false,
                        width: 150,
                        gradient: ColorConstants.greenGradient,
                        quantity: booksRequired.toString(),
                        label: "books",
                        progress: booksRequired / totalRequiredItems,
                      ),
                      DashboardTile(
                        available: false,
                        width: 150,
                        gradient: ColorConstants.darkPinkGradient,
                        quantity: clothesRequired.toString(),
                        label: "clothes",
                        progress: clothesRequired / totalRequiredItems,
                      ),
                    ],
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
