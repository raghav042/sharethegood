import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/donation/donation_list.dart';

class DonationDashboard extends StatelessWidget {
  const DonationDashboard({Key? key, required this.userSnapshot})
      : super(key: key);
  final DocumentSnapshot userSnapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: userSnapshot['type'] == "Individual" ? 2 : 1,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                pinned: false,
                expandedHeight: 320,
                forceElevated: innerBoxIsScrolled,
                title: const Text("Donation"),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Image.asset(
                    "assets/donate.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Scaffold(
          appBar: AppBar(
            toolbarHeight: 45,
            automaticallyImplyLeading: false,
            flexibleSpace: userSnapshot['type'] == "Individual"
                ? TabBar(
                    labelPadding: const EdgeInsets.fromLTRB(12, 25, 12, 12),
                    tabs: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.volunteer_activism),
                          SizedBox(width: 8),
                          Text("Available"),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.my_library_books),
                          SizedBox(width: 8),
                          Text("Required"),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          body: userSnapshot['type'] == "Individual"
              ? Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonationList(
                                  userType: userSnapshot['type'],
                                  available: true,
                                ),
                              ));
                        },
                        child: const Text("Books")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonationList(
                                  userType: userSnapshot['type'],
                                  available: true,
                                ),
                              ));
                        },
                        child: const Text("Clothes")),
                  ],
                )
              : TabBarView(
                  children: [
                    DonationList(
                      userType: userSnapshot['type'],
                      available: true,
                    ),
                    DonationList(
                      userType: userSnapshot['type'],
                      available: false,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // Widget donationList(bool available) {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection("donations")
  //           .where("donate", isEqualTo: available)
  //           //.where("product", isEqualTo: "books")
  //           .where("complete", isEqualTo: false)
  //           .snapshots(),
  //       builder: (_, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return const Center(child: Text("An error occurred"));
  //         } else if (snapshot.data != null) {
  //           return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: snapshot.data?.docs.length,
  //               itemBuilder: (_, index) {
  //                 return DonationTile(snapshot: snapshot.data!.docs[index]);
  //               });
  //         } else {
  //           return const Center(child: Text("no data found"));
  //         }
  //       });
  // }
}
