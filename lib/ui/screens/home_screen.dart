import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sharethegood/ui/screens/donation/donation_screen.dart';
import 'package:sharethegood/ui/screens/profile/profile_screen.dart';
import 'media_screen.dart';
import 'users/all_users_screen.dart';
import 'donation/donation_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size.width / 4.8;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: firestore.collection('users').doc(uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("An error occurred"));
                  } else if (snapshot.data != null) {
                    String firstName =
                        (snapshot.data!['name']).toString().split(" ").first;
                    return AppBar(
                      title: Text(" Hi $firstName"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(snapshot: snapshot.data!)));
                          },
                          icon: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                snapshot.data!['photoUrl']),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text("no data found"));
                  }
                }),
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
                              builder: (context) => const DonationDashboard()));
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
                SizedBox(
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
                ),
                SizedBox(
                  height: size,
                  width: size,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Media Gallery"),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MediaScreen()));
                      },
                      icon: const Icon(Icons.arrow_forward))
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("media").snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("An error occurred"));
                  } else if (snapshot.data != null) {
                    return SizedBox(
                      height: 200,
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (_, index) {
                            return Container(
                              //width: MediaQuery.of(context).size.width - 80,

                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      snapshot.data?.docs[index]['imageUrl']),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.none,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.black87,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 100, 20),
                                    child: Text(
                                      snapshot.data?.docs[index]['quote'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return const Center(child: Text("no data found"));
                  }
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Top Donors"),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.arrow_forward))
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("users").snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("An error occurred"));
                  } else if (snapshot.data != null) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length < 5
                              ? snapshot.data!.docs.length
                              : 5,
                          itemBuilder: (_, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width / 3,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProfileScreen(
                                                    snapshot: snapshot
                                                        .data!.docs[index])));
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.docs[index]
                                              ['photoUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  snapshot.data!.docs[index]['name'],
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            );
                          }),
                    );
                  } else {
                    return const Center(child: Text("no data found"));
                  }
                }),
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
