

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vuna__gigs/admin/FeedbackListPage.dart';
import 'package:vuna__gigs/admin/joblist_view.dart';
import 'package:vuna__gigs/admin/userList.dart';
import 'package:vuna__gigs/screens/login_screen.dart';
import 'package:vuna__gigs/screens/methods.dart';
import 'package:http/http.dart' as http;
import 'package:vuna__gigs/view/DisplayJobs.dart';

import '../notification/notification_service.dart';

class AdminHomeScreen extends StatefulWidget {
  final String currentuserEmail;

  const AdminHomeScreen({Key? key, required this.currentuserEmail})
      : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthProvider _authProvider = AuthProvider();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

       int _selectedPageIndex = 0; // For tracking the selected page index

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      // print('FCM Message Received');
      LocalNotificationService.display(event);
    });
    initializeNotifications();
  }

  void initializeNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(String title, String body) async {
    List<String> allUserTokens =
        await getAllUserTokens(); // Implement this method to fetch all user tokens

    for (String token in allUserTokens) {
      SendNotification(title, body, token);
    }
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

  Future<List<String>> getAllUserTokens() async {
    List<String> userTokens = [];

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      snapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? token = data['token'] as String?;
          if (token != null && token.isNotEmpty) {
            userTokens.add(token);
          }
        }
      });
    } catch (e) {
      print("Error fetching user tokens: $e");
    }

    return userTokens;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _authProvider.logOut(context);
              print('LogOut Successful');
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
      ),
      body: _buildPage(_selectedPageIndex),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedPageIndex,
        height: 50,
        color: Color.fromARGB(255, 76, 175, 142),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.notifications, color: Colors.black),
          Icon(Icons.person, color: Colors.black),
          Icon(Icons.list, color: Colors.black),
          Icon(Icons.feedback, color: Colors.black),
        ],
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }

  // Helper method to build the page content based on the selected index
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return NotificationForm(onSendNotification: sendNotification);
      case 1:
        return UsersList(currentUserEmail: widget.currentuserEmail);
      case 2:
        return AllJobsPage();
      case 3:
        return FeedbackListPage(); // Replace with the actual widget for feedbacks
      default:
        return Container(); // Or any default widget you'd like to show
    }
  }
}

class NotificationForm extends StatefulWidget {
  final Function(String title, String body) onSendNotification;

  const NotificationForm({
    Key? key,
    required this.onSendNotification,
  }) : super(key: key);

  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    double formWidth;
    double formHeight;

    if (orientation == Orientation.portrait) {
      formWidth = mediaQuery.size.width * 0.8;
      formHeight = mediaQuery.size.height * 0.5;
    } else {
      formWidth = mediaQuery.size.width * 0.5;
      formHeight = mediaQuery.size.height * 0.8;
    }

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: formWidth,
          height: formHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Send Notification', // Heading added here
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20), // Increased space between fields and button
              ElevatedButton(
                onPressed: () {
                  final title = _titleController.text;
                  final body = _bodyController.text;
                  widget.onSendNotification(title, body);
                  _titleController.clear();
                  _bodyController.clear();
                },
                child: Text('Send'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 76, 175, 142),
                  textStyle: TextStyle(color: Colors.white),
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AuthProvider with ChangeNotifier {
  Future<void> logOut(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } catch (e) {
      print("Error occurred during logout: $e");
    }
  }
}
