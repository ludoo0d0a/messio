class Chat {
  String chatId;
  String username;

  Chat(this.username,this.chatId);

  @override
  String toString() => '{ username= $username, chatId = $chatId}';

}