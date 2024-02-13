import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';

class chat_page extends StatefulWidget {
  const chat_page({super.key});

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  final List<ChatUser> users = [
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    ChatUser(name: "Alice", lastMessage: "See you tomorrow!", imageUrl: "https://example.com/alice.jpg"),
    ChatUser(name: "Bob", lastMessage: "Got it, thanks!", imageUrl: "https://example.com/bob.jpg"),
    // Add more users as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.imageUrl),
          ),
          title: Text(user.name),
          subtitle: Text(user.lastMessage),
          onTap: () {
            // Implement navigation to chat screen with this user
          },
        );
      },
    ),
      );
  }
}
