class Message{
    DateTime dateTime;
    bool isMyMessage;
    String message;
    Message(dateTime, isMyMessage, message){
      this.dateTime = DateTime.parse(dateTime);
      this.isMyMessage = isMyMessage;
      this.message = message;
    }
}