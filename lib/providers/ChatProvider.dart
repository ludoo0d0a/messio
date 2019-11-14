
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/blocs/authentication/model/user.dart';
import 'package:messio/blocs/chats/model/Chat.dart';
import 'package:messio/blocs/chats/model/Message.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/utils/SharedObjects.dart';

class ChatProvider extends BaseChatProvider{
  final Firestore fireStoreDb;

  ChatProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Stream<List<Chat>> getChats() {
    String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    return fireStoreDb
        .collection(Paths.usersPath)
        .document(uId)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot, List<Chat>>.fromHandlers(
        handleData: (DocumentSnapshot documentSnapshot,
            EventSink<List<Chat>> sink) =>
            mapDocumentToChat(documentSnapshot, sink)));
  }

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference chatDocRef = fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection = chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
    await chatDocRef.updateData({'latestMessage': message.toMap()});
  }

  @override
  Stream<List<Message>> getMessages(String chatId,)  {
    DocumentReference chatDocRef = fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
    chatDocRef.collection(Paths.messagesPath);
    return messagesCollection
        .orderBy('timeStamp', descending: true)
        .limit(20)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
        handleData:
            (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
            mapDocumentToMessage(querySnapshot, sink)));

  }

  /*
  Here prevMessage contains the documentID of the last messages from the top on the chat screen.
   */
  @override
  Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage) async {
    DocumentReference chatDocRef =
    fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
    chatDocRef.collection(Paths.messagesPath);
    DocumentSnapshot prevDocument;
    prevDocument= await messagesCollection.document(prevMessage.documentId).get(); // gets a reference to the last message in the existing list
    final querySnapshot = await messagesCollection
        .startAfterDocument(prevDocument)  // Start reading documents after the specified document
        .orderBy('timeStamp', descending: true) // order them by timestamp
        .limit(20) // limit the read to 20 items
        .getDocuments();
    List<Message> messageList = List();
    querySnapshot.documents.forEach((doc)=>messageList.add(Message.fromFireStore(doc)));
    return messageList;
  }

  mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink<List<Message>> sink) {
    print(querySnapshot);
    List<Message> messages = List();
    for ( DocumentSnapshot document in querySnapshot.documents){
      print(document.data);
      messages.add(Message.fromFireStore(document));
    }
    sink.add(messages);
  }

  @override
  Future<String> getChatIdByUsername(String username) async {
    String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    String selfUsername =
    SharedObjects.prefs.getString(Constants.sessionUsername);
    DocumentReference userRef =
    fireStoreDb.collection(Paths.usersPath).document(uId);
    DocumentSnapshot documentSnapshot = await userRef.get();
    String chatId = documentSnapshot.data['chats'][username];
    if (chatId == null) {
      chatId = await createChatIdForUsers(selfUsername, username);
      userRef.updateData({
        'chats': {username: chatId}
      });
    }
    return chatId;
  }

  @override
  Future<void> createChatIdForContact(User user) async {
    String contactUid = user.documentId;
    String contactUsername = user.username;
    String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    String selfUsername = SharedObjects.prefs.getString(Constants.sessionUsername);
    CollectionReference usersCollection = fireStoreDb.collection(Paths.usersPath);
    DocumentReference userRef = usersCollection.document(uId);
    DocumentReference contactRef = usersCollection.document(contactUid);
    DocumentSnapshot userSnapshot = await userRef.get();
    if(userSnapshot.data['chats']==null|| userSnapshot.data['chats'][contactUsername]==null){
      String chatId = await createChatIdForUsers(selfUsername, contactUsername);
      await userRef.setData({
        'chats': {contactUsername: chatId}
      },merge:true );
      await contactRef.setData({
        'chats': {selfUsername: chatId}
      },merge: true);
    }
  }

  @override
  Future<String> createChatIdForUsers(String selfUsername, String contactUsername) async {
    CollectionReference collectionReference =
    fireStoreDb.collection(Paths.chatsPath);
    DocumentReference documentReference = await collectionReference.add({
      'members': [selfUsername, contactUsername]
    });
    return documentReference.documentID;
  }

  void mapDocumentToChat(
      DocumentSnapshot documentSnapshot, EventSink sink) async {
    List<Chat> chats = List();
    Map data = documentSnapshot.data['chats'];
    if(data!=null){
      data.forEach((key, value) => chats.add(Chat(key, value)));
      sink.add(chats);
    }
  }



}


abstract class BaseChatProvider{
  Stream<List<Message>> getMessages(String chatId);
  Stream<List<Chat>> getChats();
  Future<void> sendMessage(String chatId, Message message);

  Future<String> getChatIdByUsername(String username);
  Future<void> createChatIdForContact(User user);
  Future<String> createChatIdForUsers( String selfUsername, String contactUsername);
  Future<List<Message>> getPreviousMessages(String chatId, Message prevMessage);

}
