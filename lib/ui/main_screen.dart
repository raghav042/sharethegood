import 'package:flutter/material.dart';
import 'package:sharethegood/ui/home/top_donors.dart';
import 'home/home_screen.dart';
import 'home/donation_available_screen.dart';
import 'home/requirement_available_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? sheetController;
  static const List<Widget> listScreen = [
    HomeScreen(),
    DonationAvailableScreen(),
    RequirementAvailableScreen(),
    TopDonors(),
  ];
  int currentScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: listScreen[currentScreen],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: "Donors",
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: "Taker",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
