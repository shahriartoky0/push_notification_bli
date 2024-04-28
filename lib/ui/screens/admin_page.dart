import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_bli/ui/widgets/current_app_bar.dart';

import '../../data/utilities/urls.dart';

class AdminPageScreen extends StatefulWidget {
  const AdminPageScreen({super.key});

  @override
  State<AdminPageScreen> createState() => _AdminPageScreenState();
}

class _AdminPageScreenState extends State<AdminPageScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Inside _AdminPageScreenState class
  final String serverKey = Urls.serverKey;

// Send notification to users subscribed to the default topic
  void _sendNotificationToSubscribedUsers(String title, String body) async {
    // Construct the notification message
    var notificationMessage = {
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        // Add any additional data you want to send with the notification
      },
      'to': '/topic/users',
      'topic': 'users',
    };

    // Convert the notification message to JSON
    var messageJson = jsonEncode(notificationMessage);

    // Construct the request headers
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    // Send the HTTP POST request to FCM endpoint
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: messageJson,
    );

    // Handle the response
    if (response.statusCode == 200) {
      print(serverKey);
      print('Notification sent successfully');
      print(response.headers);
      print(response.body);
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                CurrentAppBar(),
                SizedBox(height: 20),
                Text('Push Notification Title',
                    style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 5),
                TextFormField(),
                SizedBox(height: 8),
                Text('Push Notification Body',
                    style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 5),
                TextFormField(
                  maxLines: 4,
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Inside the ElevatedButton onPressed callback
                    onPressed: () {
                      print('clicked notification');
                      _sendNotificationToSubscribedUsers(
                        'Push Notification Title',
                        'Push Notification Body',
                      );
                    },
                    child: Text('Send Notification'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
