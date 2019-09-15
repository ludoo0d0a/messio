import 'package:flutter/material.dart';

import 'chat_app_bar.dart';
import 'chat_list_widget.dart';
import 'input_widget.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage({Key key}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ChatAppBar(),
        body: Stack(
          children: <Widget>[
            ChatListWidget(),//Chat list
            InputWidget(), // The input widget
          ],
        ),
      )
    );
  }
}