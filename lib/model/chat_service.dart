import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/main.dart';
import 'package:medipal/model/message.dart';


class ChatService extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future<void> sendMessage(String receiverEmail, String message) async {

    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final DateTime dateTime = DateTime.now();
    //Timestamp timestamp = Timestamp.fromDate(dateTime);

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      //receiverId: receiverId,
      receiverEmail: receiverEmail,
      //timestamp: dateTime,
      message: message,
    );

    List<String> ids = [currentUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firebaseDatabase
        .ref()
        .child('chat_rooms')
        .child(chatRoomId)
        .child('messages')
        .push()
        .set(newMessage.toMap());
  }

  Stream<List<Message>> getMessages(String userId){

    List<String> ids = [userId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseDatabase
        .ref()
        .child('chat_rooms')
        .child(chatRoomId)
        .child('messages')
        //.orderByChild('timestamp')
        .onValue
        .map((event) => parseMessages(event.snapshot));
  }

  List<Message> parseMessages(DataSnapshot dataSnapshot){
    List<Message> messages = [];

    if (dataSnapshot.value != null){
      print(dataSnapshot.value.runtimeType);
      Map<dynamic, dynamic> messagesMap = dataSnapshot.value as Map<dynamic, dynamic>;
      messagesMap.forEach((key, value){
        Message message = Message.fromMap(value as Map<String, dynamic>);
        messages.add(message);
      });
    }

    return messages;

  }

Future<String?> getUserIdFromEmail(String email) async {
  DatabaseReference emailToUserIdRef = FirebaseDatabase.instance.ref().child('emailToUserIdMapping');

  try {
    DataSnapshot dataSnapshot = (await emailToUserIdRef.orderByValue().equalTo(email).once()) as DataSnapshot;
  
  
    if (dataSnapshot.value != null) {
      Map<dynamic, dynamic>? data = dataSnapshot.value as Map<dynamic, dynamic>?;
      if (data != null){
        String? userId;
        data.forEach((key, value){
          if (value == email){
            userId = key;
          }
        });
        return userId;
      }
    } else {
      return null;
    }
  } catch (error) {
    print("Error fetching data: $error");
    return null;
  }
}


}