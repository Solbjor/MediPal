import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medipal/chat/chat_service.dart';
import 'package:medipal/objects/message.dart';
import 'package:medipal/objects/practitioner.dart'; // Import Practitioner object

class ChatPage extends StatefulWidget {
  final String receiverUid;
  const ChatPage({
    super.key,
    required this.receiverUid,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  Practitioner? _currentPractitioner;
  Practitioner? _receiverPractitioner;

  // Get practitioner
  Future<Practitioner?> getPractitioner(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    DataSnapshot snapshot = await ref.child(uid).get();
    if (!snapshot.exists) return null;
    Map<String, dynamic>? value = snapshot.value as Map<String, dynamic>;

    if (value != null) {
      return Practitioner.fromMap(value);
    } else {
      return null;
    }
  }

  // Get the current user's name
  Future<String> _getCurrentUserName() async {
    Practitioner? currentPractitioner = await getPractitioner(_firebaseAuth.currentUser!.uid);
    return currentPractitioner?.name ?? 'Anonymous';
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    _currentPractitioner = await getPractitioner(_firebaseAuth.currentUser!.uid) as Practitioner?;
    _receiverPractitioner = await getPractitioner(widget.receiverUid) as Practitioner?;
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
        widget.receiverUid,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
            future: Future<String>.value(_receiverPractitioner!.name),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(' - ${snapshot.data!}');
            } else {
              return const Text('Loading...');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),
          // User input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessages(
        widget.receiverUid,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Message> messages = snapshot.data ?? [];

        return ListView.builder(
          itemCount: messages.length,
            itemBuilder: (context, index) {
              if (messages[index] == null) {
                return const Text('No messages yet');
              }
              return FutureBuilder<Widget>(
                future: _buildMessageItem(messages[index]),
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        );
      },
    );
  }

  // build message item
  Future<Widget> _buildMessageItem(Message message) async {
    String senderName = _currentPractitioner?.name ?? 'Unknown';
    String receiverName = _receiverPractitioner?.name ?? 'Unknown';

  var alignment = (message.senderUid == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;
  return Container(
    alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (message.senderUid == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Text(senderName),
            Text(message.content),
          ],
        ),
      ),
    );
  }


  // build input
  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Color(0xFFDADFEC),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.send,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
