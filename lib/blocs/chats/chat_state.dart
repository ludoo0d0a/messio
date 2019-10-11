import 'package:equatable/equatable.dart';
import 'package:messio/blocs/chats/model/Message.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super(props);
}

class InitialChatState extends ChatState {
  @override
  String toString() => 'InitialChatState';
}

class FetchedMessagesState extends ChatState {
  FetchedMessagesState(List<Message> messages);

  @override
  String toString() => 'FetchedMessagesState';
}

class ErrorState extends ChatState{
  final Exception exception;
  ErrorState(this.exception): super([exception]);

  @override
  String toString() => 'ErrorState';
}
