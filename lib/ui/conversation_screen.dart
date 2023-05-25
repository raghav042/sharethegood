import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final firestore = FirebaseFirestore.instance;
  final messageController = TextEditingController();
  late bool isTyping;
  late String chatId;
  DocumentSnapshot? snapshot;

  @override
  void initState() {
    getSnapshot();
    chatId = getChatId();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(snapshot?['name'] ?? "")),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text("error");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isMe = snapshot.data!.docs[index]['uid'] == uid;
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: 0,
                              maxWidth: MediaQuery.of(context).size.width / 1.5,
                            ),
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? colorScheme.primaryContainer
                                  : colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(isMe ? 20 : 8),
                                right: Radius.circular(isMe ? 8 : 20.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]['message'],
                                  style: TextStyle(
                                    color: isMe
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onTertiaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return const Text("No message found");
                }
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: TextFormField(
                        controller: messageController,
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
                        sendMessage();
                      },
                      elevation: 0,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getSnapshot() async {
    var snap = await FirebaseHelper.usersCol.doc(widget.uid).get();
    setState(() {
      snapshot = snap;
    });
  }

  String getChatId() {
    if (uid.hashCode <= widget.uid.hashCode) {
      return '$uid-${widget.uid}';
    } else {
      return '${widget.uid}-$uid';
    }
  }

  String getChatTitle() {
    String name1 = FirebaseHelper.userData!['name'];
    String name2 = snapshot?['name'];
    if (name1.hashCode <= name2.hashCode) {
      return '$name1$name2';
    } else {
      return '$name2$name1';
    }
  }

  Future<void> sendMessage() async {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    if (messageController.text.isNotEmpty) {
      final snap = await firestore.collection("chats").doc(chatId).get();
      if (!snap.exists) {
        await firestore.collection("chats").doc(chatId).set({
          "chatId": chatId,
          "participants": [
            FirebaseHelper.userData!['uid'],
            snapshot?['uid'],
          ],
          "participants_name": [
            FirebaseHelper.userData!['name'],
            snapshot?['name'],
          ],
          "chatTitle": getChatTitle(),
        });
      }

      await firestore.collection("chats").doc(chatId).update({
        "last_message": messageController.text.trim(),
        "sendBy": uid,
        "time": timeStamp,
      });

      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(timeStamp.toString())
          .set({
        "uid": uid,
        "message": messageController.text.trim(),
        "time": timeStamp,
      });
      messageController.clear();
    }
  }
}
