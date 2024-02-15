class UserData {
  final String fullName;
  final String email;
  final String phoneNumber;

  UserData({required this.fullName, required this.email, required this.phoneNumber});

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      fullName: data['fullname'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
    );
  }
}