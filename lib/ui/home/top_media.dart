import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/media_screen.dart';

class TopMedia extends StatelessWidget {
  const TopMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("media").doc("media1").get(),
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
                      const Text("Media Gallery", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const MediaScreen()));
                          },
                          icon: const Icon(Icons.arrow_forward))
                    ],
                  ),
                ),
                Container(
                  //width: MediaQuery.of(context).size.width - 80,
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          snapshot.data!['imageUrl']),
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
                        padding:
                        const EdgeInsets.fromLTRB(20, 20, 100, 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            snapshot.data!['quote'],
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("no data found"));
          }
        });
  }
}
