import 'package:flutter/material.dart';
import 'package:sharethegood/ui/users/library_screen.dart';
import 'package:sharethegood/ui/users/ngo_screen.dart';
import 'individual_screen.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Users"),
          bottom: const TabBar(
            labelPadding: EdgeInsets.all(12),
            tabs: [
              Text("Individual"),
              Text("Library"),
              Text("NGO"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IndividualScreen(),
            LibraryScreen(),
            NgoScreen(),
          ],
        ),
      ),
    );
  }
}
