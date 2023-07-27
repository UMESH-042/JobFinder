// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:vuna__gigs/screens/forgot_password.dart';
// import 'package:vuna__gigs/screens/signup_screen.dart';
// import 'package:vuna__gigs/admin/AdminHomesScreen.dart';

// import '../view/Home_Screen.dart';
// import 'methods.dart';

// class LoginScreen extends StatefulWidget {
//   // const LoginScreen({Key key}) : super(key: key);
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool isloading = false;
//   bool _obscurePassword = true;

// Future<String?> checkUserStatus(String email) async {
//   final snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .where('email', isEqualTo: email)
//       .limit(1)
//       .get();

//   if (snapshot.size > 0) {
//     final userMap = snapshot.docs[0].data();
//     final status = userMap['status'];
//     return status;
//   }

//   return null;
// }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: isloading
//           ? Center(
//               child: Container(
//                 height: size.height / 20,
//                 width: size.height / 20,
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: size.height / 8,
//                   ),
//                   // Container(
//                   //   alignment: Alignment.centerLeft,
//                   //   width: size.width / 1.2,
//                   //   child: IconButton(
//                   //     onPressed: () {},
//                   //     icon: Icon(Icons.arrow_back_ios),
//                   //   ),
//                   // ),
//                   SizedBox(
//                     height: size.height / 50,
//                   ),
//                   Container(
//                     width: size.width / 1.3,
//                     child: Text(
//                       "Welcome Back!",
//                       style: TextStyle(
//                         fontSize: 28.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 3),
//                   Container(
//                     width: size.width / 1.3,
//                     child: Text(
//                       "Fill your details or continue with social media",
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 15,
//                   ),
//                   Container(
//                     width: size.width,
//                     alignment: Alignment.center,
//                     child:
//                         field(size, "Email Address", Icons.account_box, _email),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 18.0),
//                     child: Container(
//                       width: size.width,
//                       alignment: Alignment.center,
//                       child: Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           field(
//                             size,
//                             "Password",
//                             Icons.lock,
//                             _password,
//                             obscureText: _obscurePassword,
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Align(
//                       // alignment: Alignment.centerRight,
//                       alignment: Alignment.centerRight,
//                       child: GestureDetector(
//                         onTap: () => Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                                 builder: (_) => ForgotPasswordPage())),
//                         child: Text(
//                           "Forget Password?",
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 40,
//                   ),
//                   customButton(size),

//                   SizedBox(
//                     height: size.height / 40,
//                   ),
//                   Center(
//                     child: Text(
//                       "--- Or Continue with ---",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 40,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/google_logo.png', // Replace with the path to the Google logo image
//                         height: 40,
//                       ),
//                       SizedBox(width: 20),
//                       Image.asset(
//                         'assets/facebook_logo.png', // Replace with the path to the Facebook logo image
//                         height: 40,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: size.height / 22,
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('New User?',
//                           style: TextStyle(fontWeight: FontWeight.w500)),
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).push(
//                             MaterialPageRoute(builder: (_) => CreateAccount())),
//                         child: Text(
//                           " Create Account!",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   void _clearFields() {
//     // _email.clear();
//     _password.clear();
//   }

//   Widget customButton(Size size) {
//     return GestureDetector(
//       onTap: () async {
//         if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
//           setState(() {
//             isloading = true;
//           });

//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 content: Row(
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(width: 20),
//                     Text("Please wait..."),
//                   ],
//                 ),
//               );
//             },
//           );

//           final status = await checkUserStatus(_email.text);

//           Navigator.pop(context); // Close the AlertDialog

//           if (status == 'Blocked') {
//             setState(() {
//               isloading = false;
//             });

//             // Show a blocked SnackBar
//             final snackBar = SnackBar(content: Text('You are blocked'));
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           } else {
//             // Proceed with login
//             Login(_email.text, _password.text).then((user) {
//               if (user != null) {
//                 print("Login Successful");
//                 setState(() {
//                   isloading = false;
//                 });

//                 getUserType(user.uid).then((String? userType) {
//                   if (userType == 'admin') {
//                     // Navigate to AdminScreen
//                     print('Login As Admin');

//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => AdminHomeScreen(
//                           currentuserEmail: _email.text,
//                         ),
//                       ),
//                     );
//                   } else if (userType == 'user') {
//                     // Navigate to HomeScreen
//                     print('Login As User');
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => HomePage(
//                           currentUserEmail: _email.text,
//                           requiresProfileSetup: true,
//                         ),
//                       ),
//                     );
//                   } else {
//                     print("Invalid UserType");
//                   }
//                 });

//                 // Show a success SnackBar
//                 final snackBar = SnackBar(content: Text('Login Successful'));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);

//                 _clearFields();
//               } else {
//                 print("Login Failed");
//                 setState(() {
//                   isloading = false;
//                 });

//                 // Show a failure SnackBar
//                 final snackBar = SnackBar(
//                   content: Text('Login Failed. Check Email/Password.'),
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               }
//             });
//           }
//         } else {
//           print("Please fill the form correctly!");
//         }
//       },
//       child: Container(
//         height: size.height / 14,
//         width: size.width / 1.2,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color.fromARGB(255, 76, 175, 142),
//         ),
//         alignment: Alignment.center,
//         child: isloading
//             ? CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               )
//             : Text(
//                 "LOG IN ",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget field(
//       Size size, String hintText, IconData icon, TextEditingController cont,
//       {bool obscureText = false}) {
//     return Container(
//       height: size.height / 15,
//       width: size.width / 1.3,
//       child: TextField(
//         controller: cont,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:vuna__gigs/screens/forgot_password.dart';
// import 'package:vuna__gigs/screens/signup_screen.dart';
// import 'package:vuna__gigs/admin/AdminHomesScreen.dart';

// import '../view/Home_Screen.dart';
// import 'methods.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool isloading = false;
//   bool _obscurePassword = true;
//   Future<String?> checkUserStatus(String email) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .limit(1)
//         .get();

//     if (snapshot.size > 0) {
//       final userMap = snapshot.docs[0].data();
//       final status = userMap['status'];
//       return status;
//     }

//     return null;
//   }

//   // Add a reference to FirebaseAuth instance
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Variable to check if the user is already logged in.
//   bool isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     // Check if the user is already logged in using authStateChanges()
//     _auth.authStateChanges().listen((User? user) {
//       if (user != null) {
//         setState(() {
//           isLoggedIn = true;
//         });
//         // Try auto-login here since we have a user.
//         _tryAutoLogin();
//       } else {
//         setState(() {
//           isLoggedIn = false;
//         });
//       }
//     });
//   }

//   // Add the method to handle automatic login if the user is already logged in.
//   void _tryAutoLogin() async {
//     if (isLoggedIn) {
//       // Get the current user's email
//       final String email = _auth.currentUser!.email!;

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Row(
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(width: 20),
//                 Text("Logging you in..."),
//               ],
//             ),
//           );
//         },
//       );

//       final status = await checkUserStatus(email);
//       Navigator.pop(context); // Close the AlertDialog

//       if (status == 'Blocked') {
//         // Show a blocked SnackBar
//         final snackBar = SnackBar(content: Text('You are blocked'));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       } else {
//         // Proceed with login
//         setState(() {
//           isloading = false;
//         });

//         getUserType(_auth.currentUser!.uid).then((String? userType) {
//           if (userType == 'admin') {
//             // Navigate to AdminScreen
//             print('Login As Admin');

//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => AdminHomeScreen(
//                   currentuserEmail: email,
//                 ),
//               ),
//             );
//           } else if (userType == 'user') {
//             // Navigate to HomeScreen
//             print('Login As User');
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => HomePage(
//                   currentUserEmail: email,
//                   requiresProfileSetup: true,
//                 ),
//               ),
//             );
//           } else {
//             print("Invalid UserType");
//           }
//         });

//         // Show a success SnackBar
//         final snackBar = SnackBar(content: Text('Login Successful'));
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);

//         _clearFields();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       // Remove the auto-login check here as we are already handling it in initState.
//       body: isloading
//           ? Center(
//               child: Container(
//                 height: size.height / 20,
//                 width: size.height / 20,
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: size.height / 8,
//                   ),
//                   SizedBox(
//                     height: size.height / 50,
//                   ),
//                   Container(
//                     width: size.width / 1.3,
//                     child: Text(
//                       "Welcome Back!",
//                       style: TextStyle(
//                         fontSize: 28.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 3),
//                   Container(
//                     width: size.width / 1.3,
//                     child: Text(
//                       "Fill your details or continue with social media",
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 15,
//                   ),
//                   Container(
//                     width: size.width,
//                     alignment: Alignment.center,
//                     child:
//                         field(size, "Email Address", Icons.account_box, _email),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 18.0),
//                     child: Container(
//                       width: size.width,
//                       alignment: Alignment.center,
//                       child: Stack(
//                         alignment: Alignment.centerRight,
//                         children: [
//                           field(
//                             size,
//                             "Password",
//                             Icons.lock,
//                             _password,
//                             obscureText: _obscurePassword,
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: GestureDetector(
//                         onTap: () => Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                                 builder: (_) => ForgotPasswordPage())),
//                         child: Text(
//                           "Forget Password?",
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 40,
//                   ),
//                   customButton(size),
//                   SizedBox(
//                     height: size.height / 40,
//                   ),
//                   Center(
//                     child: Text(
//                       "--- Or Continue with ---",
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.height / 40,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/google_logo.png', // Replace with the path to the Google logo image
//                         height: 40,
//                       ),
//                       SizedBox(width: 20),
//                       Image.asset(
//                         'assets/facebook_logo.png', // Replace with the path to the Facebook logo image
//                         height: 40,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: size.height / 22,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('New User?',
//                           style: TextStyle(fontWeight: FontWeight.w500)),
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).push(
//                             MaterialPageRoute(builder: (_) => CreateAccount())),
//                         child: Text(
//                           " Create Account!",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   void _clearFields() {
//     // _email.clear();
//     _password.clear();
//   }

//   Widget customButton(Size size) {
//     return GestureDetector(
//       onTap: () async {
//         if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
//           setState(() {
//             isloading = true;
//           });

//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 content: Row(
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(width: 20),
//                     Text("Please wait..."),
//                   ],
//                 ),
//               );
//             },
//           );

//           final status = await checkUserStatus(_email.text);

//           Navigator.pop(context); // Close the AlertDialog

//           if (status == 'Blocked') {
//             setState(() {
//               isloading = false;
//             });

//             // Show a blocked SnackBar
//             final snackBar = SnackBar(content: Text('You are blocked'));
//             ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           } else {
//             // Proceed with login
//             Login(_email.text, _password.text).then((user) {
//               if (user != null) {
//                 print("Login Successful");
//                 setState(() {
//                   isloading = false;
//                 });

//                 getUserType(user.uid).then((String? userType) {
//                   if (userType == 'admin') {
//                     // Navigate to AdminScreen
//                     print('Login As Admin');

//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => AdminHomeScreen(
//                           currentuserEmail: _email.text,
//                         ),
//                       ),
//                     );
//                   } else if (userType == 'user') {
//                     // Navigate to HomeScreen
//                     print('Login As User');
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => HomePage(
//                           currentUserEmail: _email.text,
//                           requiresProfileSetup: true,
//                         ),
//                       ),
//                     );
//                   } else {
//                     print("Invalid UserType");
//                   }
//                 });

//                 // Show a success SnackBar
//                 final snackBar = SnackBar(content: Text('Login Successful'));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);

//                 _clearFields();
//               } else {
//                 print("Login Failed");
//                 setState(() {
//                   isloading = false;
//                 });

//                 // Show a failure SnackBar
//                 final snackBar = SnackBar(
//                   content: Text('Login Failed. Check Email/Password.'),
//                 );
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               }
//             });
//           }
//         } else {
//           print("Please fill the form correctly!");
//         }
//       },
//       child: Container(
//         height: size.height / 14,
//         width: size.width / 1.2,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color.fromARGB(255, 76, 175, 142),
//         ),
//         alignment: Alignment.center,
//         child: isloading
//             ? CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               )
//             : Text(
//                 "LOG IN ",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget field(
//       Size size, String hintText, IconData icon, TextEditingController cont,
//       {bool obscureText = false}) {
//     return Container(
//       height: size.height / 15,
//       width: size.width / 1.3,
//       child: TextField(
//         controller: cont,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vuna__gigs/screens/forgot_password.dart';
import 'package:vuna__gigs/screens/signup_screen.dart';
import 'package:vuna__gigs/admin/AdminHomesScreen.dart';

import '../view/Home_Screen.dart';
import 'methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;
  bool _obscurePassword = true;
  late AnimationController _snackBarController;
  late Animation<double> _snackBarAnimation;

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

  // Add a reference to FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variable to check if the user is already logged in.
  bool isLoggedIn = false;
  bool _isLoggingIn = false;

  @override
  void initState() {
    _obscurePassword = true;

    super.initState();
    // Check if the user is already logged in using authStateChanges()
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isLoggedIn = true;
        });
        // Try auto-login here since we have a user.
        _tryAutoLogin();
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
  }

  // Add the method to handle automatic login if the user is already logged in.
  void _tryAutoLogin() async {
    if (isLoggedIn) {
      // Get the current user's email
      final String email = _auth.currentUser!.email!;
      if (_isLoggingIn) return; // If already logging in, do nothing

      _isLoggingIn = true;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Logging you in..."),
              ],
            ),
          );
        },
      );

      final status = await checkUserStatus(email);
      Navigator.pop(context); // Close the AlertDialog

      _isLoggingIn = false;
      if (status == 'Blocked') {
        // Show a blocked SnackBar
        final snackBar = SnackBar(content: Text('You are blocked'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Proceed with login
        setState(() {
          isloading = false;
        });

        getUserType(_auth.currentUser!.uid).then((String? userType) {
          if (userType == 'admin') {
            // Navigate to AdminScreen
            print('Login As Admin');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AdminHomeScreen(
                  currentuserEmail: email,
                ),
              ),
            );
          } else if (userType == 'user') {
            // Navigate to HomeScreen
            print('Login As User');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ShowCaseWidget(
                  builder: Builder(
                    builder: (context) => HomePage(
                      currentUserEmail: email,
                      requiresProfileSetup: true,
                    ),
                  ),
                ),
              ),
            );
          } else {
            print("Invalid UserType");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Successful!')),
          );
        });

        _clearFields();
      }
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing async operations or subscriptions here
    // to prevent errors when the widget is disposed.
    // For example, you can cancel the GoogleSignIn instance if it's active.

    GoogleSignIn().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Remove the auto-login check here as we are already handling it in initState.
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => ForgotPasswordPage())),
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

  void _clearFields() {
    // _email.clear();
    _password.clear();
  }

  void _handleGoogleSignIn() async {
    if (_isLoggingIn) return;
    if (!mounted) return;
    setState(() {
      isloading = true;
    });
    _isLoggingIn = true;

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
          // Google Sign-In successful
          print("Google Sign-In Successful");

          // Check the user's status (Blocked or not)
          final status = await checkUserStatus(user.email!);

          if (status == 'Blocked') {
            // User is blocked, show an error SnackBar and prevent login
            final snackBar = SnackBar(content: Text('You are blocked'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Sign out the user from Google as they are blocked
            await GoogleSignIn().signOut();
            setState(() {
              isloading = false;
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
        }
      } catch (e) {
        setState(() {
          isloading = false;
        });
        print("Google Sign-In Error: $e");
        // Show an error SnackBar
        final snackBar = SnackBar(content: Text('Google Sign-In Error'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      setState(() {
        isloading = false;
      });
      print("Google Sign-In Aborted");
      // Show a cancellation SnackBar
      final snackBar = SnackBar(content: Text('Google Sign-In Aborted'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    _isLoggingIn = false;
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ShowCaseWidget(
                builder: Builder(
                  builder: (context) => HomePage(
                    currentUserEmail: user.email!,
                    requiresProfileSetup: true,
                  ),
                ),
              ),
            ),
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

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () async {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          if (_isLoggingIn) return;

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
          // Reset the flag to false after the login process is completed
          _isLoggingIn = false;

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
                        builder: (_) => ShowCaseWidget(
                          builder: Builder(
                            builder: (context) => HomePage(
                              currentUserEmail: _email.text,
                              requiresProfileSetup: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    print("Invalid UserType");
                  }
                 
                });

                _clearFields();
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
      Size size, String hintText, IconData icon, TextEditingController cont,
      {bool obscureText = false}) {
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
