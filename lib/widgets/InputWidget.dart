import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';

import '../config/Palette.dart';

class InputWidget extends StatelessWidget {

  static final TextEditingController textEditingController = TextEditingController();

  const InputWidget();

  void sendMessage(context){
    BlocProvider.of<ChatBloc>(context).dispatch(SendTextMessageEvent(textEditingController.text));
    textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                color: Palette.primaryColor,
                onPressed: () {},
              ),
            ),
            color: Colors.white,
          ),

          // Text input
          Flexible(
            child: Material(
              child: Container(
                child: TextField(
                  style: TextStyle(color: Palette.primaryTextColor, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(color: Palette.greyColor),
                  ),
                ),
              ),
            ),
          ),

          // Send Message Button
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => sendMessage(context),
                color: Palette.accentColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(
                  color: Palette.greyColor,
                  width: 0.5
              )),
          color: Colors.white),
    );
  }
}