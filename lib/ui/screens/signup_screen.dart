import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_bli/ui/screens/login_screen.dart';
import 'package:push_notification_bli/ui/widgets/snack_messages.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController _emailTEController = TextEditingController();
  TextEditingController _passwordTEController = TextEditingController();
  TextEditingController _nameTEController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register Now',
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailTEController,
                  validator: (value) {
                    return isEmailValid(value);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _passwordTEController,
                  validator: (value) {
                    return isPasswordValid(value);
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _nameTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return 'Please Enter Your Name';
                    }
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            Map<String, String> user = {
                              'email': _emailTEController.text.trim(),
                              'password': _passwordTEController.text,
                              'fullName': _nameTEController.text.trim(),
                            };

                            try {
                              await firebaseFirestore
                                  .collection('bli_user')
                                  .add(user);
                              clearTextFields();
                              if (mounted) {
                                showSnackMessage(
                                    context, 'Registration Complete');
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()), (
                                        route) => false);
                              }
                            } catch (e) {
                              if (mounted) {
                                showSnackMessage(context, 'Error: $e');
                              }
                            }
                          }
                        },
                        child: Text('Register'))),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'If you are already a user please',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                                  (route) => false);
                        },
                        child: Text('Login'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _nameTEController.dispose();

    super.dispose();
  }

  void clearTextFields() {
    _emailTEController.clear();
    _passwordTEController.clear();
    _nameTEController.clear();
  }

  // validate Email Address
  String? isEmailValid(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? isPasswordValid(String? password) {
    if (password == null || password
        .trim()
        .isEmpty) {
      return 'Password cannot be empty.';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number.';
    }
    return null; // Password is valid
  }
}
