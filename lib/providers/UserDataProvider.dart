
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/Utils/MessioException.dart';
import 'package:messio/Utils/SharedObjects.dart';
import 'package:messio/blocs/authentication/model/user.dart';
import 'package:messio/blocs/contacts/model/contact.dart';
import 'package:messio/config/Paths.dart';


class UserDataProvider extends BaseUserDataProvider {
  final Firestore fireStoreDb ;

  UserDataProvider({Firestore fireStoreDb}): fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    //reference of the user's document node in database/users. This node is created using uid
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(user.uid);
    final bool userExists = await ref.snapshots().isEmpty; // check if user exists or not
    var data = {
      //add details received from google auth
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
    };
    if (!userExists) {
      // if user entry exists then we would not want to override the photo url with the one received from googel auth
      data['photoUrl'] = user.photoUrl;
    }
    ref.setData(data, merge: true); // set the data
    final DocumentSnapshot currentDocument = await ref.get(); // get updated data reference
    return User.fromFirestore(currentDocument); // create a user object and return
  }

  @override
  Future<User> saveProfileDetails(String profileImageUrl, int age, String username) async {
    String uid = SharedObjects.prefs.get(Constants.sessionUid);
    //get a reference to the map
    DocumentReference mapReference = fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
    var mapData = {'uid': uid};
    //map the uid to the username
    mapReference.setData(mapData);

    //reference of the user's document node in database/users. This node is created using uid
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(uid);
    var data = {
      'photoUrl': profileImageUrl,
      'age': age,
      'username': username,
    };
    ref.setData(data, merge: true); // set the photourl, age and username
    final DocumentSnapshot currentDocument = await ref.get(); // get updated data back from firestore
    return User.fromFirestore(currentDocument); // create a user object and return it
  }

  @override
  Future<bool> isProfileComplete() async {
    String uid = SharedObjects.prefs.get(Constants.sessionUid);
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(uid);  // get reference to the user/ uid node
    final DocumentSnapshot currentDocument = await ref.get();
    return (currentDocument != null &&
        currentDocument.exists&&
        currentDocument.data.containsKey('username') &&
        currentDocument.data.containsKey('age')); // check if it exists, if yes then check if username and age field are there or not. If not then profile incomplete else complete
  }

  @override
  Stream<List<Contact>> getContacts() {
    String uid = SharedObjects.prefs.get(Constants.sessionUid);
    CollectionReference userRef = fireStoreDb.collection(Paths.usersPath);
    DocumentReference ref = userRef.document(uid); //reference of the user's document node in database/users. This node is created using uid
    return ref.snapshots().transform(

        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(handleData: (documentSnapshot, sink) async{
          List<String> contacts;
          if (documentSnapshot.data['contacts'] == null) {
            ref.updateData({'contacts': []});
            contacts = List();
          } else {
            contacts = List.from(documentSnapshot.data['contacts']);
          }
          List<Contact> contactList = List();
          for (String username in contacts) {
            print(username);
            contactList.add(Contact(uid, username, username));
//            String uid = await getUidByUsername(username);
//            DocumentSnapshot contactSnapshot = await userRef.document(uid).get();
//            contactList.add(Contact.fromFirestore(contactSnapshot));
          }
          sink.add(contactList);
        })

    );
  }



  @override
  Future<void> addContact(String username) async {
    //Check user already exist
    await getUser(username);
    String uid = SharedObjects.prefs.get(Constants.sessionUid);
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(uid); //reference of the user's document node in database/users. This node is created using uid
    final DocumentSnapshot currentDocument = await ref.get();
    print(currentDocument.data);
    List<String> contacts = currentDocument.data['contacts'] != null
        ? List.from(currentDocument.data['contacts'])
        : List();
    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    }
    contacts.add(username);
    ref.updateData({'contacts': contacts});
  }

  @override
  Future<User> getUser(String username) async {
    String uid = await getUidByUsername(username);
    DocumentReference ref = fireStoreDb.collection(Paths.usersPath).document(uid);
    DocumentSnapshot documentSnapshot = await ref.get();
    print(documentSnapshot.exists);
    if (documentSnapshot != null && documentSnapshot.exists) {
      return User.fromFirestore(documentSnapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<String> getUidByUsername(String username) async {
    //get reference to the mapping using username
    DocumentReference ref = fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
    DocumentSnapshot documentSnapshot = await ref.get();
    print(documentSnapshot.exists);
    //check if uid mapping for supplied username exists
    if (documentSnapshot != null && documentSnapshot.exists && documentSnapshot.data['uid']!=null) {
      return documentSnapshot.data['uid'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }

}

abstract class  BaseUserDataProvider {
    Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
    Future<User> saveProfileDetails(String profileImageUrl, int age, String username);
    Future<bool> isProfileComplete();
    Stream<List<Contact>> getContacts() {}
    Future<void> addContact(String username) {}
    Future<User> getUser(String username) {}
    Future<String> getUidByUsername(String username);
}
