import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/conversation_screen.dart';
import 'package:sharethegood/ui/donation/comments.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationDetails extends StatefulWidget {
  const DonationDetails({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  State<DonationDetails> createState() => _DonationDetailsState();
}

class _DonationDetailsState extends State<DonationDetails> {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  bool? isLiked;



  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.snapshot['label'].toString().toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              addReceiver();
              },
            icon: const Icon(Icons.volunteer_activism),
          ),
          IconButton(
            onPressed: () {
              Share.share(
                  "hi checkout this amazing donation app available on Google play store https://play.google.com/store/apps/details?id=com.sharethegood.sharethegood");
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () async {
              Uri uri = Uri.parse("tel:${widget.snapshot['phone']}");
              await launchUrl(uri);
            },

            icon: const Icon(Icons.call),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      widget.snapshot['photoUrl'],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text( widget.snapshot['name']),
                ],
              ),
              const SizedBox(height: 20),



              widget.snapshot['image'] != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.snapshot['image'],
                        filterQuality: FilterQuality.none,
                        fit: BoxFit.scaleDown,
                        height: 500,
                        width: double.infinity,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: widget.snapshot['donate']
                      ? colorScheme.primaryContainer
                      : colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Expanded(child: SizedBox()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.snapshot['quantity'],
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              Text(
                                widget.snapshot['product']
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.snapshot['shortDesc'],
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.snapshot['longDesc'],
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Row(
                  children: [
                    Icon(Icons.forum),
                    SizedBox(width: 10),
                    Text("view comments"),
                  ],
                ),
                children: [Comments(donationId: widget.snapshot['donationId'])],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addReceiver() async {

    await FirebaseHelper.donationCol
        .doc(widget.snapshot['donationId'])
        .update({"receiverId": FirebaseHelper.userData!['uid']});

    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ConversationScreen(uid: widget.snapshot['postedBy'])));

  }
}
