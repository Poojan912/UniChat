import 'package:firebase_database/firebase_database.dart';

class ChatUser {
  final String fullname;
  final String email;
  final String imageUrl;
  final String uid;



  ChatUser({required this.fullname, required this.email, required this.imageUrl,required this.uid});

  factory ChatUser.fromSnapshot(DataSnapshot snapshot) {

    final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    return ChatUser(
      fullname: data['fullname'] ?? 'Unknown',
      email: data['email'] ?? 'No email',
      imageUrl: data['imageUrl'] ?? '/assets/image/image_no_bg.png',
      uid : data['uid'] ?? ''
    );
  }

  Map<String, dynamic> toJson() => {
    'fullname': fullname,
    'email': email,
    'imageUrl': imageUrl,
    'uid': uid,
  };

  static ChatUser fromJson(Map<String, dynamic> json) => ChatUser(
    fullname: json['fullname'],
    email: json['email'],
    imageUrl: json['imageUrl'],
    uid: json['uid'],
  );
}
