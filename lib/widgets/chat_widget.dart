import 'dart:io';
import 'dart:ui';

// import 'dart:ui_web';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unichat/constants/constant.dart';
import 'package:unichat/services/assets_manager.dart';
import 'package:http/http.dart' as http;
import 'package:unichat/widgets/text_widget.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex, required this.isURL});

  final String msg;
  final int chatIndex;
  final int isURL;

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
                      : isURL==0 ? AnimatedTextKit(
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
                  )
                      : Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.network(msg, height: 250), // Image
                      IconButton(
                        // Download Button
                        icon: Icon(Icons.download, color: Colors.white),
                        onPressed: () {
                          // Future.delayed(const Duration(seconds: 0), () async {
                          //   print("DOWNLOAD URL :: "+msg);
                          //   //storeImageInLocally(msg);
                          //   EasyLoading.show();
                          //   var response = await Dio().get(msg,
                          //       options: Options(responseType: ResponseType.bytes));
                          //   EasyLoading.dismiss();
                          //   EasyLoading.showSuccess("Image downloaded to gallery successfully!", duration: const Duration(seconds: 3));
                          //   await ImageGallerySaver.saveImage(
                          //       Uint8List.fromList(response.data),
                          //       quality: 100,
                          //       name: DateTime.now().toString()
                          //   );
                          // });
                          EasyLoading.show();
                          FileDownloader.downloadFile(
                              url: msg,
                              name: DateTime.now().toString(),//(optional)
                              onProgress: (String? fileName, double progress) {
                                print('FILE fileName HAS PROGRESS $progress');
                              },
                              onDownloadCompleted: (String path) {
                                print('FILE DOWNLOADED TO PATH: $path');
                                EasyLoading.dismiss();
                                EasyLoading.showSuccess("Image downloaded successfully to "+path, duration: const Duration(seconds: 3));
                              },
                              onDownloadError: (String error) {
                                print('DOWNLOAD ERROR: $error');
                                EasyLoading.dismiss();
                                EasyLoading.showSuccess(""+error, duration: const Duration(seconds: 3));
                              });
                        },
                      ),
                    ],
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

  void storeImageInLocally(String imageURL) async {
    try {
      String timeStamp = DateTime.now().toString();
      EasyLoading.show();
      /*var response = await Dio().get(imageUrl,
        options: Options(responseType: ResponseType.bytes));*/
      var url = imageURL;
      var response = await http.get(Uri.parse(url)); // get(Uri.parse(url))
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + "/images";
      var filePathAndName = documentDirectory.path + '/images/pic.jpg';
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName);             // <-- 2
      file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
      EasyLoading.dismiss();
      EasyLoading.showSuccess("File downloaded successfully");
      //print("New Path :: "+file2.path);
    } catch (error) {
      EasyLoading.dismiss();
      EasyLoading.showError("Image not found");
      print(error.toString());
    }

  }
}
