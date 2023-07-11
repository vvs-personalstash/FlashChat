import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chats_io/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  static String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scrollController = ScrollController();
  final messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String message;
  late User loggedInUser;
  String LastMessageUser = 'abc';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    // messageStream();
  }

  // void getMessages() async {
  //   print(1);
  //   final messaages = await _firestore.collection('common-room').get();
  //   for (var message in messaages.docs) {
  //     print(message);
  //   }
  // }
  // void messageStream() async {
  //   print(1);
  //   await for (var snapshots
  //       in _firestore.collection('common-room').snapshots()) {
  //     for (var message in snapshots.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void scrollToBottom() {
    Timer _timer = Timer(Duration(seconds: 1), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30.0),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('common-room')
                    .orderBy('Time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  scrollToBottom();
                  final messages = snapshot.data?.docs;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages!) {
                    final chatMessage = message['text'];
                    final sender = message['sender'];
                    final time = message['Time'];
                    messageWidgets.add(MessageBubble(
                      text: chatMessage,
                      Sender: sender,
                      isLastSender: LastMessageUser == sender,
                      isMe: loggedInUser.email == sender,
                      time: time.toDate(),
                    ));

                    messageWidgets.sort((a, b) => a.time.compareTo(b.time));
                    LastMessageUser = message['sender'];
                  }
                  return Expanded(
                      child: ListView(
                    children: messageWidgets,
                    controller: scrollController,
                  ));
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      onChanged: (value) {
                        message = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOut,
                      );
                      messageController.clear();
                      _firestore.collection('common-room').add({
                        'text': message,
                        'sender': loggedInUser.email,
                        'Time': DateTime.now()
                      });
                      LastMessageUser = 'abc';
                      //Implement send functionality.
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

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.text,
      required this.Sender,
      required this.isLastSender,
      required this.isMe,
      required this.time});
  String text;
  String Sender;
  bool isMe;
  bool isLastSender;
  DateTime time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          !isLastSender
              ? Text(
                  Sender,
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                )
              : Container(),
          Material(
            borderRadius: isLastSender
                ? isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0))
                    : BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))
                : isMe
                    ? BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0))
                    : BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0)),
            color: isMe ? Colors.blueAccent : Colors.black.withOpacity(0.7),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
            width: 60.0,
            child: Container(
              alignment: AlignmentDirectional.bottomEnd,
              child: Text(
                '${time.hour}:${time.minute}',
                style: TextStyle(color: Colors.black45, fontSize: 5.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
