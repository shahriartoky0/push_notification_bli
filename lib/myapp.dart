import 'package:flutter/material.dart';
import 'package:push_notification_bli/ui/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        primarySwatch: Colors.purple,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black87),
          fillColor: Colors.white30,
          filled: true,
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16))),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
              fontSize: 24, color: Colors.pink, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400),
          headlineSmall: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
