import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../loginemail/gmail_login.dart';
import '../registration/registration.dart';

class slpash extends StatefulWidget {
  const slpash({super.key});

  @override
  State<slpash> createState() => _slpashState();
}

class _slpashState extends State<slpash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => RegistrationPage()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
              height: 300,
              child: Image(image: AssetImage("assets/logowhite.png"),)),
        ),
      ),
    );
  }
}
