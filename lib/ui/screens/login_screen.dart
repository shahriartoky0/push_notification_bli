import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_bli/data/model/admin.dart';
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
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            final QuerySnapshot result = await firebaseFirestore
                                .collection('bli_admin')
                                .get();

                            for (QueryDocumentSnapshot element in result.docs) {
                              adminList.add(Admin(
                                  email: element.get('email'),
                                  password: element.get('password')));
                            }
                            for (Admin admin in adminList) {
                              if (admin.email ==
                                      _emailTEController.text.trim() &&
                                  admin.password ==
                                      _passwordTEController.text) {
                                clearTextFields();
                                if (mounted) {
                                  showSnackMessage(context, 'Login Successful');
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminPageScreen()),
                                      (route) => true);
                                }
                                break;
                              } else {
                                clearTextFields();
                                if (mounted) {
                                  showSnackMessage(context,
                                      'Invalid Username or Password !', true);
                                }
                              }
                            }
                          }
                        },
                        child: Text('Login'))),
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
