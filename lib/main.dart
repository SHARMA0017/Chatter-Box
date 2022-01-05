// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/screens/welcome_screen.dart';
import 'package:chatter_box/screens/login_screen.dart';
import 'package:chatter_box/screens/registration_screen.dart';
import 'package:chatter_box/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
        });
  }
}
