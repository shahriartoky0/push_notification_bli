import 'package:flutter/material.dart';
import 'package:push_notification_bli/ui/screens/login_screen.dart';
import 'package:push_notification_bli/ui/widgets/snack_messages.dart';

class CurrentAppBar extends StatelessWidget {
  const CurrentAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 2)),
      child: ListTile(
        title: Center(
          child: Text(
            'title',
          ),
        ),
        subtitle: Center(child: Text('subtitle')),
        trailing: IconButton.outlined(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(
                      child: const Text(
                        'Alert',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            'Do you want to Logout ?',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          showSnackMessage(context, 'Successfully Logged Out');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => true);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.purple,
            )),
      ),
    );
  }
}
