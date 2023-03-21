import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                    "assets/Clothes.jpg",
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
              availableDonations(),
              requiredDonations(),
            ],
          ),
        ),
      ),
    );
  }

  Widget availableDonations() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("availableDonation")
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
                  return InfoTile(
                    image: snapshot.data?.docs[index]['image'],
                    label: snapshot.data?.docs[index]['label'],
                    description: snapshot.data?.docs[index]['description'],
                    number: snapshot.data?.docs[index]['number'],
                    donate: true,
                  );
                });
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }

  Widget requiredDonations() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("requiredDonation")
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
                  return InfoTile(
                    label: snapshot.data?.docs[index]['label'],
                    description: snapshot.data?.docs[index]['description'],
                    number: snapshot.data?.docs[index]['number'],
                    donate: false,
                  );
                });
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    Key? key,
    this.image,
    required this.label,
    required this.description,
    required this.number,
    required this.donate,
  }) : super(key: key);
  final String? image;
  final String label;
  final String description;
  final String number;
  final bool donate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 8,
      ),
      child: Row(
        children: [
          donate
              ? CachedNetworkImage(
                  imageUrl: image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.none,
                )
              : const SizedBox(),
          Column(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Text(number)
        ],
      ),
    );
  }
}
