import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:vuna__gigs/screens/login_screen.dart';
import 'package:vuna__gigs/screens/methods.dart';

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
    super.dispose();
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