import 'package:firebase_database/firebase_database.dart';

class ChatUser {
  final String fullname;
  final String email;
  final String imageUrl;
  final String uid;

  ChatUser({required this.fullname, required this.email, required this.imageUrl,required this.uid});

  factory ChatUser.fromSnapshot(DataSnapshot snapshot) {
    // Cast the snapshot value to a Map before accessing its keys.
    final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;

    return ChatUser(
        fullname: data['fullname'] ?? 'Unknown',       // Provide a default value in case the key doesn't exist
        email: data['email'] ?? 'No email',    // Provide a default value in case the key doesn't exist
        imageUrl: data['imageUrl'] ?? '/assets/image/image_no_bg.png', // Provide a default value or placeholder URL
        uid : data['uid'] ?? ''
    );
  }
}


// Modify ChatUser.fromMap to include a UID parameter
extension ChatUserExtension on ChatUser {
  static ChatUser fromMap(Map<String, dynamic> data, String uid) {
    return ChatUser(
      fullname: data['fullname'] ?? 'Unknown',
      email: data['email'] ?? 'No email',
      imageUrl: data['imageUrl'] ?? 'assets/images/default_avatar.png',
      uid: data['uid'] ?? '',
    );
  }
}