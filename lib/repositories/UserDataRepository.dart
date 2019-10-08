import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/blocs/authentication/model/user.dart';
import 'package:messio/blocs/contacts/model/contact.dart';
import 'package:messio/providers/UserDataProvider.dart';

class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(
          String profileImageUrl, int age, String username) =>
      userDataProvider.saveProfileDetails(profileImageUrl, age, username);

  Future<bool> isProfileComplete() =>
      userDataProvider.isProfileComplete();


  Stream<List<Contact>> getContacts() =>
      userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<User> getUser(String username) => userDataProvider.getUser(username);
}
