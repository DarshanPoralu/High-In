import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/logged_in_widget.dart';
import '../login/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return LoggedInWidget();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!!'));
            } else {
              return const LoginScreen();
            }
          },
        ),
      );
}
