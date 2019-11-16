
import 'dart:io';
import 'package:messio/blocs/chats/model/Message.dart';

class VideoWrapper {
  final File file; //thumbnail for the video
  final VideoMessage videoMessage;

  VideoWrapper(this.file, this.videoMessage);

}