import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:messio/blocs/chats/model/Message.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:intl/intl.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/widgets/BottomSheetFixed.dart';
import 'package:messio/widgets/VideoPlayerWidget.dart';

class ChatItemWidget extends StatelessWidget {
  final Message message;

  const ChatItemWidget(this.message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
    final isSelf = message.isSelf;
    return Container(
        child: Column(children: <Widget>[
          buildMessageContainer(isSelf, message, context),
          buildTimeStamp(isSelf, message)
        ]));
  }

  Row buildMessageContainer(bool isSelf, Message message, BuildContext context) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    if (message is TextMessage) {
      lrEdgeInsets = 15.0;
      tbEdgeInsets = 10.0;
    }
    return Row(
      children: <Widget>[
        Container(
          child: buildMessageContent(isSelf, message,context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: BoxConstraints(maxWidth: 200.0),
          decoration: BoxDecoration(
              color: isSelf
                  ? Palette.selfMessageBackgroundColor
                  : Palette.otherMessageBackgroundColor,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
        )
      ],
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.end
          : MainAxisAlignment.start, // aligns the chatitem to right end
    );
  }

  buildMessageContent(bool isSelf, Message message, BuildContext context) {
    if (message is TextMessage) {
      return Text(
        message.text,
        style: TextStyle(
            color:
            isSelf ? Palette.selfMessageColor : Palette.otherMessageColor),
      );
    } else if (message is ImageMessage) {
      print("imageurl : ${message.imageUrl}");
//      return Text(
//        "image"
//      );
      return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FadeInImage(
            placeholder: AssetImage(Assets.placeholder),
            image: NetworkImage(message.imageUrl),
            height: 200,
          ));
    } else if (message is VideoMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  width: 130,
                  color: Palette.secondaryColor,
                  height: 80,
                ),
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.videocam,
                      color: Palette.primaryColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                          fontSize: 20,
                          color: isSelf
                              ? Palette.selfMessageColor
                              : Palette.otherMessageColor),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                height: 40,
                child: IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: isSelf
                          ? Palette.selfMessageColor
                          : Palette.otherMessageColor,
                    ),
                    onPressed: () =>showVideoPlayer(context,message.videoUrl)))
          ],
        ),
      );
    }else if(message is FileMessage){
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  width: 130,
                  color: Palette.secondaryColor,
                  height: 80,
                ),
                Column(
                  children: <Widget>[
                    Icon(
                      Icons.insert_drive_file,
                      color: Palette.primaryColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'File',
                      style: TextStyle(
                          fontSize: 20,
                          color: isSelf
                              ? Palette.selfMessageColor
                              : Palette.otherMessageColor),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                height: 40,
                child: IconButton(
                    icon: Icon(
                      Icons.file_download,
                      color: isSelf
                          ? Palette.selfMessageColor
                          : Palette.otherMessageColor,
                    ),
                    onPressed: () => downloadFile(message.fileUrl)))
          ],
        ),
      );
    }
  }

  Row buildTimeStamp(bool isSelf, Message message) {
    return Row(
        mainAxisAlignment:
        isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(message.timeStamp)),
              style: Styles.date,
            ),
            margin: EdgeInsets.only(
                left: isSelf ? 5.0 : 0.0,
                right: isSelf ? 0.0 : 5.0,
                top: 5.0,
                bottom: 5.0),
          )
        ]);
  }

  void showVideoPlayer(parentContext,String videoUrl) async {
    await showModalBottomSheetApp(
        context: parentContext,
        builder: (BuildContext bc) {
          return VideoPlayerWidget(videoUrl);
        });
  }

  /*
  Supporting only for android for now
   */
  downloadFile(String fileUrl) async {
    final Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    final String downloadsPath = downloadsDirectory.path;
    await FlutterDownloader.enqueue(
      url: fileUrl,
      savedDir: downloadsPath,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
  }


}
