import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';
import 'package:unichat/chatMessage.dart'; // Import your ChatMessage model
import 'package:http/http.dart' as http;
import 'dart:convert';
class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  DatabaseReference? _messagesRef;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    if (currentUserId.isNotEmpty && widget.user.uid != null) {
      String chatRefId = getChatId(currentUserId, widget.user.uid); // Ensure widget.user has a 'uid' property
      _messagesRef = FirebaseDatabase.instance.ref('chats/$chatRefId/messages');
    }
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
  void _sendMessage(String text) {
    if (text.trim().isEmpty || _messagesRef == null) {
      print('Text is empty or _messagesRef is null');
      return;
    }

    final newMessageRef = _messagesRef!.push();
    newMessageRef.set({
      'sender': currentUserId,
      'receiver': widget.user.uid,
      'text': text.trim(),
      'timestamp': ServerValue.timestamp,
    }).then((_) async { // Make sure to handle this asynchronously
      _textController.clear();
      await sendMessageToDiscord(text.trim()); // Send message to Discord
    }).catchError((error) {
      // Handle errors here
      print('Error sending message: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    });
  }


  String getChatId(String senderUid, String receiverUid) {
    // Sort the UIDs to ensure consistency regardless of who sends the first message
    List<String> ids = [senderUid, receiverUid];
    ids.sort(); // This ensures the order is always the same
    return ids.join('-'); // Create a chat ID by joining the sorted UIDs with a hyphen
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
            child: StreamBuilder<DatabaseEvent>(
              stream: _messagesRef?.orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No messages'));
                }

                Map<dynamic, dynamic>? messagesMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                if (messagesMap == null) {
                  return Center(child: Text('No message data available.'));
                }

                List<MessageWidget> messages = messagesMap.entries.map((entry) {
                  Map<dynamic, dynamic> messageData = entry.value as Map<dynamic, dynamic>;
                  return MessageWidget(
                    text: messageData['text'] ?? '',
                    isMe: messageData['sender'] == currentUserId,
                    timestamp: messageData['timestamp'],
                  );
                }).toList();

                return ListView.builder(
                  reverse: true,
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

                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messagesRef != null) {
                      _sendMessage(_textController.text);
                    } else {
                      // Handle the error, such as prompting the user to log in
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
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final int timestamp;

  const MessageWidget({
    Key? key,
    required this.text,
    required this.isMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime messageDateTime = timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : DateTime.now();
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

              DateTime.fromMillisecondsSinceEpoch(timestamp).toString(), // Format timestamp as needed
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