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
        return ChatScreen();
      case 2:
        return call_page();
      case 3:
        return ProfilePage();
      default:
        return ChatPage();
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
      body: _getPageWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 24,
              height: 24,
              child: Image.asset('assets/chat_logo.png'),
            ),
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
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
