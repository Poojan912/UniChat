import 'package:flutter/material.dart';
import 'package:unichat/chat_page.dart';
import 'package:unichat/call_page.dart';
import 'package:unichat/profile_page.dart';
import 'package:unichat/screens/gpt_screen.dart'; // Assuming gpt_screen.dart contains ChatScreen

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  int _selectedIndex = 0;

  Widget _getPageWidget(int index) {
    switch (index) {
      case 0:
        return ChatPage();
      case 1:
        return ChatScreen(); // ChatScreen now in second position
      case 2:
        return call_page(); // call_page moved to third position
      case 3:
        return ProfilePage();
      default:
        return ChatPage(); // Default to chat page if index is not recognized
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _getPageWidget(_selectedIndex), // Use the page based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem( // ChatScreen now between Chat and Call
            icon: Icon(Icons.chat),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        backgroundColor: Colors.white, // Background color of the bottom navigation bar
      ),
    );
  }
}
