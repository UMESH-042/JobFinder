import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vuna__gigs/notification/notification_service.dart';
import 'package:vuna__gigs/view/add_jobs.dart';
import 'package:vuna__gigs/view/Edit_profile_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/login_screen.dart';
import 'ChatScreen.dart';
import 'DisplayJobs.dart';
import 'Profile_Screen.dart';
import 'Settings_Screen.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String currentUserEmail;
  final bool requiresProfileSetup;

  const HomePage(
      {Key? key,
      required this.currentUserEmail,
      required this.requiresProfileSetup})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool isLoading = true;

  late List<Widget> _screens;

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'token': token,
    }, SetOptions(merge: true));
  }

  @override
  late String _imageUrl = '';

  String? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      return uid;
    } else {
      // User is not signed in
      return null;
    }
  }

  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      // print('FCM Message Received');
      LocalNotificationService.display(event);
    });

    storeNotificationToken();
    String? currentUID = getCurrentUser();
    _screens = [
      JobListPage(),
      ChatScreen(
        currentUserEmail: widget.currentUserEmail,
      ),
      ProfileScreen(useremail: currentUID!,),
      SettingsScreen(),
    ];
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUID);
    userDocRef.get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _imageUrl = snapshot.data()?['imageUrl'] ?? '';
        });
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });

    if (widget.requiresProfileSetup) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: "Please set up your profile first.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }

    _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permissions granted
      // You can handle further notification setup here
      print('Notification allowed');
    } else if (status.isDenied) {
      // Notification permissions denied
      // You can display a message or perform any required action
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied
      // You can display a message or perform any required action
      // You can navigate the user to the app settings to manually enable notification permissions
      openAppSettings();
    }
  }

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAA6msbZ3E:APA91bHFliFq8amgNOiLnltmuo2AxFHnxfLoFk6uVeSf1LEH7jti-i7l-jtiuFZN61koUeAC94Wa_ckPSE5Ao8xFfK_fiDxtV4sArdob_scjxoVcqXnBTulJ_SH6tE48u0RJGiZyEV_p'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'You are followed by someone'
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 250, 251),
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.only(left: 17),
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Container(
                          color: Color.fromARGB(255, 76, 175, 142),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  );
                },
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 17),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 76, 175, 142),
                      backgroundImage: NetworkImage(_imageUrl),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            )
          : null,
      drawer: _currentIndex == 0
          ? Drawer(
              child: Container(
                alignment: Alignment.center,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 76, 175, 142),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(_imageUrl),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.currentUserEmail,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 115, 0),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('Edit Profile'),
                      onTap: () {
                        // Handle the tap on Edit Profile
                        // Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProfilePage()));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 156, 7),
                        child: Icon(
                          Icons.access_time_filled,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('Applications'),
                      onTap: () {
                        // Handle the tap on Applications
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 76, 175, 140),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('Notification Settings'),
                      onTap: () {
                        // Handle the tap on Notification Settings
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink[300],
                        child: Icon(
                          Icons.share_location_outlined,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('Share App'),
                      onTap: () {
                        // Handle the tap on Share App
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.arrow_circle_left,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.pop(context);
                        authProvider.logOut(context);
                        print('logout successful');
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: isLoading
          ? ShimmerEffect()
          : Column(
              children: [
                if (_currentIndex == 0)
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 76, 175, 142),
                          ),
                          margin: EdgeInsets.only(right: 4, left: 5),
                          height: 50, // Adjust the height as needed
                          child: IconButton(
                            icon: Icon(Icons.filter_list),
                            color: Colors.white,
                            onPressed: () {
                              // Handle filter button press
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: _screens[_currentIndex],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          child: CurvedNavigationBar(
            backgroundColor: Color.fromARGB(255, 76, 175, 142),
            color: Colors.white,
            buttonBackgroundColor: Color.fromARGB(255, 76, 175, 142),
            height: 65,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            index: _currentIndex,
            items: [
              Icon(Icons.home),
              Icon(Icons.chat_outlined),
              Icon(Icons.person),
              Icon(Icons.settings),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 76, 175, 142),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddJobs(
                      otherUserEmail: widget.currentUserEmail,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}

class AuthProvider with ChangeNotifier {
  Future logOut(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut().then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      });
    } catch (e) {
      print("error");
      return null;
    }
  }
}

class ShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Placeholder content
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.8,
                height: 40,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                width: screenWidth * 0.6,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.9,
                height: 150,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.7,
                height: 30,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                width: screenWidth * 0.5,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.8,
                height: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.7,
                height: 30,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Container(
                width: screenWidth * 0.4,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth * 0.9,
                height: 120,
                color: Colors.white,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
