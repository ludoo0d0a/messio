import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth{}
class GoogleSignInMock extends Mock implements GoogleSignIn{}

class FirebaseUserMock extends Mock implements FirebaseUser{
  @override
  String get displayName => 'John Doe';
  @override
  String get uid => 'uid';
  @override
  String get email => 'johndoe@mail.com';
  @override
  String get photoUrl => 'http://www.adityag.me';
}

class GoogleSignInAuthenticationMock extends Mock implements GoogleSignInAuthentication{
  @override
  String get accessToken => 'mock_access_token';
  @override
  String get idToken => 'mock_id_token';
}

class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount{
}


/*
StorageProvider Mocks
 */

class FirebaseStorageMock extends Mock implements FirebaseStorage{}
class StorageReferenceMock extends Mock implements StorageReference{
  StorageReferenceMock childReference;
  StorageReferenceMock({this.childReference});
  @override
  StorageReference child(String path) {
    // TODO: implement child
    return childReference;
  }
}
class StorageUploadTaskMock extends Mock implements StorageUploadTask{}
class StorageTaskSnapshotMock extends Mock implements StorageTaskSnapshot{}


class MockFile extends Mock implements File{}
