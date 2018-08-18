class Message {
  int id;
  DateTime dateTime;
  bool isMyMessage;
  String message;
  int lastId;
  Message(id,dateTime, isMyMessage, message,lastId) {
    this.id = id;
    this.dateTime = DateTime.parse(dateTime);
    this.isMyMessage = isMyMessage;
    this.message = message;
    this.lastId = lastId;
  }
}
