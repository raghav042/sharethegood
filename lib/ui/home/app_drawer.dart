import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/donation/donation_list.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key, required this.userSnapshot}) : super(key: key);
  final DocumentSnapshot userSnapshot;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Text("Drawer"),
          ListTile(
            onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DonationList(
                    product: userSnapshot['type'] == "NGO"
                        ? "clothes"
                        : "books",
                    available: true,
                  ),
                ),
              );



            },
            title: Text("Available Books"),
          )
        ],
      ),
    );
  }
}
