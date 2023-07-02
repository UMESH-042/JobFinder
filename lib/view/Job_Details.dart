import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobDetailsPage extends StatelessWidget {
  final String location;
  final String salary;
  final String category;
  final String? image;
  final String jobtype;
  final String description;
  final String requirements;
  final String postedby;

  const JobDetailsPage({
    required this.location,
    required this.salary,
    required this.category,
    required this.jobtype,
    this.image,
    required this.description,
    required this.requirements,
    required this.postedby,
  });

  // Widget button(BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       // Handle adding the job
  //     },
  //     child: Container(
  //       margin: EdgeInsets.all(20),
  //       width: MediaQuery.of(context).size.width,
  //       height: 55,
  //       decoration: BoxDecoration(
  //         color: Color.fromARGB(255, 76, 175, 142),
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       child: Center(
  //         child: Text(
  //           "Apply for Job",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 17,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // String ChatRoomId(String user1, String user2) {
  //   if (user1[0].toLowerCase().codeUnits[0] >
  //       user2.toLowerCase().codeUnits[0]) {
  //     return "$user1$user2";
  //   } else {
  //     return "$user2$user1";
  //   }
  // }

  // Future<void> sendMessageToPostedByUser(String currentUserEmail) async {
  //   try {
  //     final FirebaseAuth _auth = FirebaseAuth.instance;
  //     final CollectionReference chatroomCollection =
  //         FirebaseFirestore.instance.collection('chatroom');

  //     // Create a chat room with a unique ID
  //     // final chatRoomId = _auth.currentUser!.uid + postedby;
  //     final chatRoomId = ChatRoomId(currentUserEmail, postedby);

  //     // Check if the chat room already exists
  //     final chatRoomSnapshot = await chatroomCollection.doc(chatRoomId).get();
  //     if (!chatRoomSnapshot.exists) {
  //       // Create the chat room document
  //       final Map<String, dynamic> chatRoomData = {
  //         'users': [postedby, currentUserEmail],
  //         'createdAt': FieldValue.serverTimestamp(),
  //       };
  //       await chatroomCollection.doc(chatRoomId).set(chatRoomData);
  //     }

  //     // Get the chat room reference
  //     final DocumentReference chatRoomRef = chatroomCollection.doc(chatRoomId);

  //     // Create the message data
  //     final Map<String, dynamic> messageData = {
  //       'sendBy': _auth.currentUser?.displayName,
  //       'message': 'I am interested in the job.',
  //       'time': FieldValue.serverTimestamp(),
  //     };

  //     // Add the message to the chat room
  //     await chatRoomRef.collection('chats').add(messageData);

  //     // Success
  //     print('Message sent successfully!');
  //   } catch (e) {
  //     // Error handling
  //     print('Error sending message: $e');
  //   }
  // }
  String ChatRoomId(String user1, String user2) {
  if (user1[0].toLowerCase().codeUnits[0] >
      user2.toLowerCase().codeUnits[0]) {
    return "$user1$user2";
  } else {
    return "$user2$user1";
  }
}

Future<void> sendMessageToPostedByUser(String currentUserEmail) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference chatroomCollection =
        FirebaseFirestore.instance.collection('chatroom');

    // Create a chat room with a unique ID
    final chatRoomId = ChatRoomId(currentUserEmail, postedby);

    // Check if the chat room already exists
    final chatRoomSnapshot = await chatroomCollection.doc(chatRoomId).get();
    if (!chatRoomSnapshot.exists) {
      // Create the chat room document
      final Map<String, dynamic> chatRoomData = {
        'users': [postedby, currentUserEmail],
        'createdAt': FieldValue.serverTimestamp(),
      };
      await chatroomCollection.doc(chatRoomId).set(chatRoomData);
    }

    // Get the chat room reference
    final DocumentReference chatRoomRef = chatroomCollection.doc(chatRoomId);

    // Create the message data
    final Map<String, dynamic> messageData = {
      'sendBy': _auth.currentUser?.displayName,
      'message': 'I am interested in the job.',
      'time': FieldValue.serverTimestamp(),
    };

    // Add the message to the chat room
    await chatRoomRef.collection('chats').add(messageData);

    // Success
    print('Message sent successfully!');
  } catch (e) {
    // Error handling
    print('Error sending message: $e');
  }
}


  Widget button(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle adding the job
        String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
        sendMessageToPostedByUser(currentUserEmail);
      },
      child: Container(
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: 55,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 76, 175, 142),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Apply for Job",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Job Details'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.black, // Background color for the image container
              child: image != null
                  ? Image.network(
                      image!,
                      fit: BoxFit.cover,
                      // width: double.infinity,
                      width: 200,
                      height: 200,
                    )
                  : null,
            ),
            Container(
              color: Colors.white, // Background color for the details container
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    jobtype,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    requirements,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Posted By',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    postedby,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$$salary/m',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  button(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
