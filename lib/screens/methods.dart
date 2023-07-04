import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Account created Successful");

      user.updateProfile(displayName: name);

      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "status": "unavailable",
        "uid": _auth.currentUser!.uid,
        "admin": "user",
      });
      return user;
    } else {
      print("Account creation failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> Login(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Login Successful");
      return user;
    } else {
      print("Login Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

// Future<User?> login(String email, String password) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   try {
//     User? user = (await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     ))
//         .user;

//     if (user != null) {
//       DocumentSnapshot snapshot = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (snapshot.exists) {
//         Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
//         String userType = userData['UserType'];

//         if (userType == 'admin') {
//           print("Admin Login Successful");
//           return user;
//         } else if (userType == 'user') {
//           print("User Login Successful");
//           return user;
//         } else {
//           print("Invalid UserType");
//           return null;
//         }
//       } else {
//         print("User data not found");
//         return null;
//       }
//     } else {
//       print("Login Failed");
//       return null;
//     }
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }

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

Future<String?> getUserType(String uid) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      String? userType = userData['userType'] as String?;

      return userType;
    } else {
      print("User data not found");
    }
  } catch (e) {
    print(e);
  }

  return '';
}
