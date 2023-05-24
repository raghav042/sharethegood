import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/ui/conversation_screen.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({Key? key, required this.snapshot}) : super(key: key);
  final DocumentSnapshot snapshot;

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.snapshot['name'].toString().split(" ").first} Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
              width: double.infinity,
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: widget.snapshot['photoUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 4),
              child: Text(
                widget.snapshot['name'],
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Text(
              "Email :  ${widget.snapshot['email']}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Account Type :  ${widget.snapshot['type']}",
              style: const TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConversationScreen(
                                  uid: widget.snapshot['uid'])));
                    },
                    icon: const Icon(Icons.message),
                    label: const Text("Send Message")),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
