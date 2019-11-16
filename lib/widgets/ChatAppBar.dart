import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/authentication/bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/blocs/chats/model/Chat.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/pages/ContactList.dart';

import 'GradientSnackBar.dart';


class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {

  final Chat chat;

  const ChatAppBar(this.chat);

  final double height = 100;

  @override
  _ChatAppBarState createState() => _ChatAppBarState(chat);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _ChatAppBarState extends State<ChatAppBar> {

  ChatBloc chatBloc;
  Chat chat;
  String _username = "";
  String _name = "";
  Image _image = Image.asset(Assets.user);

  _ChatAppBarState(this.chat);

  int currentPage = 0;
  int age = 18;

  File profileImageFile;
  ImageProvider profileImage;
//  AuthenticationBloc authenticationBloc;
  static const String userTitleDefault = "--userTitle";
  static const String userNicknameDefault = "--nickName";
  String userTitle = userTitleDefault;
  String userNickname = userNicknameDefault;

  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// Text style for everything else

    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (bc, state) {
        if (state is FetchedContactDetailsState) {
          print('Received State of Page');
          print(state.user);
          if(state.username== chat.username){
            _name = state.user.name;
            _username = state.user.username;
            _image = Image.network(state.user.photoUrl);
          }
        }
        if(state is PageChangedState){
          print(state.index);
          print('$_name, $_username');
        }
      },
      child:  Material(
          child: Container(
              decoration:  BoxDecoration(boxShadow: [
                //adds a shadow to the appbar
                BoxShadow(
                    color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.1)
              ]),
              child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Palette.primaryBackgroundColor,
                  child: Row(children: <Widget>[
                    Expanded(
                      //we're dividing the appbar into 7 : 3 ratio. 7 is for content and 3 is for the display picture.
                        flex: 7,
                        child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                    flex: 7,
                                    child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                flex: 2,
                                                child: Center(
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.attach_file,
                                                          color:
                                                          Palette.secondaryColor,
                                                        ),
                                                        onPressed: () => showAttachmentBottomSheet(context),
                                                        ))),
                                            Expanded(
                                                flex: 6,
                                                child: Container(child:
                                                BlocBuilder<ChatBloc, ChatState>(
                                                    builder: (context, state) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(_name,
                                                              style: Styles.textHeading),
                                                          Text('@$_username',
                                                              style: Styles.text)
                                                        ],
                                                      );
                                                    }))),
                                          ],
                                        ))),
                                //second row containing the buttons for media
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Photos',
                                              style: Styles.text,
                                            ),
                                            VerticalDivider(
                                              width: 30,
                                              color: Palette.primaryTextColor,
                                            ),
                                            Text(
                                              'Videos',
                                              style: Styles.text,
                                            ),
                                            VerticalDivider(
                                              width: 30,
                                              color: Palette.primaryTextColor,
                                            ),
                                            Text('Files', style: Styles.text)
                                          ],
                                        ))),
                              ],
                            ))),
                    //This is the display picture
                    Expanded(
                        flex: 3,
                        child: Container(child: Center(child:
                        BlocBuilder<ChatBloc, ChatState>(
                            builder: (context, state) {
                              return CircleAvatar(
                                radius: 30,
                                backgroundImage: _image.image,
                              );
                            })))),
                  ])))),
    );
  }

  // Plug on avatar click for now
  navigateToHome() {
    Navigator.push(
      context,
//      SlideLeftRoute(page: ConversationPageSlide()),
      SlideLeftRoute(page: ContactListPage()),
    );
  }

  logout() {
    authenticationBloc.dispatch(ClickedLogout());
  }

  showAttachmentBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child:  Wrap(
              children: <Widget>[
                ListTile(
                    leading:  Icon(Icons.image),
                    title:  Text('Image'),
                    onTap: () => showFilePicker(FileType.IMAGE)
                ),
                ListTile(
                    leading:  Icon(Icons.videocam),
                    title:  Text('Video'),
                    onTap: () => showFilePicker(FileType.VIDEO)
                ),
                ListTile(
                  leading:  Icon(Icons.insert_drive_file),
                  title:  Text('File'),
                  onTap: () => showFilePicker(FileType.ANY),
                ),
              ],
            ),
          );
        }
    );
  }

  showFilePicker(FileType fileType) async {
    File file = await FilePicker.getFile(type: fileType);
    chatBloc.dispatch(SendAttachmentEvent(chat.chatId,file,fileType));
    Navigator.pop(context);
    GradientSnackBar.showMessage(context, 'Sending attachment..');
  }


}


