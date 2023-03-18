import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/functions/profile_image.dart';
import 'package:sharethegood/ui/screens/profile_screen.dart';
import 'media_screen.dart';
import '../widgets/choice_tile.dart';
import '../widgets/sidebar.dart';
import 'all_users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance;
  DocumentSnapshot? userSnapshot;
  String name = "";

  List<String> images = [
    "assets/poor_students.jpg",
    "assets/poor_kid.jpg",
    "assets/poor_house.jpg",
  ];

  List<String> thoughts = [
    "some text here",
    "another text",
    "we can add more content to show user",
  ];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Hi $name"),
      ),
      drawer: userSnapshot != null
          ? sideBar(context, userSnapshot!)
          : const SizedBox(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: [
                ChoiceTile(
                  icon: Icons.savings,
                  label: "Money",
                  color: Colors.green[100],
                ),
                ChoiceTile(
                  icon: Icons.menu_book,
                  label: "Books",
                  color: Colors.indigo[100],
                ),
                ChoiceTile(
                  icon: Icons.ramen_dining,
                  label: "Food",
                  color: Colors.red[100],
                ),
                ChoiceTile(
                  icon: Icons.checkroom,
                  label: "Clothes",
                  color: Colors.blue[100],
                ),
                ChoiceTile(
                  icon: Icons.weekend,
                  label: "Others",
                  color: Colors.purple[100],
                ),
                ChoiceTile(
                  icon: Icons.snowshoeing,
                  label: "Volunteer",
                  color: Colors.amber[100],
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
                                builder: (context) => MediaScreen()));
                      },
                      icon: const Icon(Icons.arrow_forward))
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (_, index) {
                    return Container(
                      //width: MediaQuery.of(context).size.width - 80,

                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: AssetImage(images[index]),
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
                              thoughts[index],
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
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("users").snapshots(),
                builder: (_, snapshot) {
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width / 3,
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
                                      borderRadius: BorderRadius.circular(12.0),
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
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          );
                        }),
                  );
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

  Future<void> getUserData() async {
    userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    setState(() {
      name = (userSnapshot!['name']).toString().split(" ").first;
    });
  }
}
