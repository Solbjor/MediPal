import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medipal/model/chat_service.dart';

class Message {
  final String senderId;
  final String senderEmail;
  //final String receiverId;
  final String receiverEmail;
  final String message;
  //DateTime timestamp;

  Message({

    required this.senderId,
    required this.senderEmail,
    //required this.receiverId,
    required this.receiverEmail,
    //required this.timestamp,
    required this.message,

  });

  Map<String, dynamic> toMap(){

    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      //'timestamp': timestamp,
    };

  }

    factory Message.fromMap(Map<String, dynamic> map){
      //final timestamp = timestampToDateTime(map['timestamp']);
      return Message(
        senderId: map['senderId'],
        senderEmail: map['senderEmail'],
        //receiverId: map['receiverId'],
        receiverEmail: map['receiverEmail'],
        //timestamp: timestamp,
        message: map['message'],
      );
    }

  DateTime timestampToDateTime(Timestamp timestamp){
    return DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

    
}