import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sharethegood/ui/donation/comments.dart';
import 'package:sharethegood/ui/users/conversation_screen.dart';

class DonationDetails extends StatefulWidget {
  const DonationDetails({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  State<DonationDetails> createState() => _DonationDetailsState();
}

class _DonationDetailsState extends State<DonationDetails> {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  DocumentSnapshot? userSnapshot;
  bool? isLiked;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

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
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              widget.snapshot['photoUrl'],
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.snapshot['donate']
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
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

              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       CircleAvatar(
              //         backgroundImage: CachedNetworkImageProvider(
              //           widget.snapshot['photoUrl'],
              //         ),
              //       ),
              //       const SizedBox(width: 15),
              //       Text(
              //         widget.snapshot['label'].toString().toUpperCase(),
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //           color: colorScheme.primary,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return Comments(
                              uid: userSnapshot!['uid'],
                              donationId: widget.snapshot['donationId'],
                            );
                          });
                    },
                    icon: Icon(Icons.forum_outlined),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      Share.share(
                          "hi checkout this amazing donation app available on Google play store https://play.google.com/store/apps/details?id=com.sharethegood.sharethegood");
                    },
                    icon: Icon(Icons.share),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.snapshot['uid'] != uid
          ? SizedBox(
              width: 300,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ConversationScreen(snapshot: userSnapshot!),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Continue"),
                    SizedBox(width: 20),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void getUserData() async {
    final snapshot =
        await firestore.collection('users').doc(widget.snapshot['uid']).get();
    setState(() {
      userSnapshot = snapshot;
    });
  }
}
