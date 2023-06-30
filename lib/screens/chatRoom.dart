import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vuna__gigs/view/ChatScreen.dart';
// import 'package:flutter_svg/svg.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatRoomId;
  final String currentUserEmail;
  final String otherUserEmail;
  final Map<String, dynamic> userMap;

  const ChatRoomScreen({
    required this.chatRoomId,
    required this.currentUserEmail,
    required this.otherUserEmail,
    required this.userMap,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<DocumentSnapshot>? _chatroomSubscription;
  String? repliedMessage;

  final FocusNode _messageFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _chatroomSubscription?.cancel();
    super.dispose();
  }

  void onSendMessage(String message, [String? imageUrl]) async {
    if (message.isNotEmpty || imageUrl != null) {
      try {
        Map<String, dynamic> messageData = {
          'sendBy': _auth.currentUser?.displayName,
          'message': message,
          'imageUrl': imageUrl,
          'time': FieldValue.serverTimestamp(),
          'repliedMessage': repliedMessage,
        };

        await _firestore
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .add(messageData);

        _messageController.clear();
        setState(() {
          repliedMessage = null;
        });
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print('Enter some Text');
    }
  }

  void replyToMessage(String message) {
    setState(() {
      repliedMessage = message;
      // _messageController.text = ''; // Clear the message field
    });
    _messageController.text = '';
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  void cancelReply() {
    setState(() {
      repliedMessage = null;
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
  toolbarHeight: 70,
  automaticallyImplyLeading: false,
  // backgroundColor: Color.fromARGB(255, 235, 237, 240),
  backgroundColor: Colors.transparent,
  elevation: 0,
  
  leading: IconButton(
    icon: Icon(
      Icons.arrow_back_ios,
      color: Colors.black,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(currentUserEmail: widget.currentUserEmail),
        ),
      );
    },
  ),
  title: StreamBuilder<DocumentSnapshot>(
    stream: _firestore.collection("users").doc(widget.userMap['uid']).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final userSnapshot = snapshot.data!;
        final status = userSnapshot['status'];
        final imageUrl = widget.userMap['imageUrl'];

        return Container(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userMap['name'],
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    status,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    },
  ),
  actions: [
    IconButton(onPressed: (){}, icon: Icon(Icons.phone),color: Colors.black,)
  ],
  
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            messages[index].data() as Map<String, dynamic>;
                        final isCurrentUser =
                            message['sendBy'] == _auth.currentUser?.displayName;
                        final timestamp =
                            (message['time'] as Timestamp?)?.toDate() ??
                                DateTime.now();

                        return Dismissible(
                          key: UniqueKey(),
                          direction: isCurrentUser
                              ? DismissDirection.endToStart
                              : DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 16),
                            child: Icon(
                              isCurrentUser
                                  ? Icons.delete_forever
                                  : Icons.reply,
                              color: Colors.white,
                            ),
                          ),
                          secondaryBackground: Container(
                            color: isCurrentUser
                                ? Colors.red
                                : Colors.blue.withOpacity(0.5),
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              isCurrentUser
                                  ? Icons.delete_forever
                                  : Icons.reply,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              // Delete message
                              _firestore
                                  .collection('chatroom')
                                  .doc(widget.chatRoomId)
                                  .collection('chats')
                                  .doc(messages[index].id)
                                  .delete();
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              // Reply to message
                              replyToMessage(message['message']);
                            }
                          },
                          child: MessageBubble(
                            message: message['message'],
                            isCurrentUser: isCurrentUser,
                            timestamp: timestamp,
                            onReply: () {
                              replyToMessage(message['message']);
                            },
                            repliedMessage: message['repliedMessage'],
                            currentUserName: _auth.currentUser?.displayName,
                            otherUserName: isCurrentUser
                                ? widget.userMap['name']
                                : null, // Pass the other user's name if it's not the current user
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (repliedMessage != null) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 4,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.userMap['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: cancelReply,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 4,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              child: Text(
                                repliedMessage!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                          Row(
                            children: [
                              // IconButton(
                              //   onPressed: () {},
                              //   // icon: SvgPicture.asset(
                              //   //   'assets/emoji.svg',
                              //   //   height: 24,
                              //   //   width: 24,
                              //   // ),
                              // ),
                              Expanded(
                              
                                child: TextField(
                                  scrollPadding: EdgeInsets.all(5),
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Message...',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),

                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.attach_file),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.camera_alt_sharp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      onSendMessage(_messageController.text);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
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
  final String message;
  final bool isCurrentUser;
  final DateTime timestamp;
  final Function()? onReply;
  final String? repliedMessage;
  final String? otherUserName; // Added otherUserName property
  final String? currentUserName;

  const MessageBubble(
      {required this.message,
      required this.isCurrentUser,
      required this.timestamp,
      this.onReply,
      this.repliedMessage,
      this.otherUserName, // Added otherUserName parameter
      required this.currentUserName});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (repliedMessage != null) ...[
              GestureDetector(
                onTap: () {
                  // Scroll to the replied message
                  Scrollable.ensureVisible(
                    context,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    alignment: 0.5,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherUserName != null
                            ? otherUserName!
                            : currentUserName!, // Updated condition
                        style: TextStyle(
                          fontSize: 12,
                          // color: Colors.green,
                          color: otherUserName != null
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        repliedMessage!,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
            Text(
              message,
              style: TextStyle(
                  fontSize: 16,
                  color: isCurrentUser ? Colors.white : Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              '${timestamp.hour}:${timestamp.minute}',
              style: TextStyle(
                  fontSize: 12,
                  color: isCurrentUser ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
