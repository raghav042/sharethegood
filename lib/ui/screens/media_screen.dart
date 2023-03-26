import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key, required this.snapshot}) : super(key: key);
  final QuerySnapshot snapshot;

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Gallery"),
      ),
      body: widget.snapshot.docs.isEmpty
          ? const Center(
              child: Text("no media found here"),
            )
          : ListView.builder(
              itemCount: widget.snapshot.docs.length,
              itemBuilder: (_, index) {
                return Container(
                  //width: MediaQuery.of(context).size.width - 80,
                  height: 200,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.snapshot.docs[index]['imageUrl']),
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
                        padding: const EdgeInsets.fromLTRB(20, 20, 100, 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.snapshot.docs[index]['quote'],
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
