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

   MessageCard.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        userName = json['userName'];
        messageGroupUniqueGuid = json['messageGroupUniqueGuid'];
        unreadCount = json['unreadCount'];
        lastMessage = json['lastMessage'];
        isFav = json['isFav'];
        lastId = json['lastId'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'userName': userName,
        'messageGroupUniqueGuid': messageGroupUniqueGuid,
        'unreadCount': unreadCount,
        'lastMessage': lastMessage,
        'isFav': isFav,
        'lastId': lastId
    };

}
