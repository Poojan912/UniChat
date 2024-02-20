import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';
import 'package:unichat/chatScreen.dart';
import 'dart:convert';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUser> _chatList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSearchResults();
    buildChatList();
  }

  void saveSearchResults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> usersJson = _chatList.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('searched_users', usersJson);
  }

  void loadSearchResults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? usersJson = prefs.getStringList('searched_users');
    if (usersJson != null) {
      setState(() {
        _chatList = usersJson.map((userJson) => ChatUser.fromJson(jsonDecode(userJson))).toList();
      });
    }
  }

  void searchUserByEmail(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email address cannot be empty.")),
      );
      return;
    }

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> userData = doc.data();
          ChatUser user = ChatUser(
            fullname: userData['fullname'] ?? 'Unknown',
            email: userData['email'] ?? 'No email',
            imageUrl: userData['imageUrl'] ??
                'assets/images/default_avatar.png',
            uid: doc.id,
          );

          if (!_chatList.any((u) => u.uid == user.uid)) {
            setState(() {
              _chatList.add(user);
            });              saveSearchResults();

          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user found with that email.")),
        );
      }
    } catch (e) {
      print("An error occurred while searching for user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error searching for user: $e")),
      );
    }
  }

  // Future<void> addToUserConversations(String otherUserId) async {
  //   String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  //   if (currentUserId.isEmpty) {
  //     // Handle error: user not logged in...
  //     return;
  //   }
  //
  //   // Adding to current user's conversations
  //   await FirebaseFirestore.instance
  //       .collection('user-conversations')
  //       .doc(currentUserId)
  //       .collection('conversations')
  //       .doc(otherUserId)
  //       .set({'exists': true});
  //
  //   // Adding to other user's conversations
  //   await FirebaseFirestore.instance
  //       .collection('user-conversations')
  //       .doc(otherUserId)
  //       .collection('conversations')
  //       .doc(currentUserId)
  //       .set({'exists': true});
  // }

  void buildChatList() {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      return;
    }

    FirebaseFirestore.instance
        .collection('user-conversations')
        .doc(currentUserId)
        .collection('conversations')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _chatList.clear();
        snapshot.docs.forEach((doc) async {
          String otherUserId = doc.id;
          var userDoc = await FirebaseFirestore.instance.collection('users')
              .doc(otherUserId)
              .get();
          if (userDoc.exists) {
            Map<String, dynamic> userData = userDoc.data()!;
            ChatUser user = ChatUser(
              fullname: userData['fullname'] ?? 'Unknown',
              email: userData['email'] ?? 'No email',
              imageUrl: userData['imageUrl'] ??
                  'assets/images/default_avatar.png',
              uid: otherUserId,
            );
            if (!_chatList.any((u) => u.uid == user.uid)) {
              _chatList.add(user);
            }
          }
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple.shade100,
          title: Row(children: <Widget>[
            Image.asset('assets/image/image_no_bg.png', width: 50,
              fit: BoxFit.contain,),
            Spacer(flex: 1,),
            Text(
              "Chat Page",
              style: TextStyle(fontSize: 30),
            ),

            Spacer(),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {

                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: Text('Search User by Email'),
                        content: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                              hintText: 'Enter email address'),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Search'),
                            onPressed: () {
                              searchUserByEmail(
                                  _searchController.text.trim());
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],)
      ),
      body: _chatList.isEmpty
          ? Center(
          child: Text('No chats yet. Search to start a conversation.'))
          : ListView.builder(
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          final user = _chatList[index];
          return ListTile(
            leading: CircleAvatar(
               backgroundImage: AssetImage('assets/image/default_profile_pic.png'),

            ),
            title: Text(user.fullname),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
