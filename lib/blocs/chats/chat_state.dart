import 'package:equatable/equatable.dart';
import 'package:messio/blocs/authentication/model/user.dart';
import 'package:messio/blocs/chats/model/Message.dart';
import 'package:meta/meta.dart';

import 'model/Chat.dart';

@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super(props);
}

class InitialChatState extends ChatState {
  @override
  String toString() => 'InitialChatState';
}

class FetchedMessagesState extends ChatState {
  final List<Message> messages;

  FetchedMessagesState(this.messages) : super([messages]);

  @override
  String toString() => 'FetchedMessagesState';
}

class ErrorState extends ChatState{
  final Exception exception;
  ErrorState(this.exception): super([exception]);

  @override
  String toString() => 'ErrorState';
}




class FetchedChatListState extends ChatState {
  final List<Chat> chatList;

  FetchedChatListState(this.chatList) : super([chatList]);

  @override
  String toString() => 'FetchedChatListState';
}

class FetchedContactDetailsState extends ChatState {
  final User user;

  FetchedContactDetailsState(this.user) : super([user]);

  @override
  String toString() => 'FetchedContactDetailsState';
}

class PageChangedState extends ChatState {
  final int index;
  final Chat activeChat;
  PageChangedState(this.index, this.activeChat) : super([index, activeChat]);

  @override
  String toString() => 'PageChangedState';
}