import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Home_Screen.dart';

class ProfileScreen extends StatefulWidget {
  final String useremail;

  const ProfileScreen({Key? key, required this.useremail}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = getUserData();
  }

  Future<DocumentSnapshot> getUserData() async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.useremail)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 175, 142),
        title: Text('User Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userDataFuture,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final imageUrl = userData['imageUrl'];

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: imageUrl != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => PlaceholderImage(),
                            errorWidget: (context, url, error) =>
                                PlaceholderImage(),
                          ),
                        ),
                      ),
                      if (imageUrl == null)
                        Positioned(
                          bottom: 0,
                          right: screenWidth * 0.01,
                          child: Container(
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    userData['name'] ?? 'No Data',
                    style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    userData['bio'] ?? 'No Data',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(
                      userData['email'] ?? 'No Data',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
    );
  }
}
