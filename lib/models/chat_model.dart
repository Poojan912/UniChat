class ChatModel {
  final String msg;
  final int chatIndex;
  final int isURL;

  ChatModel({required this.msg, required this.chatIndex, required this.isURL});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
        isURL: json["isURL"],
      );
}
