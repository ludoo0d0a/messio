import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/blocs/chats/model/Chat.dart';
import 'package:messio/blocs/chats/model/Message.dart';
import 'package:messio/providers/AuthenticationProvider.dart';
import 'package:messio/providers/ChatProvider.dart';

class ChatRepository {
  BaseAuthenticationProvider authenticationProvider = AuthenticationProvider();
  ChatProvider chatProvider = ChatProvider();

  Future<FirebaseUser> signInWithGoogle() =>
      authenticationProvider.signInWithGoogle();

  Future<void> signOutUser() => authenticationProvider.signOutUser();

  Future<FirebaseUser> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();

  Stream<List<Chat>> getChats() => chatProvider.getChats();

  Stream<List<Message>> getMessages(String chatId) => chatProvider.getMessages(chatId);

  Future<void> sendMessage(String chatId, Message message) => chatProvider.sendMessage(chatId, message);

  Future<String> getChatIdByUsername(String username) => chatProvider.getChatIdByUsername(username);

  Future<void> createChatIdForContact(user) => chatProvider.createChatIdForContact(user);

  getPreviousMessages(String chatId, Message lastMessage) => chatProvider.getPreviousMessages(chatId, lastMessage);
}
