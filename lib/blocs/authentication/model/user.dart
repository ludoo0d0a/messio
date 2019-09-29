import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {

  String uid;
  String documentId;
  String name;
  String username;
  int age;
  String photoUrl;

  User({this.uid, this.documentId, this.name, this.username, this.age, this.photoUrl});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return User(
        uid: data['uid'],
        documentId: doc.documentID,
        name: data['name'],
        username: data['username'],
        age: data['age'],
        photoUrl: data['photoUrl']
    );
  }

}