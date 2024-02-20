import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:unichat/signin_page.dart';

import 'UserData.dart';
class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late FirebaseFirestore dbRef;
  final uid = FirebaseAuth.instance.currentUser;
  File? _image;
  UserData? _userData;
  String displayName = "";
  @override
  void initState() {
    super.initState();
    fetchUserData();
    CollectionReference dbRef = FirebaseFirestore.instance.collection('users');

  }
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final dbRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final snapshot = await dbRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        final data = Map<String, dynamic>.from(snapshot.data()!);
        setState(() {
          _userData = UserData.fromMap(data);
        });
      } else {
        print('No user data available.');
      }
    }
  }



  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signin_page()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title : Row(

          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/image/image_no_bg.png',width: 50,fit: BoxFit.contain,),
            Spacer(flex: 1),
            Text(
              "Your Profile",
              style: TextStyle(fontSize: 30),

            ),
            Spacer(),


          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/image/default_profile_pic.png') as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(Icons.edit, size: 20),
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_userData?.fullName??"User Name", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Can't talk. Unichat only!", style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            title: Text('Email'),
            subtitle: Text(_userData?.email??"@.com"),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text(_userData?.phoneNumber??"11"),
            leading: Icon(Icons.phone),
          ),
          ListTile(
            title: Text('City'),
            subtitle: Text('San Francisco, CA'),
            leading: Icon(Icons.location_city),
          ),
          ListTile(
            title: Text('Country'),
            subtitle: Text('USA'),
            leading: Icon(Icons.flag),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logout();
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.purple.shade200,
        tooltip: 'Logout',
      ),
    );
  }
}
