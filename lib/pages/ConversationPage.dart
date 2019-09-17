import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

import 'package:messio/widgets/ChatAppBar.dart';
import 'package:messio/widgets/ChatListWidget.dart';

class ConversationPage extends StatefulWidget {
//  ConversationPage({Key key}) : super(key: key);

  const ConversationPage();

  @override
  _ConversationPageState createState() => _ConversationPageState();

}

class _ConversationPageState extends State<ConversationPage> {

  // dont forget key: _scaffoldKey, in Scaffold
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ChatAppBar(),
        ),
        Expanded(
          flex: 11,
          child: Container(
            child: ChatListWidget(),
            color: Palette.chatBackgroundColor
          ),
        )
      ],
    );

//    return SafeArea(
//      child: Scaffold(
////        key: _scaffoldKey,
//        appBar: ChatAppBar(),
//        body: Stack(
//          children: <Widget>[
//            Column(
//              children: <Widget>[
//                ChatListWidget(),//Chat list
////                GestureDetector(
////                    child: InputWidget(),
////                    onPanUpdate: (details) {
////                      if (details.delta.dy <0) {
////                        _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
////                          return ConversationBottomSheetWidget();
////                        });
////                      }
////                    })
//              ],
//            )
//          ],
//        ),
//      )
//    );
  }
}
