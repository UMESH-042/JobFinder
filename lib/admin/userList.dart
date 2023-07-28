import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vuna__gigs/admin/AdminHomesScreen.dart';
import 'package:vuna__gigs/admin/UserAdminChatRoom.dart';
import 'package:vuna__gigs/view/Home_Screen.dart';

import '../screens/chatRoom.dart';
import '../view/Profile_Screen.dart';

class UsersList extends StatefulWidget {
  final String currentUserEmail;
  const UsersList({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> with WidgetsBindingObserver {
  late Stream<QuerySnapshot> _usersStream;
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _usersList = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void deleteUser(DocumentSnapshot user) async {
    try {
      await _firestore.collection('users').doc(user.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the user')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //Online
      setStatus("online");
    } else {
      //Offline
      setStatus("Offline");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    // Simulating an asynchronous search
    await Future.delayed(Duration(seconds: 2));

    // Perform the search in the database based on the searched email
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('name', isEqualTo: _searchController.text)
            .get();

    setState(() {
      searchResults.clear();

      if (querySnapshot.size > 0) {
        // Retrieve the name from the search result and add it to the searchResults list
        final Map<String, dynamic> userMap = querySnapshot.docs[0].data();
        searchResults.insert(0, userMap);
      }

      isLoading = false;
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void openChatRoom(DocumentSnapshot user) {
    Map<String, dynamic> userMap = user.data() as Map<String, dynamic>;
    String roomId = chatRoomId(
      widget.currentUserEmail,
      userMap['email'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAdminChatRoom(
          chatRoomId: roomId,
          currentUserEmail: widget.currentUserEmail,
          otherUserEmail: userMap['email'],
          userMap: userMap,
        ),
      ),
    );
  }

  void blockUser(DocumentSnapshot user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update({"status": "Blocked"});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User blocked')),
    );
  }

  void unblockUser(DocumentSnapshot user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update({"status": "Online"});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User unblocked')),
    );
  }

  Future<void> _showDeleteConfirmationDialog(DocumentSnapshot user) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Do you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                deleteUser(user);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 249, 250, 251),
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 235, 237, 240),
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
                    builder: (_) => AdminHomeScreen(
                          currentuserEmail: widget.currentUserEmail,
                        )));
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                onSearch();
              }
            },
            decoration: InputDecoration(
              hintText: 'Search User',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: isLoading
          ? ShimmerEffect()
          : Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      _usersList = snapshot.data!.docs;

                      _usersList.removeWhere(
                          (user) => user['email'] == widget.currentUserEmail);

                      if (_searchController.text.isNotEmpty) {
                        _usersList = _usersList
                            .where((user) => user['name']
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase()))
                            .toList();
                      }
                      return ListView.builder(
                        itemCount: _usersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = _usersList[index];
                          final userName = user['name'];
                          final userEmail = user['email'];
                          final imageUrl = user['imageUrl'];
                          final userType = user['userType'];
                          final userStatus = user['status'];
                          final userId = user['uid'];

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                              useremail: userId)));
                                },
                                // leading: CircleAvatar(
                                //   backgroundImage: NetworkImage(imageUrl),
                                // ),
                                 leading: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 30.0,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                                title: userType == 'admin'
                                    ? Text(userName + '(Admin)')
                                    : Text(userName),
                                subtitle: Text(userEmail),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => openChatRoom(user),
                                      icon: Icon(Icons.chat),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (userStatus == "Blocked") {
                                          unblockUser(user);
                                        } else {
                                          blockUser(user);
                                        }
                                      },
                                      icon: Icon(userStatus == "Blocked"
                                          ? Icons.check_circle
                                          : Icons.block),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(user);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
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