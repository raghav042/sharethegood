import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';

class TopDonors extends StatelessWidget {
  const TopDonors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.data != null) {
            return SizedBox(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length < 5
                      ? snapshot.data!.docs.length
                      : 5,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProfileScreen(
                                          snapshot: snapshot
                                              .data!.docs[index])));
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage:
                              CachedNetworkImageProvider(snapshot
                                  .data!.docs[index]['photoUrl']),
                            ),
                          ),
                          Text(
                            snapshot.data!.docs[index]['name']
                                .toString()
                                .split(" ")
                                .first,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}
