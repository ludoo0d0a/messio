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
        print('ChatListWidget state:'+state.toString());
        if(state is FetchedMessagesState){
          // TODO : this do not pass here at first loading
          messages = state.messages;
          print("FetchedMessagesState:");
          print(state.messages);
        }
        return       ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => ChatItemWidget(messages[index]),
          itemCount: messages.length,
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