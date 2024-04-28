import 'package:firebase_core/firebase_core.dart';
import 'package:push_notification_bli/data/controller/firebase_messaging_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService().initialize();
  // await FirebaseMessagingService().getFCMToken();

  runApp(const MyApp());
}
// main() {
//   runApp(MyApp());d
// }
