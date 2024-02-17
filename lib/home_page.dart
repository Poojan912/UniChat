import 'package:flutter/material.dart';
import 'package:unichat/call_page.dart';
import 'package:unichat/chat_page.dart';
import 'package:unichat/profile_page.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  Widget _getPageWidget(int index) {
    switch (index) {
      case 0:
        return ChatPage();
      case 1:
        return call_page();
      case 2:
        return ProfilePage();
      default:
        return ChatPage(); // Default to chat page if index is not recognized
    }
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset : false,

      body: _getPageWidget(_selectedIndex), // Use the page based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
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

      ),
    );

  }
}