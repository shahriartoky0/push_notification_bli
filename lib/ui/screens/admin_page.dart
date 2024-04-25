import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:push_notification_bli/ui/widgets/current_app_bar.dart';

class AdminPageScreen extends StatefulWidget {
  const AdminPageScreen({super.key});

  @override
  State<AdminPageScreen> createState() => _AdminPageScreenState();
}

class _AdminPageScreenState extends State<AdminPageScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> getdata() async {
    final QuerySnapshot result =
        await firebaseFirestore.collection('students').get();
    print('Mere mehboob keyamat hogi');
    print(result.size);
    print(result.docs);
    for (QueryDocumentSnapshot element in result.docs) {
      print(element.get('name'));
      print(element.get('roll'));

      // print('element.data()');
    }
    setState(() {});
  }



  @override
  void initState() {
    getdata();
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
                    onPressed: () {},
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
