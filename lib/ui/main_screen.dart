import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/services/preferences.dart';
import 'package:sharethegood/ui/home/chat_screen.dart';
import 'package:sharethegood/ui/home/top_donors.dart';
import 'home/home_screen.dart';
import 'home/donation_available_screen.dart';
import 'home/requirement_available_screen.dart';

class IndividualMainScreen extends StatefulWidget {
  const IndividualMainScreen({Key? key}) : super(key: key);

  @override
  State<IndividualMainScreen> createState() => _IndividualMainScreenState();
}

class _IndividualMainScreenState extends State<IndividualMainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? sheetController;
  static const List<Widget> listScreen = [
    HomeScreen(),
    DonationAvailableScreen(),
    RequirementAvailableScreen(),
    ChatScreen(),
  ];
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    checkFcmToken();
  }

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
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: "Available",
          ),
          NavigationDestination(
            icon: Icon(Icons.diversity_3_outlined),
            selectedIcon: Icon(Icons.diversity_3),
            label: "Required",
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}

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
    //RequirementAvailableScreen(),
    ChatScreen(),
  ];
  int currentScreen = 0;
  @override
  void initState() {
    super.initState();
    checkFcmToken();
  }

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
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: "Available",
          ),

          // NavigationDestination(
          //   icon: Icon(Icons.diversity_3_outlined),
          //   selectedIcon: Icon(Icons.diversity_3),
          //   label: "Required",
          // ),

          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            selectedIcon: Icon(Icons.message),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}

Future<void> checkFcmToken() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final newToken = await FirebaseMessaging.instance.getToken();
  debugPrint("fcm token is: $newToken\n");
  if (newToken != null && newToken != Preferences.getFcmToken()) {
    await Preferences.saveFcmToken(newToken);
    await FirebaseHelper.usersCol.doc(uid).update({"fcmToken": newToken});
    debugPrint("token updated successfully\n");
  }
}
