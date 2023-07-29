import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

import '../notification/notification_service.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<String> feedbackTypes = [
    'Technical issue',
    'Internet issue',
    'Bug',
    'Glitch',
    'Slow performance',
  ];
  List<String> selectedFeedbackTypes = [];

  TextEditingController _feedbackController = TextEditingController();
  NotificationsService notificationsService = NotificationsService();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      // print('FCM Message Received');
      LocalNotificationService.display(event);
    });
    notificationsService.initialiseNotifications();
  }

  void SendNotification(String title, String body, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'title': title,
      'body': body,
    };

    try {
      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAA6msbZ3E:APA91bHFliFq8amgNOiLnltmuo2AxFHnxfLoFk6uVeSf1LEH7jti-i7l-jtiuFZN61koUeAC94Wa_ckPSE5Ao8xFfK_fiDxtV4sArdob_scjxoVcqXnBTulJ_SH6tE48u0RJGiZyEV_p'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': '${title} : ${body}',
            'body': '',
          },
          'priority': 'high',
          'data': data,
          'to': token,
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully to $token");
      } else {
        print("Error sending notification to $token");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<String>> getAdminUserTokens() async {
    List<String> adminTokens = [];
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userType', isEqualTo: 'admin')
          .get();

      print('Number of admin documents found: ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isNotEmpty) {
        // Loop through the documents to get the tokens
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          String? token = doc.get('token');
          if (token != null) {
            adminTokens.add(token);
            print('Admin Token: $token');
          }
        }
      }
    } catch (e) {
      print('Error fetching admin user tokens: $e');
    }

    return adminTokens;
  }

  void FeedbackNotification(String title, String body) async {
    List<String> allUserTokens =
        await getAdminUserTokens(); // Implement this method to fetch all user tokens

    for (String token in allUserTokens) {
      SendNotification(title + " (Feedback)", body, token);
    }
  }

  Future<void> _submitFeedback() async {
    String feedbackText = _feedbackController.text;

    // Get the email of the current user
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (currentUserEmail != null) {
      // Store the feedback data in Firestore
      await FirebaseFirestore.instance.collection('feedback').add({
        'email': currentUserEmail,
        'feedbackText': feedbackText,
        'selectedFeedbackTypes': selectedFeedbackTypes,
        'timestamp': FieldValue
            .serverTimestamp(), // Add a timestamp for sorting purposes
      });

      FeedbackNotification("${_auth.currentUser?.displayName}", feedbackText);
      // For demonstration purposes, we are just printing the feedback and selected types here.
      print('Feedback submitted: $feedbackText');
      print('Selected Types: $selectedFeedbackTypes');

      // You can clear the text field and selected types after submission.
      _feedbackController.clear();
      setState(() => selectedFeedbackTypes.clear());

      // Show a SnackBar to thank the user for their feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your feedback!'),
          duration:
              Duration(seconds: 2), // You can adjust the duration as needed
        ),
      );

      //  Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
      // });
    }
  }

  Widget feedbackTypeChoiceChip(String label) {
    final bool isSelected = selectedFeedbackTypes.contains(label);
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      selected: isSelected,
      selectedColor:
          Color.fromARGB(255, 76, 175, 142), // Custom color for selected chips
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedFeedbackTypes.add(label);
          } else {
            selectedFeedbackTypes.remove(label);
          }
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey), // Border color of the chip
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This automatically handles navigation to the previous page
          },
        ),
        title: Text('Feedback Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please select the type of feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height: screenHeight *
                    0.02), // Adjust spacing based on screen height
            Wrap(
              spacing:
                  screenWidth * 0.04, // Adjust spacing based on screen width
              runSpacing:
                  screenHeight * 0.02, // Adjust spacing based on screen height
              children: feedbackTypes.map((type) {
                return feedbackTypeChoiceChip(type);
              }).toList(),
            ),
            SizedBox(
                height: screenHeight *
                    0.03), // Adjust spacing based on screen height
            Text(
              'Please provide your detailed feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height: screenHeight *
                    0.02), // Adjust spacing based on screen height
            Expanded(
              child: TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
                height: screenHeight *
                    0.02), // Adjust spacing based on screen height
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(
                    255, 76, 175, 142), // Custom color for the button
                // Custom text color for the button
              ),
              onPressed: _submitFeedback,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
