import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medipal/model/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/main.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}


class _ChatListState extends State<ChatListPage> {

  late User? currentUser;
  List<String> users = [];
  
  void initState(){
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        ),
        body: StreamBuilder(
          // ignore: deprecated_member_use
          stream: FirebaseDatabase.instance.reference().child('users').onValue, 
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError){
              return const Text('Error');
            }

            if (snapshot.connectionState == ConnectionState.waiting){
              return const Text('Loading');
            }
            print("Snapshot data: ${snapshot.data}");
            DataSnapshot? dataSnapshot = snapshot.data!.snapshot;
            List<String> users = [];

            if (dataSnapshot != null && dataSnapshot.value != null){
              Map<dynamic, dynamic> usersMap = dataSnapshot.value as Map<dynamic, dynamic>;
              usersMap.forEach((key, value){
                if (value != null && value['email'] != null){
                  if (value['email'] != FirebaseAuth.instance.currentUser?.email){
                    users.add(value['email']);
                  }
                }
              });
              print("Users list: $users");
            }
            return _buildUserList(users);
          }
        ),
      )
    );
  }

  Widget _buildUserList(List<String> users){
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => _buildUserListItem(users[index], context),
      );
    }
  }

  Widget _buildUserListItem(String userEmail, BuildContext context){
    return ListTile(
      title: Text(userEmail),
      onTap: () async {
        final receiverEmail = userEmail; // Get the email from the tapped item
        await ChatService().sendMessage(receiverEmail, "Initial message");
        Navigator.pushNamed(
          context, 
          '/chat',
          arguments: {'receiverUserEmail': receiverEmail},
        );
      }
    );
  }
