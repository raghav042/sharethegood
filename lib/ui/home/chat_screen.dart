import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharethegood/services/firebase_helper.dart';
import 'package:sharethegood/ui/conversation_screen.dart';
import 'package:sharethegood/ui/users/all_users_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .where("participants", arrayContains: FirebaseHelper.userData!['uid'])
              .snapshots(),
          builder: (_, snapshot) {
            print(snapshot.data?.docs.length);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            } else if (snapshot.data != null) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (_, index) {
                    List<String> newList = List.from(snapshot.data?.docs[index]['participants']);
                    newList.remove(FirebaseHelper.userData!['uid']);
                    String otherUserUid = newList[0];


                    print(List.from(snapshot.data?.docs[index]['participants']).where((element) => element != FirebaseHelper.userData!['uid']));
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
                      child: ListTile(
                        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=> ConversationScreen(uid: otherUserUid)));},
                       title: Text(snapshot.data!.docs[index]['chatTitle'].toString().replaceAll(FirebaseHelper.userData!['name'], "")),
                        subtitle: Text("message: "+snapshot.data?.docs[index]['last_message']),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        tileColor: colorScheme.primaryContainer,
                      ),
                    );
                  });
            } else {
              return const Center(child: Text("No chats found"));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AllUsersScreen()));
        },
        child: const Icon(Icons.person_search),
      ),
    );
  }
}
