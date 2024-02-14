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
  List<ChatMessage> messages = []; // This will be your list of messages

  @override
  void initState() {
    super.initState();
    // TODO: Load your existing chat messages here
  }

  void _sendMessage(String text) {
    // TODO: Implement send message logic and call setState to update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Align(
                    alignment: message.sender == 'me' ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: message.sender == 'me' ? Colors.blue : Colors.grey,
                      child: Text(message.text),
                    ),
                  ),
                  subtitle: Text(message.timestamp.toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      _sendMessage(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Call _sendMessage with the text from the TextField
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
