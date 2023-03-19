import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'media_screen.dart';
import '../widgets/sidebar.dart';
import 'all_users_screen.dart';
import 'donation_screen.dart';
import '../../core/data/user_data.dart';
import '../../core/data/map/carousel_map.dart';

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
      appBar: AppBar(
        title: Text(" Hi ${UserData.firstname}"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(UserData.userSnapshot['photoUrl']),
            ),
          ),
        ],
      ),
      drawer: sideBar(context, UserData.userSnapshot),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                              builder: (context) => const DonationScreen()));
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProductScreen(label: label)));
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProductScreen(label: label)));
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
            SizedBox(
              height: 200,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: carouselList.length,
                  itemBuilder: (_, index) {
                    return Container(
                      //width: MediaQuery.of(context).size.width - 80,

                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: AssetImage(carouselList[index].imagePath),
                          fit: BoxFit.cover,
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
                            padding: const EdgeInsets.fromLTRB(20, 20, 100, 20),
                            child: Text(
                              carouselList[index].thought,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
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
            // StreamBuilder<QuerySnapshot>(
            //     stream: firestore.collection("users").snapshots(),
            //     builder: (_, snapshot) {
            //       return SizedBox(
            //         height: 200,
            //         child: ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: snapshot.data!.docs.length < 5
            //                 ? snapshot.data!.docs.length
            //                 : 5,
            //             itemBuilder: (_, index) {
            //               return Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Padding(
            //                     padding:
            //                         const EdgeInsets.symmetric(horizontal: 10),
            //                     child: SizedBox(
            //                       height: MediaQuery.of(context).size.width / 3,
            //                       width: MediaQuery.of(context).size.width / 3,
            //                       child: InkWell(
            //                         onTap: () {
            //                           Navigator.push(
            //                               context,
            //                               MaterialPageRoute(
            //                                   builder: (_) => ProfileScreen(
            //                                       snapshot: snapshot
            //                                           .data!.docs[index])));
            //                         },
            //                         child: ClipRRect(
            //                           borderRadius: BorderRadius.circular(12.0),
            //                           child: CachedNetworkImage(
            //                             imageUrl: snapshot.data!.docs[index]
            //                                 ['photoUrl'],
            //                             fit: BoxFit.cover,
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Text(
            //                     snapshot.data!.docs[index]['name'],
            //                     style: TextStyle(fontSize: 16),
            //                     overflow: TextOverflow.ellipsis,
            //                   )
            //                 ],
            //               );
            //             }),
            //       );
            //     }),
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
