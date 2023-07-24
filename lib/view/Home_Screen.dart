import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:vuna__gigs/view/MyApplications.dart';
import 'package:vuna__gigs/view/add_jobs.dart';
import 'package:vuna__gigs/view/Edit_profile_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../screens/login_screen.dart';
import 'ChatScreen.dart';
import 'DisplayJobs.dart';
import 'Profile_Screen.dart';
import 'ApplicantsList.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String currentUserEmail;
  final bool requiresProfileSetup;

  const HomePage({
    Key? key,
    required this.currentUserEmail,
    required this.requiresProfileSetup,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool isLoading = true;
  String? _imageUrl;

  List<Widget> _screens = [];

  Future<void> storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  StreamSubscription<RemoteMessage>? _firebaseMessagingStream;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(event);
    // });
    _firebaseMessagingStream = FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    storeNotificationToken();

    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    if (currentUID != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUID);
      userDocRef.get().then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            _imageUrl = snapshot.data()?['imageUrl'];
          });
        }
      });
    }

    _screens = [
      JobListPage(),
      ChatScreen(currentUserEmail: widget.currentUserEmail),
      ProfileScreen(useremail: currentUID!),
      ApplicantsListScreen(
        postedByEmail: widget.currentUserEmail,
      ),
    ];

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

  @override
  void dispose() {
    // ... Your other code ...

    _firebaseMessagingStream?.cancel();
    super.dispose();
  }

  Future<void> _requestNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print('Notification allowed');
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
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
            'title': title,
            'body': 'You are followed by someone'
          },
          'priority': 'high',
          'data': data,
          'to': '$token'
        }),
      );

      if (response.statusCode == 200) {
        print("Yeh notification is sent");
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
                      backgroundImage: _imageUrl != null
                          ? CachedNetworkImageProvider(_imageUrl!)
                          : null,
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
                            backgroundImage: _imageUrl != null
                                ? CachedNetworkImageProvider(_imageUrl!)
                                : null,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.currentUserEmail,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfilePage()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 255, 156, 7),
                        child: Icon(
                          Icons.access_time_filled,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('My Applications'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyApplicationPage(
                                      currentUserEmail: widget.currentUserEmail,
                                    )));
                      },
                    ),
                    SizedBox(height: 10),
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
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10),
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
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10),
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
              Icon(Icons.portrait_outlined),
              Icon(Icons.people_outlined),
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
  Future<void> logOut(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      });
    } catch (e) {
      print("error");
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
