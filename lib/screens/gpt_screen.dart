//import 'dart:ui_web';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:unichat/widgets/chat_widget.dart';
import 'package:unichat/widgets/text_widget.dart';
import '../constants/constant.dart';
import '../models/chat_model.dart';
import '../provider/models_provider.dart';
import '../services/api_service.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;
  late String messg;
  late String temp;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  bool isUrl(String text) {
    // This is a basic pattern and might not cover all valid URL cases.
    var pattern = r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$';
    var regExp = RegExp(pattern);

    return regExp.hasMatch(text);
  }

  bool isImageUrl(String url) {
    // A basic check for image file extensions in the URL
    return RegExp(r"\.(jpeg|jpg|gif|png)$", caseSensitive: false).hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    if(chatList[index].isURL == 0){
                      return ChatWidget(
                        msg: chatList[index].msg,
                        chatIndex: chatList[index].chatIndex,
                        isURL: chatList[index].isURL,
                      );
                    }else{
                      return ChatWidget(
                        msg: chatList[index].msg,
                        chatIndex: chatList[index].chatIndex,
                        isURL: chatList[index].isURL,
                      );
                    }

                  }),
            ),

            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.black,
                size: 18,
              ),
            ],
            SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                          );
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you?",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void printChatList(List<ChatModel> chatList) {
    for (ChatModel chatModel in chatList) {
      print(chatModel.msg);
      print(isUrl(chatModel.msg));
      print("**********");
    }
  }



  void scrollListToEnd() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.slowMiddle,
    );
  }

  // Ensure this function definition is inside your class or an appropriate scope.
  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    try {
      setState(() {
        _isTyping = true;
        chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0, isURL: 0));

        printChatList(chatList);

        messg = textEditingController.text;

        textEditingController.clear();
        focusNode.unfocus();

      });
      // Assuming ApiService.sendMessage expects a String message and a model ID.
      chatList.addAll(await ApiService.sendMessage(
        message: messg,
        modelId: modelsProvider.currentModel,
      ));

      for (ChatModel chat in chatList) {
        print('-----------------------------------------------------------------------------');
        print('Message: ${chat.msg}');
        print('Chat Index: ${chat.chatIndex}');
        print('Is URL: ${chat.isURL}');
        print('------------------------------------------------------------------------------');
      }
      setState(() {
        // textEditingController.clear();
      });
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }

}

// Future<void> sendMessageFCT(ModelsProvider modelsProvider) async {
//   try {
//     setState(() {
//       _isTyping = true;
//     });
//     chatList = await ApiService.sendMessage(
//       message: textEditingController.text,
//       modelId: modelsProvider.currentModel,
//     );
//     setState(() {});
//   } catch (error) {
//     log("error $error");
//   } finally {
//     setState(() {
//       _isTyping = false;
//     });
//   }
// }