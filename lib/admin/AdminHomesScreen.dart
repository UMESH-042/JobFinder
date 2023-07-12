
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vuna__gigs/admin/userList.dart';
// import 'package:vuna__gigs/screens/login_screen.dart';
// import 'package:vuna__gigs/screens/methods.dart';

// class AdminHomeScreen extends StatefulWidget {
//   final String currentuserEmail;

//   const AdminHomeScreen({Key? key, required this.currentuserEmail})
//       : super(key: key);

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   final AuthProvider _authProvider = AuthProvider();
//   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     initializeNotifications();
//   }

//   void initializeNotifications() {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   void sendNotification(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'channelId',
//       'channelName',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Admin Page'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _authProvider.logOut(context);
//               print('LogOut Successful');
//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => UsersList(
//                       currentUserEmail: widget.currentuserEmail,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Users List'),
//             ),
//             SizedBox(height: 20),
//             NotificationForm(
//               onSendNotification: sendNotification,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NotificationForm extends StatefulWidget {
//   final Function(String title, String body) onSendNotification;

//   const NotificationForm({
//     Key? key,
//     required this.onSendNotification,
//   }) : super(key: key);

//   @override
//   _NotificationFormState createState() => _NotificationFormState();
// }

// class _NotificationFormState extends State<NotificationForm> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _bodyController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           'Send Notification',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: TextField(
//             controller: _titleController,
//             decoration: InputDecoration(
//               labelText: 'Title',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: TextField(
//             controller: _bodyController,
//             decoration: InputDecoration(
//               labelText: 'Body',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             final title = _titleController.text;
//             final body = _bodyController.text;
//             widget.onSendNotification(title, body);
//             _titleController.clear();
//             _bodyController.clear();
//           },
//           child: Text('Send'),
//         ),
//       ],
//     );
//   }
// }

// class AuthProvider with ChangeNotifier {
//   Future<void> logOut(BuildContext context) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;

//     try {
//       await _auth.signOut();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//       );
//     } catch (e) {
//       print("Error occurred during logout: $e");
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vuna__gigs/admin/userList.dart';
import 'package:vuna__gigs/screens/login_screen.dart';
import 'package:vuna__gigs/screens/methods.dart';

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

  @override
  void initState() {
    super.initState();
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
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Admin Page'),
        actions: [
          IconButton(
            onPressed: () {
              _authProvider.logOut(context);
              print('LogOut Successful');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UsersList(
                      currentUserEmail: widget.currentuserEmail,
                    ),
                  ),
                );
              },
              child: Text('Users List'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(20),
              child: NotificationForm(
                onSendNotification: sendNotification,
              ),
            ),
          ],
        ),
      ),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Send Notification',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
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
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text;
            final body = _bodyController.text;
            widget.onSendNotification(title, body);
            _titleController.clear();
            _bodyController.clear();
          },
          child: Text('Send'),
        ),
      ],
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
