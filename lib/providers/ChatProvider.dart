
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/blocs/chats/model/Chat.dart';
import 'package:messio/blocs/chats/model/Message.dart';
import 'package:messio/config/Paths.dart';

class ChatProvider extends BaseChatProvider{
  final Firestore fireStoreDb;

  ChatProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Stream<List<Chat>> getChats() {
    // TODO: implement getChats
    return null;
  }

  @override
  Future<void> sendMessage(String chatId, Message message) {
    DocumentReference chatDocRef = fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection = chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    DocumentReference chatDocRef = fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection = chatDocRef.collection(Paths.messagesPath);

    return messagesCollection.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
            handleData: (QuerySnapshot querySnapshot,EventSink<List<Message>> sink) =>
                mapDocumentToMessage(querySnapshot,sink)
        )
    );
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


}


abstract class BaseChatProvider{
  Stream<List<Message>> getMessages(String chatId);
  Stream<List<Chat>> getChats();
  Future<void> sendMessage(String chatId, Message message);
}
