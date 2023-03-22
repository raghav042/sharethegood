import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          snapshot['donate'] == true
              ? CachedNetworkImage(
                  imageUrl: snapshot['image'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.none,
                )
              : const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.6,
                child: Text(
                  snapshot['label'],
                  style: TextStyle(
                      fontSize: 16, color: colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                snapshot['description'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Text("${snapshot['number']}  ${snapshot['product']}")
        ],
      ),
    );
  }
}
