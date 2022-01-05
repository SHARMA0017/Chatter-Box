// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, await_only_futures, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  late String messageText;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /* void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }*/

  /*void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout),
            onPressed: () {
              // getMessages();
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      var timestamp = DateTime.now().millisecondsSinceEpoch;

                      messageTextController.clear();
                      _firestore.collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'timestamp': timestamp
                        },
                      );
                      setState(() {});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection("messages").orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data!.docs;
          List<MessageBubble> bubble = [];
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messagetime = message.get('timestamp');
            final currentUser = loggedInUser.email;

            final bubbleMessage = MessageBubble(
              text: messageText,
              sender: messageSender,
              time: messagetime,
              isMe: currentUser == messageSender,
            );
            bubble.add(bubbleMessage);
          }
          return Expanded(
            child: ListView(
              children: bubble,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final int time;
  MessageBubble({
    required this.text,
    required this.sender,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.black45),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(30) : Radius.circular(0),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topRight: isMe ? Radius.circular(0) : Radius.circular(30),
              ),
              color: isMe ? Colors.lightBlueAccent : Colors.white38,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black54),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              DateFormat('hh:mm a').format(
                DateTime.fromMillisecondsSinceEpoch(time),
              ),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
