import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/functions/profile_image.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/about_screen.dart';
import 'sidebar_tile.dart';

Drawer sideBar(BuildContext context, DocumentSnapshot snapshot) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          child: SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: snapshot['photoUrl'] != ""
                  ? snapshot['photoUrl']
                  : profileImage(snapshot['type']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SideBarTile(
          icon: Icons.person,
          text: "Profile",
          screen: ProfileScreen(snapshot: snapshot),
        ),
        const SideBarTile(
          icon: Icons.dashboard,
          text: "Dashboard",
          screen: DashboardScreen(),
        ),
        const SideBarTile(
          icon: Icons.info,
          text: "About Us",
          screen: AboutScreen(),
        ),
        // SideBarTile(
        //   icon: Icons.logout,
        //   text: "Logout",
        //   onTap: () async {
        //     await FirebaseAuth.instance.signOut().then((value) {
        //       Navigator.pushReplacement(
        //           context,
        //           (MaterialPageRoute(
        //               builder: (context) => const SignInScreen())));
        //     });
        //   },
        // ),
      ],
    ),
  );
}
