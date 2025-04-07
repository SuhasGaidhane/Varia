import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false; // Default is false if not found

    Timer(Duration(seconds: 2), () {
      if (isLogin) {
        Get.off(() => Home(isLogin: true));
      } else {
        Get.off(() => Home(isLogin: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            FadeInDown(
              duration: Duration(seconds: 1),
              child: Image.asset("assets/images/varia_logo.png", height: 150),
            ),
            SizedBox(height: 8),
            FadeInUp(
              duration: Duration(seconds: 1),
              child: Text(
                'Vidharbh Agro Retailers & \nIndustrial Association',
                style: companyTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            FadeIn(
              duration: Duration(seconds: 2),
              child: Text("By"),
            ),
            SizedBox(height: 40),
            FadeInDown(
              duration: Duration(seconds: 1),
              child: Image.asset("assets/images/SidheshLogo.jpg", height: 80),
            ),
            SizedBox(height: 8),
            FadeInUp(
              duration: Duration(seconds: 1),
              child: Text('Siddhesh Advertising', style: companyTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  final TextStyle headingStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  final TextStyle companyTextStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff007342));

  final TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  final TextStyle linkStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.blueAccent,
    decoration: TextDecoration.underline,
  );
}