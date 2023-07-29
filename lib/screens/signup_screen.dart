import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vuna__gigs/screens/login_screen.dart';
import 'package:vuna__gigs/screens/methods.dart';

import '../admin/AdminHomesScreen.dart';
import '../view/Home_Screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;
  bool _obscurePassword = true;
  bool isLoggedIn = false;
  bool _isLoggingIn = false;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
     GoogleSignIn().disconnect();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
  if (_isLoggingIn) return;
  setState(() {
    isloading = true;
    _isLoggingIn = true;
  });
  
  

  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser != null) {
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Sign in with Firebase using the Google ID Token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        print("Google Sign-In Successful");

        // Check the user's status (Blocked or not) using local data instead of Firestore query
        final status = await checkUserStatus(user.email!);

        if (status == 'Blocked') {
          // User is blocked, show an error SnackBar and prevent login
          final snackBar = SnackBar(content: Text('You are blocked'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // Sign out the user from Google as they are blocked
          await GoogleSignIn().signOut();
          setState(() {
            isloading = false;
            _isLoggingIn = false;
          });
        } else {
          // User is not blocked, proceed with login
          // Store the user information in Firestore
          await storeUserDataInFirestore(user);
        }
      } else {
        print("Google Sign-In Failed");
        // Show a failure SnackBar
        final snackBar = SnackBar(content: Text('Google Sign-In Failed'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isloading = false;
          _isLoggingIn = false;
        });
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
      // Show an error SnackBar
      final snackBar = SnackBar(content: Text('Google Sign-In Error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isloading = false;
        _isLoggingIn = false;
      });
    }
  } else {
    print("Google Sign-In Aborted");
    // Show a cancellation SnackBar
    final snackBar = SnackBar(content: Text('Google Sign-In Aborted'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      isloading = false;
      _isLoggingIn = false;
    });
  }
}


  Future<void> storeUserDataInFirestore(User user) async {
    final userData = {
      'userType':
          'user', // You can set the userType as 'user' for Google Sign-In.
      'name': user.displayName,
      'email': user.email,
      'uid': user.uid,
      'imageUrl': user.photoURL,
      'status': 'Online',
    };

    try {
      // Add the user data to Firestore
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDocSnapshot = await userDoc.get();

      if (userDocSnapshot.exists) {
        // If the user's profile exists, update only the additional fields
        await userDoc.update(userData);
        print("User data updated in Firestore");
      } else {
        // If the user's profile does not exist, create a new document with the provided data
        await userDoc.set(userData);
        print("User data stored in Firestore");
      }

      // Proceed with login

      // Navigate to the appropriate screen based on the userType (user or admin)

      getUserType(user.uid).then((String? userType) {
        if (userType == 'admin') {
          // Navigate to AdminScreen
          print('Login As Admin');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AdminHomeScreen(
                currentuserEmail: user.email!,
              ),
            ),
          );
        } else if (userType == 'user') {
          // Navigate to HomeScreen
          print('Login As User');
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => HomePage(
          //       currentUserEmail: user.email!,
          //       requiresProfileSetup: true,
          //     ),
          //   ),
          // );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>ShowCaseWidget(builder: Builder(builder: (context)=> HomePage(
                  currentUserEmail: user.email!,
                  requiresProfileSetup: true,
                ),
              ),
                )
              )
            );
        } else {
          print("Invalid UserType");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successful!')),
        );
      });

      _clearFields();
    } catch (e) {
      print("Error storing user data in Firestore: $e");
      // Show an error SnackBar
      final snackBar = SnackBar(content: Text('Error storing user data'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

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
                    height: size.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width / 1.2,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.3,
                    child: Text(
                      "Register Account",
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                    height: size.height / 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "Name", Icons.lock, _name),
                    ),
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "Email", Icons.account_box, _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          field(
                            size,
                            "Password",
                            Icons.lock,
                            _password,
                            obscureText: _obscurePassword,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 20,
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
                      GestureDetector(
                        onTap: _handleGoogleSignIn,
                        child: Image.asset(
                          'assets/google_logo.png', // Replace with the path to the Google logo image
                          height: 40,
                        ),
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
                      Text('Already Have Account?',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        ),
                        child: Text(
                          " Log In!",
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

  void _clearFields() {
    _name.clear();
    // _email.clear();
    _password.clear();
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isloading = true;
          });
          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isloading = false;
              });
              print("Account Created Successfully");
              showSnackBar("Account Created Successfully");
              _clearFields();
    //                Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => HomePage(
    //           currentUserEmail: user.email!,
    //           requiresProfileSetup: true,
    //         ),
    //       ),    
    // );
    Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>ShowCaseWidget(builder: Builder(builder: (context)=> HomePage(
                  currentUserEmail: user.email!,
                  requiresProfileSetup: true,
                ),
              ),
                )
              )
            );
            } else {
              print("Account Creation Failed");
              setState(() {
                isloading = false;
              });
              showSnackBar("Account Creation Failed");
            }
          });
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
        child: Text(
          "SIGN UP",
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
    Size size,
    String hintText,
    IconData icon,
    TextEditingController cont, {
    bool obscureText = false,
  }) {
    return Container(
      height: size.height / 15,
      width: size.width / 1.3,
      child: TextField(
        controller: cont,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}