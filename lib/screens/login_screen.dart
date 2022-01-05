// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace, unnecessary_null_comparison, avoid_print, await_only_futures

import 'package:chatter_box/components/Rounded_Button.dart';
import 'package:chatter_box/constants.dart';
import 'package:chatter_box/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  void checkUserLog() async {
    final user = await _auth.currentUser;
    if (user != null) {
      Navigator.pushNamed(context, ChatScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                decoration: kInputBorderDecor.copyWith(
                  hintText: 'Enter Your Email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                style: TextStyle(color: Colors.black),
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kInputBorderDecor.copyWith(
                  hintText: 'Enter Your Password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);

                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                text: Text('Log in'),
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
