import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';
import 'package:unichat/chatScreen.dart';
class chat_page extends StatefulWidget {
  const chat_page({super.key});

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
        stream: _usersRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No users found"));
          }

          Map<dynamic, dynamic> usersData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<ChatUser> users = usersData.entries.map((entry) {
            Map<dynamic, dynamic> userMap = entry.value as Map<dynamic, dynamic>;
            // Assuming userMap contains the keys 'name', 'email', and 'imageUrl'.
            return ChatUser(
              fullname: userMap['fullname'] ?? 'Unknown Name',
              email: userMap['email'] ?? 'No Email',
              imageUrl: userMap['imageUrl'] ?? 'https://example.com/default_avatar.png',
              uid : entry.key
            );
          }).toList();

          return ListView.builder(
            reverse: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
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
                      builder: (context) => ChatScreen(user: user), // 'user' should have a 'uid' property
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
