import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'UserData.dart';
class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late DatabaseReference dbRef;
  File? _image;
  UserData? _userData;
  String displayName = "";
  @override
  void initState() {
    super.initState();
    fetchUserData();
    dbRef = FirebaseDatabase.instance.ref().child('Users');
  }
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final dbRef = FirebaseDatabase.instance.ref().child('Users').child(uid);
      final snapshot = await dbRef.get();
      print("snapshot : ${snapshot}");
      if (snapshot.exists) {
        // Adjust the line below to properly cast the data
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _userData = UserData.fromMap(data);
          print(_userData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade200,
        title: Text('Your Profile'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20), // For padding on the left
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40, // Smaller radius for a smaller profile image
                    backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/image/default_profile_pic.png') as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                  IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(Icons.edit, size: 20),
                    padding: EdgeInsets.all(0), // Removes default padding
                    constraints: BoxConstraints(), // Removes default size constraints
                  ),
                ],
              ),
              SizedBox(width: 20), // For spacing between the image and the name
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
    );
  }
}
