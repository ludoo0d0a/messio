import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/blocs/chats/model/Message.dart';

import 'ChatItemWidget.dart';

class ChatListWidget extends StatefulWidget {

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ScrollController listScrollController =  ScrollController();
  List<Message> messages = List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc,ChatState>(
      builder: (context, state) {
        if(state is FetchedMessagesState){
          messages = state.messages;
          print(state.messages);
        }
        return       ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => ChatItemWidget(messages[index]),
          itemCount: 20,
          reverse: true,
          controller: listScrollController,
//          )
        );
      }
    );
//    return Flexible(
//          child:

  }
}