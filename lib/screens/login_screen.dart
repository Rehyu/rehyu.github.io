import 'package:flutter/material.dart';
import 'dart:convert';
import 'register_screen.dart';
import 'chat_screen.dart';
import 'package:first/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✨ 다국어 import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/JJ_Login.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(110, 0, 0, 0),
                          blurRadius: 12,
                          spreadRadius: 5,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Chat JJ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black45,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: local.logEnterId,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: local.logEnterPassword,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final res = await AuthService.login(
                            emailController.text,
                            passwordController.text,
                          );

                          if (res.statusCode == 200) {
                            final data = jsonDecode(utf8.decode(res.bodyBytes));
                            final id = data['username'];
                            final name = data['userRealName'];
                            final grade = data['grade'].toString();
                            final major = data['major'];
                            final language = data['language'];

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('user', id);
                            await prefs.setString('userName', name);
                            await prefs.setString('selectedGrade', '${grade}학년');
                            await prefs.setString('selectedDepartment', major);
                            await prefs.setString('selectedLanguage', language);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('로그인 성공')),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('로그인 실패: ${res.body}')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('네트워크 오류: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C2D57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        local.logLoginButton,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Or'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: Text(local.logRegister),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: Text(local.logTakeATour),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
