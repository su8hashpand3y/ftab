class MessageCard {
  String userName;
  String messageGroupUniqueGuid;
  int unreadCount;
  String lastMessage;
  bool isFav;
  int lastId;
  MessageCard(
      userName, messageGroupUniqueGuid, unreadCount, lastMessage, isFav,lastId) {
    this.userName = userName;
    this.messageGroupUniqueGuid = messageGroupUniqueGuid;
    this.unreadCount = unreadCount;
    this.lastMessage = lastMessage;
    this.isFav = isFav;
    this.lastId = lastId;
  }
}
