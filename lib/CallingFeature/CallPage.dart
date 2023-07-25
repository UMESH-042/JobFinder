
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:math' as math;

final String localUserID = math.Random().nextInt(10000).toString();

class CallIDPage extends StatelessWidget {
  final callIDTextCtrl = TextEditingController();
  final String? recipientToken;
  CallIDPage({super.key,this.recipientToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: callIDTextCtrl,
                  decoration: InputDecoration(labelText: "join a call by id"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Instead of directly navigating to the CallPage, send the call invitation through push notification.
                  await sendCallInvitation(callIDTextCtrl.text,recipientToken);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CallPage(callID: callIDTextCtrl.text);
                  }));
                },
                child: const Icon(Icons.video_call),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to request the recipient's FCM device token.
  Future<String?> getRecipientDeviceToken() async {
    // Replace 'your_recipient_user_id' with the user ID of the recipient.
    String recipientUserID = 'your_recipient_user_id';

    // Implement your logic to fetch the recipient's device token from your server or database.
    // You can use the recipientUserID to identify the recipient and retrieve the token associated with their device.
    // Return the FCM device token as a String or null if not available.
    // Example:
    // String? deviceToken = await fetchRecipientDeviceTokenFromServer(recipientUserID);

    // For this example, we'll simply return a hardcoded token for demonstration purposes.
    return 'your_recipient_device_token';
  }

  // Function to send the call invitation through push notification.
  Future<void> sendCallInvitation(String callID,String? recipientDeviceToken) async {
    // String? recipientDeviceToken =
    //     "e-AWdZ7KR2GjBwOMujsPjf:APA91bHaPmD3pR4-pEsEQXdRiBO0ANGc2cYkFgZf5XAZB69hCqBtds35aifsv4N_jrgoHw_n-_4xhnLuR_m7fjVaqzZp_iFNucc4pdP64oA0pCDH1QQ52xSpDcHaIi9-tHCieeeGBLpS";

    if (recipientDeviceToken == null) {
      print(
          'Recipient device token not available. Call invitation could not be sent.');
      return;
    }

    // Send the push notification for the call invitation to the recipient's device.
    await sendCallInvitationNotification(recipientDeviceToken, callID);

    // Print a message for demonstration purposes.
    print('Call invitation sent successfully!');
  }

  // Function to send the push notification for the call invitation to the recipient's device.
  Future<void> sendCallInvitationNotification(
      String recipientDeviceToken, String callID) async {
    // Replace 'your_server_endpoint' with your server-side endpoint for sending push notifications.
    String serverEndpoint = 'https://fcm.googleapis.com/fcm/send';

    // Replace 'your_server_api_key' with your server's API key for authorization.
    String serverApiKey =
        'AAAA6msbZ3E:APA91bHFliFq8amgNOiLnltmuo2AxFHnxfLoFk6uVeSf1LEH7jti-i7l-jtiuFZN61koUeAC94Wa_ckPSE5Ao8xFfK_fiDxtV4sArdob_scjxoVcqXnBTulJ_SH6tE48u0RJGiZyEV_p';

    // Create the request body with the recipient device token and call ID.
    Map<String, dynamic> requestBody = {
      'notification': {
        'title': 'Incoming Call',
        'body': 'You have an incoming call!',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
      'data': {
        'callID': callID,
      },
      'priority': 'high',
      'to': recipientDeviceToken,
    };

    // Send the push notification request to the server.
    try {
      final response = await http.post(
        Uri.parse(serverEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverApiKey',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Call invitation push notification sent successfully.');
      } else {
        print(
            'Failed to send call invitation push notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while sending call invitation push notification: $e');
    }
  }
}

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          368876341, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          "e427bd8d92d613b8d3ea0733789662cae9fed736e8a8ef4d743562764440f7cf", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: localUserID,
      userName: "user_$localUserID",
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
