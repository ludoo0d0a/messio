import 'package:flutter/material.dart';

import 'chat_item_widget.dart';

class ChatListWidget extends StatelessWidget {

  final ScrollController listScrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    // A Flexible widget must be a descendant of a Row, Column, or Flex,
    // https://api.flutter.dev/flutter/widgets/Flexible-class.html
    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => ChatItemWidget(index),
              itemCount: 20,
              reverse: true,
              controller: listScrollController,
          )
        )
      ]
    );
  }
}