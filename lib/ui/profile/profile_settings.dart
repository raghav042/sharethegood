import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/donation/donation_history.dart';
import 'package:sharethegood/ui/login/welcome_screen.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.volunteer_activism_outlined),
            title: const Text("Donation History"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=> DonationHistory()));
            },
            textColor: colorScheme.onPrimaryContainer,
            iconColor: colorScheme.onPrimaryContainer,
            tileColor: colorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
          ),
          // const SizedBox(height: 3),
          // ListTile(
          //   leading: const Icon(Icons.add),
          //   title: const Text("My 🤔 Takens"),
          //   onTap: () {},
          //   textColor: colorScheme.onPrimaryContainer,
          //   iconColor: colorScheme.onPrimaryContainer,
          //   tileColor: colorScheme.primaryContainer,
          //   shape:
          //       const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          // ),
          const SizedBox(height: 3),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              navigator.pushReplacement(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()));
            },
            textColor: colorScheme.onPrimaryContainer,
            iconColor: colorScheme.onPrimaryContainer,
            tileColor: colorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.0)),
            ),
          ),
        ],
      ),
    );
  }
}
