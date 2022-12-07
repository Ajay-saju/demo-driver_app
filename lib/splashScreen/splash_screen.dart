import 'dart:async';
import 'package:drivers_app/mainScreen/main_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MySpashScreen extends StatefulWidget {
  const MySpashScreen({Key? key}) : super(key: key);

  @override
  State<MySpashScreen> createState() => _MySpashScreenState();
}

class _MySpashScreenState extends State<MySpashScreen> {
  setTimer() {
    Timer(Duration(milliseconds: 10), () async {
      // send user to home screen
      await Get.to(MainScreen());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
