import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/home/donation_button.dart';
import 'package:sharethegood/ui/home/small_dashboard.dart';
import 'package:sharethegood/ui/home/top_media.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Hi ${FirebaseHelper.userData!['name']}"),
        actions: [Hero(
          tag: "profile_pic",
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProfileScreen()));
            },
            icon: CircleAvatar(
              backgroundImage:
              CachedNetworkImageProvider(FirebaseHelper.userData!['photoUrl']),
            ),
          ),
        ),],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DonationButton(),
            SmallDashboard(),
            TopMedia(),
          ],
        ),
      ),




      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const AllUsersScreen()));
      //   },
      //   icon: const Icon(Icons.message),
      //   label: const Text("All Users"),
      // ),
    );
  }
}


/*
SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [



            // const UserHeader(),
            // const TopMedia(),
            // const DashboardRow(),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text("Top Donors"),
            //       IconButton(
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => const AllUsersScreen()));
            //           },
            //           icon: const Icon(Icons.arrow_forward))
            //     ],
            //   ),
            // ),
            // const TopDonors(),
          ],
        ),
      ),
 */