import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messio/blocs/authentication/bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/pages/ContactList.dart';
//import 'package:messio/pages/ConversationPageSlide.dart';
//import 'package:messio/widgets/ChatAppBar.dart';
//import 'package:messio/widgets/ChatListWidget.dart';
import 'package:messio/widgets/CircleIndicatorWidget.dart';
import 'package:messio/widgets/NumberPicker.dart';

import 'ConversationPageSlide.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentPage = 0;
  int age = 18;

  //fields for the form
  File profileImageFile;
  ImageProvider profileImage;
  final TextEditingController usernameController = TextEditingController();

  //this variable keeps track of the keyboard, when its shown and when its hidden
  var isKeyboardOpen = false;

  // this is the controller of the page.
  // This is used to navigate back and forth between the pages
  PageController pageController = PageController();

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  //Fields related to animating the layout and pushing widgets up when the focus is on the username field
  AnimationController usernameFieldAnimationController;
  Animation profilePicHeightAnimation, usernameAnimation, ageAnimation;
  FocusNode usernameFocusNode = FocusNode();

  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    initApp();
    super.initState();
  }

  void initApp() async{

      WidgetsBinding.instance.addObserver(this);
      usernameFieldAnimationController =
          AnimationController(vsync: this, duration: Duration(milliseconds: 300));
      profilePicHeightAnimation =
      Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
        ..addListener(() {
          setState(() {});
        });
      usernameAnimation =
      Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
        ..addListener(() {
          setState(() {});
        });
      ageAnimation =
      Tween(begin: 80.0, end: 10.0).animate(usernameFieldAnimationController)
        ..addListener(() {
          setState(() {});
        });
      usernameFocusNode.addListener(() {
        if (usernameFocusNode.hasFocus) {
          usernameFieldAnimationController.forward();
        } else {
          usernameFieldAnimationController.reverse();
        }
      });

    pageController.addListener(() {

      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });

    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.state.listen((state) {
      if (state is Authenticated) {
        updatePageState(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        //  avoids the bottom overflow warning when keyboard is shown
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              buildHome(),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthInProgress ||
                      state is ProfileUpdateInProgress) {
                    return buildCircularProgressBarWidget();
                  }
                  return SizedBox();
                },
              ),



            ],
          )
        )
      ),
    );
  }


  buildHome() {
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: begin, end: end, colors: [
                  Palette.gradientStartColor,
                  Palette.gradientEndColor
                ])),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[

                PageView(
                  controller: pageController,
                  // Lock scroll required : go page 2 after google signin
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) => updatePageState(page),
                  children: <Widget>[
                    buidPageOne(),
                    buidPageTwo(),
                  ],
                ),

                // Pager indicator
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < 2; i++)
                        CircleIndicator(i == currentPage),
                    ],
                  ),
                ),

                buildUpdateProfileButtonWidget()
              ],
            )
        )
    );
  }

  buildCircularProgressBarWidget() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
              Palette.gradientStartColor,
              Palette.gradientEndColor
            ])),
        child: Container(
            child: Center(
              child: Column(children: <Widget>[
                buildHeaderSectionWidget(),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Palette.primaryColor)),
                )
              ]),
            )));
  }

  buidPageOne() {
//    var authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Container(
        child: Column(children: <Widget>[
          buildHeaderSectionWidget(),
          // Image

          buildGoogleButtonWidget()

      ]) // Column
    ); // container
  }


  buildHeaderSectionWidget() {
    return Column(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: 250),
          child: Image.asset(Assets.app_icon_fg, height: 100)),
      // Text
      Container(
          margin: EdgeInsets.only(top: 30),
          child: Text('Messio Messenger',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22))
      ),
    ]);
  }


  buildGoogleButtonWidget() {
    return // Login button
      Container(
          margin: EdgeInsets.only(top: 100),
          child: ButtonTheme(
              height: 40,
              child: FlatButton.icon(
//                  onPressed: () => updatePageState(1),
                  onPressed: () => authenticationBloc.dispatch(ClickedGoogleLogin()),
                  color: Colors.transparent,
                  icon: Image.asset(
                    Assets.google_button,
                    height: 25,
                  ),
                  label: Text(
                    'Sign In with Google',
                    style: TextStyle(
                        color: Palette.primaryTextColorLight,
                        fontWeight: FontWeight.w800),
                  ))) // ButtonTheme
      ); // Container #3
  }

  buidPageTwo() {
    return InkWell(
      // to dismiss the keyboard when the user tabs out of the TextField
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child:  BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {

            profileImage = Image.asset(Assets.user).image;
            if (state is PreFillData) {
              age = state.user.age != null ? state.user.age : 18;
              profileImage = Image.network(state.user.photoUrl).image;
            } else if (state is ReceivedProfilePicture) {
              profileImageFile = state.file;
              profileImage = Image.file(profileImageFile).image;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // space 100
                SizedBox(height: profilePicHeightAnimation.value),
                buildProfilePictureWidget(),
                // space 50
                SizedBox(height: ageAnimation.value),
                // Question Text
                Text(
                  'How old are you?',
                  style: Styles.questionLight,
                ),
                buildAgePickerWidget(),
                // space 80
                SizedBox(height: usernameAnimation.value),
                // Question username Container > Text
                Text(
                  'Choose a username',
                  style: Styles.questionLight,
                ),
                buildUsernameWidget()


              ],
            );
          }
      ), //BlocBuilder
    ); //InkWell
  }



  buildProfilePictureWidget() {
    return  // Avatar
      GestureDetector(
        onTap: pickImage,
        child: Container(
          child: CircleAvatar(
            backgroundImage: profileImage,
//          backgroundImage: Image
//              .asset(Assets.user)
//              .image,
            radius: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.camera,
                  color: Colors.white,
                  size: 15,
                ),
                Text(
                  'Set Profile Picture',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  buildAgePickerWidget() {
    return
      // Row > AgePicker
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NumberPicker.horizontal(
              initialValue: age,
              minValue: 15,
              maxValue: 100,
              highlightSelectedValue: true,
              onChanged: (num value) {
                setState(() {
                  age = value;
                });
              }),
          Text('Years', style: Styles.textLight)
        ],
      );
  }

  buildUsernameWidget() {
    return
      // Container > Input
      Container(
        margin: EdgeInsets.only(top: 20),
        width: 120,
        child: TextField(
          textAlign: TextAlign.center,
          style: Styles.subHeadingLight,
          focusNode: usernameFocusNode,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: '@username',
            hintStyle: Styles.hintTextLight,
            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Palette.primaryColor, width: 0.1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Palette.primaryColor, width: 0.1),
            ),
          ),
        ),
      );
  }

  updatePageState(int index) {
    if (currentPage == index) return;
    if (index == 1)
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

    setState(() {
      currentPage = index;
    });
  }


  Future<bool> onWillPop() async {
    if (currentPage == 1) {
      //go to first page if currently on second page
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return false; //Future.value(false);
    }
    return true; // Future.value(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    usernameFieldAnimationController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  ///
  /// This routine is invoked when the window metrics have changed.
  ///
  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (isKeyboardOpen) {
        onKeyboardChanged(false);
      }
      isKeyboardOpen = false;
    } else {
      isKeyboardOpen = true;
      onKeyboardChanged(true);
    }
  }

  onKeyboardChanged(bool isVisible) {
    if (!isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
      usernameFieldAnimationController.reverse();
    }
  }

  navigateToHome() {
    Navigator.push(
      context,
//      SlideLeftRoute(page: ConversationPageSlide()),
      SlideLeftRoute(page: ContactListPage()),
    );
  }

  buildUpdateProfileButtonWidget() {
    return  // Fab button on bottom right
      AnimatedOpacity(
        opacity: currentPage == 1 ? 1.0 : 0.0, //shows only on page 1
        duration: Duration(milliseconds: 500),
        child: Container(
          margin: EdgeInsets.only(right: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FloatingActionButton(
//                onPressed: () => navigateToHome(),
                onPressed: () => authenticationBloc.dispatch(SaveProfile(
                    profileImageFile, age, usernameController.text)),
                elevation: 0,
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  Icons.done,
                  color: Palette.accentColor,
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future pickImage() async {
    profileImageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery
    );
    authenticationBloc.dispatch(PickedProfilePicture(profileImageFile));
  }
}
