import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:highin_app/provider/google_sign_in.dart';
import 'package:highin_app/responsive/responsive_layout_screen.dart';
import 'package:highin_app/screens/login_screen.dart';
import 'package:highin_app/screens/signup_screen.dart';
import 'package:highin_app/utils/colors.dart';
import 'package:highin_app/responsive/mobile_screen_layout.dart';
import 'package:highin_app/responsive/web_screen_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDoZXmFE1OLgp0O54ceOb-z0AuWmwWZ_Vc',
        appId: '1:55724027418:web:347038ae7acd8d55262ba3',
        messagingSenderId: '55724027418',
        projectId: 'instagram-clone-313b6',
        storageBucket: 'instagram-clone-313b6.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context)=> GoogleSignInProvider(),
      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insta Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: LoginScreen(),
      ),
    );
  }
