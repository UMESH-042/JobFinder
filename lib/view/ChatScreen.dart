import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vuna__gigs/view/Home_Screen.dart';

import '../screens/chatRoom.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserEmail;
  const ChatScreen({Key? key, required this.currentUserEmail})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late Stream<QuerySnapshot> _usersStream;
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _usersList = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
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
        builder: (context) => ChatRoomScreen(
          chatRoomId: roomId,
          currentUserEmail: widget.currentUserEmail,
          otherUserEmail: userMap['email'],
          userMap: userMap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
    return Scaffold(
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
                    builder: (_) => HomePage(
                          currentUserEmail: widget.currentUserEmail,
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
      body: Column(
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
                          onTap: () => openChatRoom(user),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          title: userType=='admin'? Text(userName+'(Admin)'):Text(userName),
                          subtitle: Text(userEmail),
                          // Other user details can be displayed here
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
