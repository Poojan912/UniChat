import 'dart:ui';

// import 'dart:ui_web';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unichat/constants/constant.dart';
import 'package:unichat/services/assets_manager.dart';
import 'package:unichat/widgets/text_widget.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  get childIndex => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? AssetsManager.userImage : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: chatIndex == 0
                      ? Text(
                    msg,
                    style: const TextStyle(color: Colors.white), // Change font color to white for the user
                  )
                      : AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        msg.trim(),
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                    isRepeatingAnimation: false,
                    repeatForever: false,
                    displayFullTextOnTap: true,
                    totalRepeatCount: 1,
                  ),
                ),
                if (chatIndex != 0)
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () => _showCustomDialog(context),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  void _showPopupMenu(BuildContext context) async {
    final RenderBox? overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox?;

    if (overlay != null) {
      await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            const Offset(100, 100) & const Size(40, 40),
            // smaller rect, the touch area
            Offset.zero & overlay.size // Bigger rect, the entire screen
            ),
        items: [
          PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
          PopupMenuItem(
            value: 'copy',
            child: Text('Copy'),
          ),
        ],
      ).then((value) {
        // Check value for 'delete' or 'copy' and perform action
        if (value == 'delete') {
          // Implement delete action
        } else if (value == 'copy') {
          // Implement copy action
        }
      });
    } else {
      // Handle the case where the overlay context is not found
      print("Overlay context not found");
    }
  }

  void _showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const SizedBox
            .shrink(); // Empty container to comply with pageBuilder requirements
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      // Background color with opacity
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                        onTap: () {
                          // Implement delete action
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.copy),
                        title: const Text('Copy'),
                        onTap: () {
                          // Copy the message to the clipboard
                          Clipboard.setData(ClipboardData(text: msg)).then((_) {
                            Navigator.of(context)
                                .pop(); // Close the dialog after copying
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Message copied to clipboard!'),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
