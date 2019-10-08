import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/authentication/bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/pages/ContactList.dart';


class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {

  const ChatAppBar();
  final double height = 100;

  @override
  _ChatAppBarState createState() => _ChatAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _ChatAppBarState extends State<ChatAppBar> {
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
    initApp();
    super.initState();
  }

  void initApp() async{
    // Add auth bloc, but tests failed...

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
//    authenticationBloc.state.listen((state) {
//      if (state is Authenticated) {
//        updatePageState(1);
//      }
//    });
  }


  @override
  Widget build(BuildContext context) {

    var textHeading = TextStyle(color: Palette.primaryTextColor, fontSize: 20); // Text style for the name
    var textStyle = TextStyle(color: Palette.secondaryTextColor); // Text style for everything else

//    double width = MediaQuery.of(context).size.width; // calculate the screen width

    profileImage = Image.asset(Assets.user).image;

    return Material(
      child:

//      BlocBuilder<AuthenticationBloc, AuthenticationState>(
//        builder: (context, state) {
//
//          profileImage = Image.asset(Assets.user).image;
//          if (state is ProfileUpdated ) {
////            profileImage = Image.network(state.user.photoUrl).image;
//            profileImage = null;
//          // TODO : load profile
//          }else if (state is PreFillData ) {
//            age = state.user.age != null ? state.user.age : 18;
//            profileImage = Image.network(state.user.photoUrl).image;
//            userTitle = state.user.name != null ? state.user.name : userTitleDefault;
//            userNickname = state.user.username != null ? state.user.username : userNicknameDefault;
//          } else if (state is ReceivedProfilePicture) {
//            profileImageFile = state.file;
//            profileImage = Image.file(profileImageFile).image;
//          }

//            return
            Container(
                decoration: new BoxDecoration(boxShadow: [ //adds a shadow to the appbar
                  new BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0,
                  )]),
                child: Container(
                    color: Palette.primaryBackgroundColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 7,
                          child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  //first row containing the name and login
                                  Expanded(
                                    flex: 7,
                                    child: Container(
//                            height: 70 - (width * .06),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // 2/8 : left icon
                                            Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: IconButton(
                                                      icon: Icon(
                                                          Icons.attach_file,
                                                          color: Palette.secondaryColor
                                                      ),
                                                      onPressed: () => {}
                                                  ),
                                                )),
                                            // 6/8 : texts on 2 rows
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,

                                                    children: <Widget>[
                                                      Text(userTitle, style: textHeading),
                                                      Text(userNickname, style: textStyle)
                                                    ],
                                                  )
                                              ),
                                            )

                                          ],
                                        )
                                    ),
                                  ),
                                  //second row containing the buttons for media (Photos / Videos / Files)
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      // height: 23,
                                      padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Photos',
                                            style: textStyle,
                                          ),
                                          VerticalDivider(
                                            width: 30,
                                            color: Palette.primaryTextColor,
                                          ),
                                          Text(
                                            'Videos',
                                            style: textStyle,
                                          ),
                                          VerticalDivider(
                                            width: 30,
                                            color: Palette.primaryTextColor,
                                          ),
                                          Text('Files', style: textStyle)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        //This is the display picture
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Center(
                                    child: IconButton(
                                      icon: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: profileImage
                                      ),
                                      onPressed: () => navigateToHome(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: FlatButton(
                                      child: Text('Logout'),
                                      onPressed: () => logout(),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            ),
                          ),
                      ],
                    )
                )
            )

//        } // bloc
//      ), // bloc
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


}
