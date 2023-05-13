import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/dashboard/dashboard_tile.dart';

class SmallDashboard extends StatefulWidget {
  const SmallDashboard({Key? key}) : super(key: key);

  @override
  State<SmallDashboard> createState() => _SmallDashboardState();
}

class _SmallDashboardState extends State<SmallDashboard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 2 - 30;
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                  child: Text("Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    //Available
                    DashboardTile(
                      available: true,
                      width: width,
                      quantity: booksAvailable.toString(),
                      label: "books",
                      progress: booksAvailable / totalAvailableItems,
                    ),
                    DashboardTile(
                      available: true,
                      width: width,
                      quantity: clothesAvailable.toString(),
                      label: "clothes",
                      progress: clothesAvailable / totalAvailableItems,
                    ),
                    //Required
                    DashboardTile(
                      available: false,
                      width: width,
                      quantity: booksRequired.toString(),
                      label: "books",
                      progress: booksRequired / totalRequiredItems,
                    ),
                    DashboardTile(
                      available: false,
                      width: width,
                      quantity: clothesRequired.toString(),
                      label: "clothes",
                      progress: clothesRequired / totalRequiredItems,
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}
