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
        return chat_page();
      case 1:
        return call_page();
      case 2:
        return ProfilePage();
      default:
        return chat_page(); // Default to chat page if index is not recognized
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
        appBar: AppBar(
          title : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/image/image_no_bg.png',width: 40,fit: BoxFit.contain,),
              Text(
                "UniChat",
                style: TextStyle(fontSize: 30),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  //handle search function
                } ,
                child: Icon(Icons.search,size: 32),
              )


            ],
          ),
        ),
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
