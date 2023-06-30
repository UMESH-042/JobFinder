import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vuna__gigs/screens/LandingPage.dart';
import 'package:vuna__gigs/view/Home_Screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
