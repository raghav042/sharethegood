import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/core/color_constant.dart';

class DashboardTile extends StatelessWidget {
  const DashboardTile({Key? key}) : super(key: key);

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
                    element['product'] == 'books' && element["donate"] == true)
                .length;
            var clothesRequired = snapshot.data!.docs
                .where((element) =>
                    element['product'] == 'clothes' &&
                    element["donate"] == true)
                .length;
            var othersRequired =
                totalRequiredItems - booksRequired - clothesRequired;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Dashboard"),
                ),
                SizedBox(
                  height: 180,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      //Available
                      Container(
                        width: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: ColorConstants.blueGradient,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  booksAvailable.toString(),
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          value: booksAvailable /
                                              totalAvailableItems,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "${(booksAvailable / totalAvailableItems).toStringAsFixed(2)}%",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Books available for donation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: ColorConstants.pinkGradient,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  clothesAvailable.toString(),
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          value: clothesAvailable /
                                              totalAvailableItems,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "${(clothesAvailable / totalAvailableItems).toStringAsFixed(2)}%",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Clothes available for donation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: 150,
                      //   margin: const EdgeInsets.symmetric(horizontal: 10),
                      //   padding: const EdgeInsets.all(14),
                      //   decoration: BoxDecoration(
                      //     gradient: ColorConstants.purpleGradient,
                      //     borderRadius: BorderRadius.circular(12.0),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             othersAvailable.toString(),
                      //             style: const TextStyle(
                      //               fontSize: 50,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 50,
                      //             width: 50,
                      //             child: Stack(
                      //               children: [
                      //                 SizedBox(
                      //                   height: 50,
                      //                   width: 50,
                      //                   child: CircularProgressIndicator(
                      //                     value: othersAvailable /
                      //                         totalAvailableItems,
                      //                     color: Colors.white,
                      //                   ),
                      //                 ),
                      //                 Center(
                      //                   child: Text(
                      //                     "${(othersAvailable / totalAvailableItems).toStringAsFixed(2)}%",
                      //                     style: const TextStyle(
                      //                         fontSize: 12,
                      //                         fontWeight: FontWeight.bold,
                      //                         color: Colors.white),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       const Text(
                      //         "Other items available for donation",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      //Required
                      Container(
                        width: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: ColorConstants.amberGradient,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  booksRequired.toString(),
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          value: booksRequired /
                                              totalRequiredItems,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "${(booksRequired / totalRequiredItems).toStringAsFixed(2)}%",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Books Required for donation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: ColorConstants.greenGradient,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  clothesRequired.toString(),
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          value: clothesRequired /
                                              totalRequiredItems,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          "${(clothesRequired / totalRequiredItems).toStringAsFixed(2)}%",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Clothes required for donation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: 150,
                      //   margin: const EdgeInsets.symmetric(horizontal: 10),
                      //   padding: const EdgeInsets.all(14),
                      //   decoration: BoxDecoration(
                      //     gradient: ColorConstants.darkPinkGradient,
                      //     borderRadius: BorderRadius.circular(12.0),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             othersRequired.toString(),
                      //             style: const TextStyle(
                      //               fontSize: 50,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 50,
                      //             width: 50,
                      //             child: Stack(
                      //               children: [
                      //                 SizedBox(
                      //                   height: 50,
                      //                   width: 50,
                      //                   child: CircularProgressIndicator(
                      //                     value: othersRequired /
                      //                         totalRequiredItems,
                      //                     color: Colors.white,
                      //                   ),
                      //                 ),
                      //                 Center(
                      //                   child: Text(
                      //                     "${(othersRequired / totalRequiredItems).toStringAsFixed(2)}%",
                      //                     style: const TextStyle(
                      //                         fontSize: 12,
                      //                         fontWeight: FontWeight.bold,
                      //                         color: Colors.white),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       const Text(
                      //         "Other items required for donation",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
