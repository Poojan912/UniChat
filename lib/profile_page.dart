import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  File? _image;

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
        backgroundColor: Colors.purple,
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
                  Text("Jainish Madarchod", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Can't talk. Unichat only!", style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            title: Text('Email'),
            subtitle: Text('jainishmadarchod@gmail.com'),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text('+1 415.111.0000'),
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
