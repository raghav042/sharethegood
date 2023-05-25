import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/conversation_screen.dart';

class Comments extends StatefulWidget {
  const Comments({
    Key? key,
    required this.donationId,
  }) : super(key: key);
  final String donationId;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: TextFormField(
                controller: commentController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Type something",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                addComment();
              },
              elevation: 0,
              child: const Icon(Icons.send),
            ),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseHelper.commentCol(widget.donationId).snapshots(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("An error occurred"));
              } else if (snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return ListTile(
                        onLongPress: FirebaseHelper.userData!['type'] == "Individual" && snapshot.data!.docs[index]['commentBy'] != FirebaseHelper.userData!['uid']
                            ? () {
                                addReceiver(snapshot.data!.docs[index]['commentBy']);
                              }
                            : null,
                        title: Text(snapshot.data!.docs[index]['name']),
                        subtitle: Text(snapshot.data!.docs[index]['comment']),
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              snapshot.data!.docs[index]['photoUrl']),
                        ),
                      );
                    });
              } else {
                return const Center(child: Text("no data found"));
              }
            }),
      ],
    );
  }

  Future<void> addReceiver(String id) async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    await FirebaseHelper.donationCol
        .doc(widget.donationId)
        .update({"receiverId": id});
    await FirebaseFirestore.instance.collection("notifications").doc(timeStamp.toString()).set({
      "sender": FirebaseHelper.userData!['name'],
      "senderId": FirebaseHelper.userData!['uid'],
      "receiver": id,
      "message": "Hi, close the entry if you received this item 😊",

    });
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => ConversationScreen(uid: id)));
  }

  Future<void> addComment() async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    if (commentController.text.isNotEmpty) {
      await FirebaseHelper.commentCol(widget.donationId)
          .doc(timeStamp.toString())
          .set({
        "commentBy": FirebaseHelper.userData!['uid'],
        "comment": commentController.text.trim(),
        "photoUrl": FirebaseHelper.userData!['photoUrl'],
        "name": FirebaseHelper.userData!['name'],
        "commentId": timeStamp.toString(),
      });
      commentController.clear();
    }
  }
}
