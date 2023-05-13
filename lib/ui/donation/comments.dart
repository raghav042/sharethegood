import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  const Comments({
    Key? key,
    required this.uid,
    required this.donationId,
  }) : super(key: key);
  final String uid;
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 80,
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
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return ListTile(
                title: Text("hello"),
                leading: CircleAvatar(),
              );
            }),
      ],
    );
  }

  Future<void> addComment() async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    if (commentController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.donationId)
          .collection("messages")
          .doc(timeStamp.toString())
          .set({
        "uid": widget.uid,
        "message": commentController.text.trim(),
        "time": timeStamp,
      });
      commentController.clear();
    }
  }
}
