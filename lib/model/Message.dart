import 'dart:core';

import 'package:intl/intl.dart';

class Message {
  static const COLLECTION_NAME = 'messages';
  String id;
  String content;
  String senderName;
  String senderId;
  int time;

  Message({
    required this.id,
    required this.content,
    required this.senderName,
    required this.senderId,
    required this.time,
  });

  Message.fromJson(Map <String,Object?> json): this(
    id : json['id']! as String,
    content : json['content']! as String,
    senderName : json['senderName']! as String,
    senderId : json['senderId']! as String,
    time : json['time']! as int,
  );
  Map<String,Object> toJson(){
    return{
      'id' : id,
      'content' : content,
      'senderName' :senderName,
      'senderId' : senderId,
      'time' : time
    };
  }
  String getDateFormatted(){
    var date = DateFormat("HH:mm a");
    return date.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
