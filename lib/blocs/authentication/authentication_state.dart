import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'model/user.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const <dynamic>[]]) : super(props);
}

class InitialAuthenticationState extends AuthenticationState {}

class Uninitialized extends AuthenticationState{
  @override
  String toString() => 'Uninitialized';
}

class AuthInProgress extends AuthenticationState{
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthenticationState{
  final FirebaseUser user;
  Authenticated(this.user);
  @override
  String toString() => 'Authenticated';
}

class PreFillData extends AuthenticationState{
  final User user;
  PreFillData(this.user);
  @override
  String toString() => 'PreFillData';
}

class UnAuthenticated extends AuthenticationState{
  @override
  String toString() => 'UnAuthenticated';
}

class ReceivedProfilePicture extends AuthenticationState{
  final File file;
  ReceivedProfilePicture(this.file);
  @override toString() => 'ReceivedProfilePicture';
}

class ProfileUpdateInProgress extends AuthenticationState{
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthenticationState{
//  final User user;
//  ProfileUpdated(this.user);
  @override
  String toString() => 'ProfileComplete';
}