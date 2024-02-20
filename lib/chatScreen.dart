import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unichat/chat_user.dart';
import 'package:http/http.dart' as http;


class ChatMessage {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp? timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.isMe,
    this.timestamp,
  });

  static ChatMessage fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      text: data['text'],
      sender: data['sender'],
      isMe: data['sender'] == FirebaseAuth.instance.currentUser?.uid,
      timestamp: data['timestamp'],
    );
  }
}


class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  late CollectionReference _messagesRef;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    if (currentUserId.isNotEmpty && widget.user.uid.isNotEmpty) {
      String chatRefId = getChatId(currentUserId, widget.user.uid);
      _messagesRef = FirebaseFirestore.instance.collection('chats/{$chatRefId}/messages');
    }
  }



  void _sendMessage(String text) {
    if (text.trim().isEmpty || _messagesRef == null) {
      print('Text is empty or _messagesRef is null');
      return;
    }

    _messagesRef.add({
      'sender': currentUserId,
      'receiver': widget.user.uid,
      'text': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) async{
      _textController.clear();
      await sendMessageToDiscord(text.trim());
    }).catchError((error) {
      print('Error sending message: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $error')),
      );
    });
  }

  Future<void> sendMessageToDiscord(String message) async {
    var url = Uri.parse('https://discord.com/api/webhooks/1208475651779338250/FxGlVIeOAYfAZLlt7QG0Jju4NwMzymhR-wNk8SBoDy5L71_TK_pWdhhbJEqq_jb1TL9u');
    var response = await http.post(url, headers: {
      "Content-Type": "application/json",
    }, body: jsonEncode({
      "content": message
    }));

    if (response.statusCode == 204) {
      print("Message sent to Discord successfully");
    } else {
      print("Failed to send message to Discord");
    }
  }

  String getChatId(String senderUid, String receiverUid) {

    List<String> ids = [senderUid, receiverUid];
    ids.sort();
    return ids.join('-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.imageUrl),
            ),
            SizedBox(width: 15),
            Text(widget.user.fullname),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesRef.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: Text('No messages'));
                var messages = snapshot.data!.docs.map((doc) => ChatMessage.fromDocument(doc)).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) => MessageWidget(
                    text: messages[index].text,
                    isMe: messages[index].sender == currentUserId,
                    timestamp: messages[index].timestamp,
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Send a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      _sendMessage(_textController.text);
                    },
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final Timestamp? timestamp;

  const MessageWidget({
    Key? key,
    required this.text,
    required this.isMe,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime messageDateTime = timestamp != null ? timestamp!.toDate() : DateTime.now();
    final String displayTime = "${messageDateTime.hour}:${messageDateTime.minute.toString().padLeft(2, '0')}";
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: isMe ? Colors.purple : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              displayTime,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}