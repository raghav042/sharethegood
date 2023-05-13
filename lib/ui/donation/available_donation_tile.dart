import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'donation_details.dart';

class AvailableDonationTile extends StatelessWidget {
  const AvailableDonationTile({Key? key, required this.snapshot})
      : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DonationDetails(snapshot: snapshot)));
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            snapshot["image"] != ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: snapshot['image'],
                      filterQuality: FilterQuality.none,
                      height: 200,
                      width: 150,
                      maxHeightDiskCache: 200,
                      maxWidthDiskCache: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(),
            const Spacer(),
            SizedBox(
              width: snapshot["image"] != ""
                  ? MediaQuery.of(context).size.width - 205
                  : MediaQuery.of(context).size.width - 50,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(snapshot['photoUrl']),
                      ),
                      const Spacer(),
                      Text(
                        snapshot['quantity'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        snapshot['product'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot['label'].toString().toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot['shortDesc'],
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot['longDesc'],
                    maxLines: 3,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
