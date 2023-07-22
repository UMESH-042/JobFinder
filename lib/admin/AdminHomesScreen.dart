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

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vuna__gigs/admin/joblist_view.dart';
// import 'package:vuna__gigs/admin/userList.dart';
// import 'package:vuna__gigs/screens/login_screen.dart';
// import 'package:vuna__gigs/screens/methods.dart';
// import 'package:http/http.dart' as http;
// import 'package:vuna__gigs/view/DisplayJobs.dart';

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

//   // void sendNotification(String title, String body) async {
//   //   AndroidNotificationDetails androidNotificationDetails =
//   //       AndroidNotificationDetails(
//   //     'channelId',
//   //     'channelName',
//   //     importance: Importance.max,
//   //     priority: Priority.high,
//   //   );

//   //   NotificationDetails notificationDetails = NotificationDetails(
//   //     android: androidNotificationDetails,
//   //   );

//   //   await _flutterLocalNotificationsPlugin.show(
//   //     0,
//   //     title,
//   //     body,
//   //     notificationDetails,
//   //   );
//   // }
//   void sendNotification(String title, String body) async {
//     // Retrieve all users from the database
//     List<String> allUserTokens =
//         await getAllUserTokens(); // Implement this method to fetch all user tokens

//     // Send notifications to each user
//     for (String token in allUserTokens) {
//       SendNotification(title, body, token);
//     }
//   }

//   void SendNotification(String title, String body, String token) async {
//     final data = {
//       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       'id': '1',
//       'status': 'done',
//       'title': title,
//       'body': body,
//     };

//     try {
//       http.Response response = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAA6msbZ3E:APA91bHFliFq8amgNOiLnltmuo2AxFHnxfLoFk6uVeSf1LEH7jti-i7l-jtiuFZN61koUeAC94Wa_ckPSE5Ao8xFfK_fiDxtV4sArdob_scjxoVcqXnBTulJ_SH6tE48u0RJGiZyEV_p'
//         },
//         body: jsonEncode(<String, dynamic>{
//           'notification': <String, dynamic>{
//             'title': '${title} : ${body}',
//             'body': '',
//           },
//           'priority': 'high',
//           'data': data,
//           'to': token,
//         }),
//       );

//       if (response.statusCode == 200) {
//         print("Notification sent successfully to $token");
//       } else {
//         print("Error sending notification to $token");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<List<String>> getAllUserTokens() async {
//     List<String> userTokens = [];

//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection('users').get();
//       snapshot.docs.forEach((doc) {
//         // Assuming the token field is named "token" in each user document
//         Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
//         if (data != null) {
//           String? token = data['token'] as String?;
//           if (token != null && token.isNotEmpty) {
//             userTokens.add(token);
//           }
//         }
//       });
//     } catch (e) {
//       print("Error fetching user tokens: $e");
//     }

//     return userTokens;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Admin Page',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _authProvider.logOut(context);
//               print('LogOut Successful');
//             },
//             icon: Icon(Icons.logout, color: Colors.white),
//           ),
//         ],
//         backgroundColor: Color.fromARGB(255, 76, 175, 142),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Notification Section
//             Text(
//                   'Send Notification',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 76, 175, 142),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//             Expanded(
//               child: NotificationForm(
//                 onSendNotification: sendNotification,
//               ),
//             ),
//             SizedBox(height: 20),
//             // Users and Jobs Section
            
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                     Text(
//                   'Users and Jobs',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 76, 175, 142),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => UsersList(
//                             currentUserEmail: widget.currentuserEmail,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text('Users List'),
//                     style: ElevatedButton.styleFrom(
//                       primary: Color.fromARGB(255, 76, 175, 142),
//                       textStyle: TextStyle(color: Colors.white),
//                       minimumSize: Size(double.infinity, 50),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => AllJobsPage()),
//                       );
//                     },
//                     child: Text('Jobs List'),
//                     style: ElevatedButton.styleFrom(
//                       primary: Color.fromARGB(255, 76, 175, 142),
//                       textStyle: TextStyle(color: Colors.white),
//                       minimumSize: Size(double.infinity, 50),
//                     ),
//                   ),
//                 ],
//               ),
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
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextField(
//           controller: _titleController,
//           decoration: InputDecoration(
//             labelText: 'Title',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: _bodyController,
//           decoration: InputDecoration(
//             labelText: 'Body',
//             border: OutlineInputBorder(),
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
//           style:  ElevatedButton.styleFrom(
//             backgroundColor: Color.fromARGB(255, 76, 175, 142),
//             textStyle: TextStyle(color: Colors.white),
//             minimumSize: Size(double.infinity, 50),
//           ),
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

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vuna__gigs/admin/joblist_view.dart';
import 'package:vuna__gigs/admin/userList.dart';
import 'package:vuna__gigs/screens/login_screen.dart';
import 'package:vuna__gigs/screens/methods.dart';
import 'package:http/http.dart' as http;
import 'package:vuna__gigs/view/DisplayJobs.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Notification Section
            Text(
              'Send Notification',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 76, 175, 142),
              ),
            ),
            SizedBox(height: 10),
            NotificationForm(
              onSendNotification: sendNotification,
            ),
            SizedBox(height: 70),
            // Users and Jobs Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Users and Jobs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 76, 175, 142),
                  ),
                ),
                SizedBox(height: 10),
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
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 76, 175, 142),
                    textStyle: TextStyle(color: Colors.white),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllJobsPage()),
                    );
                  },
                  child: Text('Jobs List'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 76, 175, 142),
                    textStyle: TextStyle(color: Colors.white),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
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
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 76, 175, 142),
            textStyle: TextStyle(color: Colors.white),
            minimumSize: Size(double.infinity, 50),
          ),
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
