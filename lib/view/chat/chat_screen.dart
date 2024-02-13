import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googly_sign_in/features/services/chat_service.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String receiverId;

  ChatScreen({
    super.key,
    required this.receiverId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ChatSevice _chatSevice = ChatSevice();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Someone'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey[200],
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatSevice.getMessages(
                      _auth.currentUser!.uid, widget.receiverId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      // reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        print(message);
                        return Container(
                          padding: const EdgeInsets.all(10),
                          alignment:
                              message['senderId'] == _auth.currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment:
                                message['senderId'] == _auth.currentUser!.uid
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            mainAxisAlignment:
                                message['senderId'] == _auth.currentUser!.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Text(
                                message['senderId'] == _auth.currentUser!.uid
                                    ? 'You'
                                    : 'Someone',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: message['senderId'] ==
                                          _auth.currentUser!.uid
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                ),
                                child: Text(
                                  message['message'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              // Text(
                              //   message['timestamp']?.toDate().toString() ??
                              //       '${DateTime.now()}',
                              //   style: const TextStyle(
                              //       fontSize: 14, fontWeight: FontWeight.w400),
                              // ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _sendMessage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      try {
        _chatSevice.sendMesage(widget.receiverId, _textEditingController.text);
        _textEditingController.clear();
        FocusScope.of(context).unfocus();
      } catch (e) {
        print('Error sending message: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to send message. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
