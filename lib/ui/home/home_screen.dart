import 'package:flutter/material.dart';
import 'package:sharethegood/ui/home/dashboard_row.dart';
import 'package:sharethegood/ui/home/user_header.dart';
import '../users/all_users_screen.dart';
import 'top_donors.dart';
import 'top_media.dart';
import 'app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserHeader(),
            const TopMedia(),
            const DashboardRow(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Top Donors"),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllUsersScreen()));
                      },
                      icon: const Icon(Icons.arrow_forward))
                ],
              ),
            ),
            const TopDonors(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AllUsersScreen()));
        },
        icon: const Icon(Icons.message),
        label: const Text("All Users"),
      ),
    );
  }
}
