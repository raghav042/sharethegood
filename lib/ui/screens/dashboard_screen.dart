import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? ngo = 0.0;
  double? library = 0.0;
  double? individual = 0.0;
  double? totalUsers = 0.0;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = MediaQuery.of(context).size.width / 2;
    const strokeWidth = 20.0;
    const padding = 50;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 20),
                Text(
                  "Individuals - ${(100 * individual! / totalUsers!).toStringAsFixed(2)} %",
                  style: TextStyle(fontSize: 18, color: colorScheme.tertiary),
                ),
                const Expanded(child: SizedBox(width: 20)),
                Container(
                  height: 25,
                  width: 25,
                  color: colorScheme.tertiary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.local_library_sharp,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: 20),
                Text(
                  "Library - ${(100 * library! / totalUsers!).toStringAsFixed(2)} %",
                  style: TextStyle(fontSize: 18, color: colorScheme.secondary),
                ),
                const Expanded(child: SizedBox(width: 20)),
                Container(
                  height: 25,
                  width: 25,
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.volunteer_activism,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 20),
                Text(
                  "Ngo - ${(100 * ngo! / totalUsers!).toStringAsFixed(2)} %",
                  style: TextStyle(fontSize: 18, color: colorScheme.primary),
                ),
                const Expanded(child: SizedBox(width: 20)),
                Container(
                  height: 25,
                  width: 25,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // Individual
              SizedBox(
                height: radius,
                width: radius,
                child: CircularProgressIndicator(
                  color: colorScheme.tertiary,
                  value: individual! / totalUsers!,
                  strokeWidth: strokeWidth,
                ),
              ),
              // Library
              SizedBox(
                height: radius - padding,
                width: radius - padding,
                child: CircularProgressIndicator(
                  color: colorScheme.secondary,
                  value: library! / totalUsers!,
                  strokeWidth: strokeWidth,
                ),
              ),
              // Ngo
              SizedBox(
                height: radius - padding * 2,
                width: radius - padding * 2,
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                  value: ngo! / totalUsers!,
                  strokeWidth: strokeWidth,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> getUsers() async {
    final users = await FirebaseFirestore.instance.collection("users").get();

    setState(() {
      totalUsers = users.docs.length.toDouble();
      debugPrint("total users : $totalUsers");
      ngo = users.docs
          .where((element) => element['type'] == "NGO")
          .length
          .toDouble();
      debugPrint("ngo users : $ngo");
      library = users.docs
          .where((element) => element['type'] == "Library")
          .length
          .toDouble();
      debugPrint("library users : $library");
      individual = users.docs
          .where((element) => element['type'] == "Individual")
          .length
          .toDouble();
      debugPrint("individual users : $individual");
    });
  }
}
