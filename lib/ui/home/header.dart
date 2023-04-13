import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/donation/donation_dashboard.dart';
import 'package:sharethegood/ui/donation/donation_screen.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size.width / 4.8;
    final firstName = (snapshot['name']).toString().split(" ").first;
    return Column(
      children: [
        AppBar(
          title: Text(" Hi $firstName"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProfileScreen(snapshot: snapshot)));
              },
              icon: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(snapshot['photoUrl']),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: size,
              width: size * 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: colorScheme.tertiaryContainer,
                  foregroundColor: colorScheme.onTertiaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DonationDashboard(userSnapshot: snapshot)));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.dashboard),
                    Text("Donation"),
                  ],
                ),
              ),
            ),
            snapshot['type'] == "Individual"
                ? SizedBox(
                    height: size,
                    width: size,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        backgroundColor: colorScheme.secondaryContainer,
                        foregroundColor: colorScheme.onSecondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DonationScreen(donate: true)));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.volunteer_activism),
                          Text("Donate"),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: size,
              width: snapshot['type'] == "Individual" ? size : size * 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const DonationScreen(donate: false)));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.add),
                    Text("Need"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
