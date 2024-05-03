import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medipal/constant/images.dart';
import 'package:medipal/main.dart';
import 'package:medipal/model/chat_bubble.dart';
import 'package:medipal/pages/chat_list.dart';
import 'package:medipal/model/message.dart';
import 'package:medipal/model/chat_service.dart';


class ChatScreen extends StatefulWidget {

final String receiverUserEmail;

  const ChatScreen({
    super.key,
    required this.receiverUserEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService= ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async{
    if (_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserEmail, _messageController.text);
      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    
  }


  @override
  Widget build(BuildContext context){
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String receiverUserEmail = args['receiverUserEmail'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.receiverUserEmail}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ]
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessageList(){
    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessages(widget.receiverUserEmail), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });

        return ListView(
          children: snapshot.data!
              .map((message) => _buildMessageItem(message))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(Message message){
    var alignment = (message.senderId == _firebaseAuth.currentUser!.uid) ? 
    Alignment.centerRight 
    : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (message.senderId == _firebaseAuth.currentUser!.uid) 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
          children: [
            Text(message.senderEmail),
            const SizedBox(height: 5),
            ChatBubble(message: message.message,),
          ],
        ),
      ),
    );
  }

  //build input
  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
          )
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward, 
            size: 40,
          )
        )
      ]
    );
  }


}
