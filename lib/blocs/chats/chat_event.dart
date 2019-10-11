import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'model/Message.dart';

abstract class ChatEvent extends Equatable {
  ChatEvent([List props = const <dynamic>[]]) : super(props);
}

// FetchMessagesEvent (triggered when chat opens),
class FetchMessagesEvent extends ChatEvent {
  final String chatId;

  FetchMessagesEvent(this.chatId): super([chatId]);

  @override
  String toString() => 'FetchMessagesEvent';

 }
//ReceivedMessagesEvent (triggered when messages stream has any updates to deliver)
class ReceivedMessagesEvent extends ChatEvent {
  final List<Message> messages;
  ReceivedMessagesEvent(this.messages): super([messages]);

  @override
  String toString() => 'ReceivedMessagesEvent';
}
//SendTextMessageEvent (used to send a normal text message).
class SendTextMessageEvent extends ChatEvent {
  final String chatId;
  final Message message;
  SendTextMessageEvent(this.chatId, this.message): super([chatId, message]);

  @override
  String toString() => 'SendTextMessageEvent';
 }
//PickedAttachmentEvent ( when the user has picked a attachment as a message).
class PickedAttachmentEvent extends ChatEvent {
  final String chatId;
  final File file;
  final FileType fileType;

  PickedAttachmentEvent(this.chatId, this.file, this.fileType): super([chatId, file, fileType]);

  @override
  String toString() => 'PickedAttachmentEvent';
}
