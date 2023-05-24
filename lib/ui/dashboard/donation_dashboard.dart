import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/core/color_constant.dart';
import 'package:sharethegood/ui/dashboard/dashboard_tile.dart';


class DonationDashboard extends StatelessWidget {
  const DonationDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Dashboard"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("donations").snapshots(),
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
                      element['product'] == 'books' &&
                      element["donate"] == true)
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
                      element['product'] == 'books' &&
                      element["donate"] == false)
                  .length;
              var clothesRequired = snapshot.data!.docs
                  .where((element) =>
                      element['product'] == 'clothes' &&
                      element["donate"] == false)
                  .length;
              var othersRequired =
                  totalRequiredItems - booksRequired - clothesRequired;

              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  //Available
                  DashboardTile(
                    available: true,
                    width: double.infinity,
                    gradient: ColorConstants.blueGradient,
                    quantity: booksAvailable.toString(),
                    label: "books",
                    progress: booksAvailable / totalAvailableItems,
                  ),
                  DashboardTile(
                    available: true,
                    width: double.infinity,
                    gradient: ColorConstants.pinkGradient,
                    quantity: clothesAvailable.toString(),
                    label: "clothes",
                    progress: clothesAvailable / totalAvailableItems,
                  ),
                  // DashboardTile(
                  //   available: true,
                  //   width: double.infinity,
                  //   gradient: ColorConstants.amberGradient,
                  //   quantity: othersAvailable.toString(),
                  //   label: "other items",
                  //   progress: othersAvailable / totalAvailableItems,
                  // ),

                  // Required
                  DashboardTile(
                    available: false,
                    width: double.infinity,
                    gradient: ColorConstants.greenGradient,
                    quantity: booksRequired.toString(),
                    label: "books",
                    progress: booksRequired / totalRequiredItems,
                  ),
                  DashboardTile(
                    available: false,
                    width: double.infinity,
                    gradient: ColorConstants.darkPinkGradient,
                    quantity: clothesRequired.toString(),
                    label: "clothes",
                    progress: clothesRequired / totalRequiredItems,
                  ),
                  // DashboardTile(
                  //   available: false,
                  //   width: double.infinity,
                  //   gradient: ColorConstants.purpleGradient,
                  //   quantity: othersRequired.toString(),
                  //   label: "other items",
                  //   progress: othersRequired / totalRequiredItems,
                  // )
                ],
              );
            } else {
              return const Center(child: Text("no data found"));
            }
          }),
    );
  }
}
