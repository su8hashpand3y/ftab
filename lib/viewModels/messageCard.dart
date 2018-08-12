class MessageCard{
    String userName;
    String messageGroupUniqueGuid;
    int unreadCount;
    String lastMessage;
    bool isFav;
    MessageCard(userName, messageGroupUniqueGuid, unreadCount,lastMessage,isFav){
      this.userName = userName;
      this.messageGroupUniqueGuid = messageGroupUniqueGuid;
      this.unreadCount = unreadCount;
      this.lastMessage = lastMessage;
      this.isFav = isFav;
    }
}