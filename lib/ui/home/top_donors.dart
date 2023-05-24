import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/home/top_donors_screen.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';

class TopDonors extends StatelessWidget {
  const TopDonors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("type", isEqualTo: "Individual")
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.data != null) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Top Donors",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TopDonorScreen()));
                          },
                          icon: const Icon(Icons.arrow_forward))
                    ],
                  ),
                ),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data!.docs[index]['photoUrl']),
                              ),
                              Text(
                                snapshot.data!.docs[index]['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}

/*
                        ListTile(
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => ProfileScreen(
                          //         snapshot: snapshot.data!.docs[index],
                          //       ),
                          //     ),
                          //   );
                          // },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(
                                snapshot.data!.docs[index]['photoUrl']),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]['name'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            snapshot.data!.docs[index]['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // trailing: Text(
                          //   snapshot.data!.docs[index]['type'],
                          //   style: const TextStyle(fontSize: 10),
                          // ),
                        ),

                      */
