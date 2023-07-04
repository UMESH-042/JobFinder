import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vuna__gigs/view/add_jobs.dart';
import 'package:vuna__gigs/view/Edit_profile_page.dart';

import '../screens/login_screen.dart';
import 'ChatScreen.dart';
import 'DisplayJobs.dart';
import 'Profile_Screen.dart';
import 'Settings_Screen.dart';
import 'package:path/path.dart' as path;

class HomePage extends StatefulWidget {
  final String currentUserEmail;

  const HomePage({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late List<Widget> _screens;

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
    String? currentUID = getCurrentUser();
    _screens = [
      JobListPage(),
      ChatScreen(
        currentUserEmail: widget.currentUserEmail,
      ),
      ProfileScreen(),
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
      body: Column(
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
