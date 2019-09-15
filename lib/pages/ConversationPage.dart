import 'package:flutter/material.dart';

import '../widget/ChatAppBar.dart';
import '../widget/ChatListWidget.dart';
import '../widget/InputWidget.dart';

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