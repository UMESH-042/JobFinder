import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vuna__gigs/screens/signup_screen.dart';
import 'package:vuna__gigs/admin/AdminHomesScreen.dart';

import '../view/Home_Screen.dart';
import 'methods.dart';

class LoginScreen extends StatefulWidget {
  // const LoginScreen({Key key}) : super(key: key);
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;

  Future<String?> checkUserStatus(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.size > 0) {
      final userMap = snapshot.docs[0].data();
      final status = userMap['status'];
      return status;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isloading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 8,
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   width: size.width / 1.2,
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.arrow_back_ios),
                  //   ),
                  // ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.3,
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                  Container(
                    width: size.width / 1.3,
                    child: Text(
                      "Fill your details or continue with social media",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 15,
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child:
                        field(size, "Email Address", Icons.account_box, _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "Password", Icons.lock, _password),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      // alignment: Alignment.centerRight,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => CreateAccount())),
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  customButton(size),

                  SizedBox(
                    height: size.height / 40,
                  ),
                  Center(
                    child: Text(
                      "--- Or Continue with ---",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google_logo.png', // Replace with the path to the Google logo image
                        height: 40,
                      ),
                      SizedBox(width: 20),
                      Image.asset(
                        'assets/facebook_logo.png', // Replace with the path to the Facebook logo image
                        height: 40,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height / 22,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New User?',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => CreateAccount())),
                        child: Text(
                          " Create Account!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () async {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isloading = true;
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Please wait..."),
                  ],
                ),
              );
            },
          );

          final status = await checkUserStatus(_email.text);

          Navigator.pop(context); // Close the AlertDialog

          if (status == 'Blocked') {
            setState(() {
              isloading = false;
            });

            // Show a blocked SnackBar
            final snackBar = SnackBar(content: Text('You are blocked'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            // Proceed with login
            Login(_email.text, _password.text).then((user) {
              if (user != null) {
                print("Login Successful");
                setState(() {
                  isloading = false;
                });

                getUserType(user.uid).then((String? userType) {
                  if (userType == 'admin') {
                    // Navigate to AdminScreen
                    print('Login As Admin');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminHomeScreen(
                          currentuserEmail: _email.text,
                        ),
                      ),
                    );
                  } else if (userType == 'user') {
                    // Navigate to HomeScreen
                    print('Login As User');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(
                          currentUserEmail: _email.text,
                          requiresProfileSetup: true,
                        ),
                      ),
                    );
                  } else {
                    print("Invalid UserType");
                  }
                });

                // Show a success SnackBar
                final snackBar = SnackBar(content: Text('Login Successful'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                print("Login Failed");
                setState(() {
                  isloading = false;
                });

                // Show a failure SnackBar
                final snackBar = SnackBar(
                  content: Text('Login Failed. Check Email/Password.'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            });
          }
        } else {
          print("Please fill the form correctly!");
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 76, 175, 142),
        ),
        alignment: Alignment.center,
        child: isloading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                "LOG IN ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 15,
      width: size.width / 1.3,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
