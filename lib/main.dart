import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:vuna__gigs/notification/notification_service.dart';
import 'package:vuna__gigs/screens/LandingPage.dart';
import 'package:vuna__gigs/view/Home_Screen.dart';

import 'CallingFeature/CallPage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  LocalNotificationService.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}


Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // _navigateToCallPage(message.data['callID']);
}

// void _navigateToCallPage(String callID) {
//   print('Navigating to the call page with callID: $callID');
//   // Use the Navigator to push the CallPage with the received callID.
//   // Assuming you have access to the current BuildContext, use it to push the CallPage.
//   Navigator.of(context as BuildContext).push(MaterialPageRoute(builder: (context) {
//     return CallPage(callID: callID);
//   }));
// }

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        child: SplashScreen(),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}