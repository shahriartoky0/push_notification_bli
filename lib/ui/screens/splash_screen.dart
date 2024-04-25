import 'package:flutter/material.dart';
import 'package:push_notification_bli/data/utilities/urls.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) =>
        // Navigator.pushAndRemoveUntil(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen())));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(Urls.logoImgPath),
        ),
      ),
    );
  }
}
