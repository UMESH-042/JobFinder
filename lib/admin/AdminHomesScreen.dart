// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:vuna__gigs/screens/methods.dart';

// import '../screens/login_screen.dart';

// class AdminHomeScreen extends StatefulWidget {
//   final String currentuserEmail;
//   const AdminHomeScreen({Key? key, required this.currentuserEmail}) : super(key: key);

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen> {
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Admin Page'),
//         actions: [
//           IconButton(
//             onPressed: () {

//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text('Admin Page'),
//       ),
//     );
//   }
// }

// class AuthProvider with ChangeNotifier {
//   Future logOut(BuildContext context) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;

//     try {
//       await _auth.signOut().then((value) {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (_) => LoginScreen()));
//       });
//     } catch (e) {
//       print("error");
//       return null;
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vuna__gigs/admin/userList.dart';
import 'package:vuna__gigs/screens/methods.dart';
import '../screens/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final String currentuserEmail;
  const AdminHomeScreen({Key? key, required this.currentuserEmail})
      : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final AuthProvider _authProvider = AuthProvider();

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
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UsersList(
                          currentUserEmail: widget.currentuserEmail)));
            },
            child: Text('Users List')),
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
