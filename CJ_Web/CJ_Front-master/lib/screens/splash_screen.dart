import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user'); // 자동 로그인 여부 판단

    await Future.delayed(Duration(seconds: 2)); // 스플래시 보여주는 시간

    if (userId != null && userId.isNotEmpty) {
      // 자동 로그인
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else {
      // 로그인 필요
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '나만의\n학교 챗봇\nChat JJ',
                    style: TextStyle(
                      color: Color(0xFF0077B6),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 60.0),
              child: Image.asset(
                'assets/walk.png',
                width: 200,
              ),
            ),
          ),
          SizedBox(height: 70),
          Text(
            'Chat JJ',
            style: TextStyle(
              color: Color(0xFF0077B6),
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
