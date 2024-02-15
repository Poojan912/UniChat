import 'package:flutter/material.dart';
import 'package:unichat/chat_user.dart';
import 'package:unichat/chatMessage.dart'; // Import your ChatMessage model

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [
    // Sample messages, replace with your actual data
    ChatMessage(sender: 'Jessica', text: 'I hope you like Crazy Alien movie!!!', timestamp: DateTime.now().subtract(Duration(minutes: 5))),
    ChatMessage(sender: 'me', text: 'Yes of course i like very much. 😊', timestamp: DateTime.now().subtract(Duration(minutes: 3))),
    // Add more sample messages as needed
  ];

  final TextEditingController _textController = TextEditingController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message = ChatMessage(
      sender: 'me',
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(message);
    });

    _textController.clear();
    // TODO: Implement your send message logic (API call, socket connection, etc.)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(

              backgroundImage: NetworkImage(widget.user.imageUrl), // Your user's profile image
              //backgroundColor: Colors.grey, // Placeholder color
            ),
            SizedBox(width: 15), // For spacing between the image and the name
            Text(widget.user.name),
          ],
        ),

        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement more actions
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // To keep the input field at the bottom and start the chat from the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index]; // Reverse the message order
                final bool isMe = message.sender == 'me';
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
                          message.text,
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          // Format the timestamp into the desired format
                          "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')} ${isMe ? 'pm' : 'am'}",
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {
                    // TODO: Implement emoji functionality
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
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
