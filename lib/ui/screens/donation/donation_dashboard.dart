import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/screens/donation/donation_tile.dart';

class DonationDashboard extends StatefulWidget {
  const DonationDashboard({Key? key}) : super(key: key);

  @override
  State<DonationDashboard> createState() => _DonationDashboardState();
}

class _DonationDashboardState extends State<DonationDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            flexibleSpace: TabBar(
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
            ),
          ),
          body: TabBarView(
            children: [
              donationList(true),
              donationList(false),
            ],
          ),
        ),
      ),
    );
  }

  Widget donationList(bool available) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("donations")
            .where("donate", isEqualTo: available)
            .where("complete", isEqualTo: false)
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
                  return DonationTile(snapshot: snapshot.data!.docs[index]);
                });
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}
