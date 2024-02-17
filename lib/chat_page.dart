import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';
import 'package:unichat/chatScreen.dart'; // Make sure this is the correct import for your ChatScreen

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    buildChatList();
  }

  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('Users');
  List<ChatUser> _chatList = [];
  final TextEditingController _searchController = TextEditingController();

  void searchUserByEmail(String email) async {

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email address cannot be empty.")),
      );
      return;
    }

    Query query = _usersRef.orderByChild('email').equalTo(email);

    try {
      DataSnapshot snapshot = await query.get();

      if (snapshot.exists) {
        print("User found in database: ${snapshot.value}");

        Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
        // Inside searchUserByEmail



        // Assuming that usersMap contains the UID as the key.
        String uid = usersMap.keys.first;
        Map<dynamic, dynamic> userData = usersMap[uid];

        ChatUser user = ChatUser(
          fullname: userData['fullname'] ?? 'Unknown',
          email: userData['email'] ?? 'No email',
          imageUrl: userData['imageUrl'] ?? 'assets/images/default_avatar.png',
          uid: uid,
        );

        if (!_chatList.any((u) => u.uid == user.uid)) {
          setState(() {
            _chatList.add(user);
          });
        }
      } else {
        print("User not found for email: $email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No user found with that email.")),
        );
      }
    } catch (e) {
      print("An error occurred while searching for user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Future<void> addToUserConversations(String otherUserId) async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) {
      // Handle error: user not logged in...
      return;
    }

    DatabaseReference userConversationsRef = FirebaseDatabase.instance.ref('user-conversations/$currentUserId');
    await userConversationsRef.child(otherUserId).set(true);
    // Also, add the current user to the other user's conversations list
    DatabaseReference otherUserConversationsRef = FirebaseDatabase.instance.ref('user-conversations/$otherUserId');
    await otherUserConversationsRef.child(currentUserId).set(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: Row(children: <Widget>[
          Image.asset('assets/image/image_no_bg.png',width: 50,fit: BoxFit.contain,),
          Spacer(flex: 1,),
          Text(
            "Chat Page",
            style: TextStyle(fontSize: 30),
          ),

            Spacer(),
            IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show a dialog or another screen with a TextField to enter the email
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Search User by Email'),
                  content: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(hintText: 'Enter email address'),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Search'),
                      onPressed: () {
                        searchUserByEmail(_searchController.text.trim());
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
          ? Center(child: Text('No chats yet. Search to start a conversation.'))
          : ListView.builder(
        itemCount: _chatList.length,
        itemBuilder: (context, index) {
          final user = _chatList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl),
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
void buildChatList() {
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  if (currentUserId.isEmpty) {
    // Handle error: user not logged in...
    return;
  }

  DatabaseReference userConversationsRef = FirebaseDatabase.instance.ref('user-conversations/$currentUserId');
  userConversationsRef.onValue.listen((DatabaseEvent event) {
    // Handle the event to build the chat list
    // You would likely need to make additional queries to get user details for each UID in the conversation list
  });
}