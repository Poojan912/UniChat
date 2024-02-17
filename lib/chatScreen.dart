import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';
import 'package:unichat/ChatMessage.dart'; // Make sure you have this ChatMessage model

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  CollectionReference _messagesRef = FirebaseFirestore.instance.collection('chats');
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

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
              // Order the messages by timestamp in ascending order
              stream: _messagesRef.orderBy('timestamp', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages'));
                }

                List<MessageWidget> messages = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return MessageWidget(
                    text: data['text'] ?? '',
                    isMe: data['sender'] == currentUserId,
                    timestamp: data['timestamp'],
                  );
                }).toList();

                return ListView.builder(
                  reverse: false, // Set to false to maintain the order from the stream
                  itemCount: messages.length,
                  itemBuilder: (context, index) => messages[index],
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                    ),
                    onSubmitted: (text) { // Handle send on keyboard submit
                      _sendMessage(text);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      _sendMessage(_textController.text);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    Map<String, dynamic> messageData = {
      'sender': currentUserId,
      'receiver': widget.user.uid,
      'text': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    _messagesRef.add(messageData).then((docRef) {
      print('Message sent successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent')),
      );
    }).catchError((error) {
      print('Error sending message: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $error')),
      );
    });
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final Timestamp timestamp;

  const MessageWidget({
    Key? key,
    required this.text,
    required this.isMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime messageDateTime = timestamp.toDate();
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

// Make sure the classes ChatUser and ChatMessage are defined