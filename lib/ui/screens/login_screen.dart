import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_bli/data/controller/auth_controller.dart';
import 'package:push_notification_bli/data/model/admin.dart';
import 'package:push_notification_bli/data/model/user.dart';
import 'package:push_notification_bli/ui/screens/admin_page.dart';
import 'package:push_notification_bli/ui/screens/signup_screen.dart';
import 'package:push_notification_bli/ui/widgets/snack_messages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Admin> adminList = [];
  List<User> userList = [];
  bool loginLoader = false;

  // Initialize Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Subscribe user to notifications topic
  void _subscribeToNotifications() {
    _firebaseMessaging.subscribeToTopic('notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  'Login to Continue ',
                  style: Theme.of(context).textTheme.displayMedium,
                )),
                SizedBox(height: 18),
                TextFormField(
                  validator: (value) {
                    return isEmailValid(value);
                  },
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty == true) {
                      return ' Password can not be empty ';
                    }
                  },
                  controller: _passwordTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    visible: loginLoader == false,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          loginLoader = true;
                          if (mounted) {
                            setState(() {});
                          }
                          final QuerySnapshot resultAdmin =
                              await firebaseFirestore
                                  .collection('bli_admin')
                                  .get();
                          final QuerySnapshot resultUser =
                              await firebaseFirestore
                                  .collection('bli_user')
                                  .get();
                          //------------------USER LOGIN --------------------------------
                          bool userLoggedIn =
                              false; // Add a flag to track user login status
                          for (QueryDocumentSnapshot element
                              in resultUser.docs) {
                            userList.add(User(
                                email: element.get('email'),
                                password: element.get('password'),
                                name: element.get('fullName')));
                          }
                          for (User user in userList) {
                            if (user.email == _emailTEController.text.trim() &&
                                user.password == _passwordTEController.text) {
                              clearTextFields();
                              if (mounted) {
                                userLoggedIn = true;
                                break; // Exit the loop
                              }
                            }
                          }
                          if (userLoggedIn) {
                            String? fcmToken = await _getFcmToken();
                            if (fcmToken != null) {
                              AuthController.saveUserInformation(fcmToken);
                            } else {
                              print(
                                  "Failed to retrieve FCM token. Skipping saving user information.");
                            }
                            print(fcmToken);
                            // Add the token to the FireStore Database starts

                            // Add the token to the FireStore Database ends
                            if (mounted) {
                              loginLoader = false;
                              // _subscribeToNotifications();
                              showSnackMessage(context, 'Login Successful');

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminPageScreen()),
                                  (route) => true);
                              return;
                            } // Exit onPressed callback
                          }
                          //------------------USER LOGIN --------------------------------
                          //------------------ADMIN LOGIN ---------------------------------
                          bool adminLoggedIn = false;
                          for (QueryDocumentSnapshot element
                              in resultAdmin.docs) {
                            adminList.add(Admin(
                                email: element.get('email'),
                                password: element.get('password')));
                          }
                          for (Admin admin in adminList) {
                            if (admin.email == _emailTEController.text.trim() &&
                                admin.password == _passwordTEController.text) {
                              clearTextFields();
                              if (mounted) {
                                adminLoggedIn = true;
                                break; // Exit the loop
                              }
                            }
                          }
                          if (adminLoggedIn) {
                            if (mounted) {
                              loginLoader = false;

                              showSnackMessage(
                                  context, 'Successfully Logged in as ADMIN');

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminPageScreen()),
                                  (route) => true);
                              return;
                            }
                          } else {
                            clearTextFields();
                            if (mounted) {
                              loginLoader = false;
                              setState(() {});
                              showSnackMessage(context,
                                  'Invalid Username or Password !', true);
                            }
                            return;
                          }
                          //------------------ADMIN LOGIN ---------------------------------
                        }
                      },
                      child: Text('Login'),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'If you do not have an account please',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: Text('Signup'))
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
    super.dispose();
  }

  Future<String?> _getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("FCM Token retrieved: $token");
      return token;
    } else {
      print("Failed to retrieve FCM token");
      return null;
    }
  }

  void clearTextFields() {
    _emailTEController.clear();
    _passwordTEController.clear();
  }

  // validate Email Address
  String? isEmailValid(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
