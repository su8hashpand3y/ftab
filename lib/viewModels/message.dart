class Message {
  DateTime dateTime;
  bool isMyMessage;
  String message;
  int lastId;
  Message(dateTime, isMyMessage, message,lastId) {
    this.dateTime = DateTime.parse(dateTime);
    this.isMyMessage = isMyMessage;
    this.message = message;
    this.lastId = lastId;
  }
}
