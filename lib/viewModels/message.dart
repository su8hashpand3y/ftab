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

   Message.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        dateTime = DateTime.parse(json['dateTime']);
        isMyMessage = json['isMyMessage'];
        message = json['message'];
        lastId = json['lastId'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id,
        'dateTime': dateTime.toString(),
        'isMyMessage': isMyMessage,
        'message': message,
        'lastId': lastId,
    };
}
