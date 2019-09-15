import 'package:flutter/material.dart';

import 'ConversationPage.dart';

class ConversationPageList extends StatefulWidget {
  ConversationPageList({Key key}) : super(key: key);

  @override
  _ConversationPageListState createState() => _ConversationPageListState();
}

class _ConversationPageListState extends State<ConversationPageList> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        ConversationPage(),
        ConversationPage(),
        ConversationPage()
      ],
    );
  }
}