// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class ForgotPasswordPage extends StatefulWidget {
// //   @override
// //   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// // }

// // class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final TextEditingController _emailController = TextEditingController();
// //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// //   bool _isLoading = false;
// //   String _emailError = '';

// //   Future<void> _resetPassword() async {
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
// //       _showSuccessDialog();
// //     } catch (e) {
// //       setState(() {
// //         _emailError = 'Failed to send reset email. Please check your email address.';
// //       });
// //     }

// //     setState(() {
// //       _isLoading = false;
// //     });
// //   }

// //   void _showSuccessDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Reset Password'),
// //           content: Text('A password reset email has been sent to your email address.'),
// //           actions: [
// //             TextButton(
// //               child: Text('OK'),
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Forgot Password'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Container(
// //           padding: EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               Text(
// //                 'Enter your email address to reset your password:',
// //                 style: TextStyle(fontSize: 16.0),
// //               ),
// //               SizedBox(height: 16.0),
// //               Form(
// //                 key: _formKey,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// //                   children: [
// //                     TextFormField(
// //                       controller: _emailController,
// //                       keyboardType: TextInputType.emailAddress,
// //                       validator: (value) {
// //                         if (value!.isEmpty) {
// //                           return 'Please enter your email address.';
// //                         }
// //                         return null;
// //                       },
// //                       decoration: InputDecoration(
// //                         labelText: 'Email',
// //                         errorText: _emailError.isNotEmpty ? _emailError : null,
// //                       ),
// //                     ),
// //                     SizedBox(height: 16.0),
// //                     ElevatedButton(
// //                       onPressed: _isLoading ? null : () {
// //                         if (_formKey.currentState!.validate()) {
// //                           _resetPassword();
// //                         }
// //                       },
// //                       child: _isLoading
// //                           ? CircularProgressIndicator()
// //                           : Text('Reset Password'),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ForgotPasswordPage extends StatefulWidget {
//   @override
//   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final TextEditingController _emailController = TextEditingController();
//   bool _isLoading = false;

//   void _resetPassword() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: _emailController.text,
//       );

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Email Sent'),
//             content: Text('A password reset email has been sent to your email address.'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (error) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text(error.toString()),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     SizedBox(height: size.height / 8),
//                     Container(
//                       width: size.width / 1.3,
//                       child: Text(
//                         "Forgot Your Password?",
//                         style: TextStyle(
//                           fontSize: 28.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Container(
//                       width: size.width / 1.3,
//                       child: Text(
//                         "Enter your email address below to reset your password.",
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: size.height / 15),
//                     field(size, "Email Address", Icons.email, _emailController),
//                     SizedBox(height: size.height / 22),
//                     customButton(size),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget customButton(Size size) {
//     return GestureDetector(
//       onTap: _resetPassword,
//       child: Container(
//         height: size.height / 14,
//         width: size.width / 1.2,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Color.fromARGB(255, 76, 175, 142),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           "RESET PASSWORD",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget field(
//       Size size, String hintText, IconData icon, TextEditingController cont) {
//     return Container(
//       height: size.height / 15,
//       width: size.width / 1.3,
//       child: TextField(
//         controller: cont,
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Sent'),
            content: Text('A password reset email has been sent to your email address.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: size.height / 25),
                    Align(
                      alignment: Alignment.topLeft,
                      child:
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
                      },
                    ),
                ),
                    SizedBox(height: size.height / 8),
                    Container(
                      width: size.width / 1.3,
                      child: Text(
                        "Forgot Your Password?",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: size.width / 1.3,
                      child: Text(
                        "Enter your email address below to reset your password.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height / 15),
                    field(size, "Email Address", Icons.email, _emailController),
                    SizedBox(height: size.height / 22),
                    customButton(size),
                  ],
                ),
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: _resetPassword,
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 76, 175, 142),
        ),
        alignment: Alignment.center,
        child: Text(
          "RESET PASSWORD",
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
