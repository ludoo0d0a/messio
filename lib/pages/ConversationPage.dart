import 'package:flutter/material.dart';

import 'package:messio/widgets/ChatAppBar.dart';
import 'package:messio/widgets/ChatListWidget.dart';
import 'package:messio/widgets/ConversationBottomSheetWidget.dart';
import 'package:messio/widgets/InputWidget.dart';

class ConversationPage extends StatefulWidget {
//  ConversationPage({Key key}) : super(key: key);

  const ConversationPage();

  @override
  _ConversationPageState createState() => _ConversationPageState();

}

class _ConversationPageState extends State<ConversationPage> {

  // dont forget key: _scaffoldKey, in Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: ChatAppBar(),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ChatListWidget(),//Chat list
                GestureDetector(
                    child: InputWidget(),
                    onPanUpdate: (details) {
                      if (details.delta.dy <0) {
                        _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
                          return ConversationBottomSheetWidget();
                        });
                      }
                    })
              ],
            )
          ],
        ),
      )
    );
  }
}
