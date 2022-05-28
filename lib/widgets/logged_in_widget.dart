import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/google_sign_in.dart';

class LoggedInWidget extends StatelessWidget {
  LoggedInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Logged In'),
          centerTitle: true,
          actions: [
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleSignOut();
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.displayName!,
                style: const TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }
}
