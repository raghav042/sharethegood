import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/profile/profile_screen.dart';

class TopDonorScreen extends StatelessWidget {
  const TopDonorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Donors"),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
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
                    );
                  });
            } else {
              return const Center(child: Text("no data found"));
            }
          }),
    );
  }
}
