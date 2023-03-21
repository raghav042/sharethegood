import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/screens/login/welcome_screen.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

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
            leading: const Icon(Icons.add),
            title: const Text("Donate Something"),
            onTap: () {},
            textColor: colorScheme.onPrimaryContainer,
            iconColor: colorScheme.onPrimaryContainer,
            tileColor: colorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
          ),
          const SizedBox(height: 3),
          ListTile(
            leading: const Icon(Icons.volunteer_activism_outlined),
            title: const Text("Add Requirements"),
            onTap: () {},
            textColor: colorScheme.onPrimaryContainer,
            iconColor: colorScheme.onPrimaryContainer,
            tileColor: colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
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
