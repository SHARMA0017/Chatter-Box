// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace, await_only_futures

import 'package:chatter_box/screens/chat_screen.dart';
import 'package:chatter_box/screens/login_screen.dart';
import 'package:chatter_box/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatter_box/components/Rounded_Button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
      final _auth = FirebaseAuth.instance;
  late AnimationController controller;
  late Animation animation;

  void checkUserLog() async{
    final User? user =await _auth.currentUser;
    if (user != null) {
      Navigator.pushNamed(context, ChatScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLog();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation =
        ColorTween(begin: Colors.black, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      '   Chatter Box',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              text: Text('Log in'),
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              text: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
