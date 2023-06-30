
import 'package:flutter/material.dart';

import 'login_screen.dart';


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated picture or image
             Image.asset(
                        'assets/landingimage.jpg', // Replace with the path to the Google logo image
                        height: 200,
                      ),
            // FlutterLogo(
            //   size: size.width / 2,
            // ),
            SizedBox(height: size.height /40),
            Text(
              "Find a Perfect\n   Job Match",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height / 40),
            Text(
              "Finding your dream job is easier\n           and faster with JobHub",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: size.height / 20),
            customButton(context, size),
          ],
        ),
      ),
    );
  }
}

Widget customButton(BuildContext context, Size size) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    },
    child: Container(
      height: size.height / 14,
      width: size.width / 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 76, 175, 142),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Let's Get Started  ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
