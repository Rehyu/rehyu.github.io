import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "http://172.20.10.3:8080";
  static final FlutterSecureStorage storage = FlutterSecureStorage();

  // 로그인
  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/member/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      print(response.body);  // 응답 본문 확인용

      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded.containsKey("accessToken")) {
        final accessToken = decoded["accessToken"];
        await storage.write(key: "accessToken", value: accessToken);  // 토큰 저장

        // 저장 후 바로 읽어서 확인
        final storedToken = await storage.read(key: "accessToken");
        print("✅ 저장된 토큰: $storedToken"); // 저장된 토큰 확인

        return response;
      } else {
        print("❌ 토큰이 응답에 포함되어 있지 않음");
      }
    } else {
      print("❌ 로그인 실패: ${response.statusCode}");
    }

    return response;
  }

  // 회원가입
  static Future<http.Response> register({
    required String username,
    required String userRealName,
    required String password,
    required int grade,
    required String major,
    required String language,
  }) async {
    final url = Uri.parse('$baseUrl/member/sign');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "userRealName": userRealName,
        "password": password,
        "grade": grade,
        "major": major,
        "language": language,
      }),
    );
    return response;
  }

  static Future<http.Response> updateGrade({
    required String username,
    required int grade,
}) async {
    final url = Uri.parse('$baseUrl/member/updateMemberGrade');

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "grade": grade,
      }),
    );
    return response;
  }

  static Future<http.Response> updateMajor({
    required String username,
    required String major,
  }) async {
    final url = Uri.parse('$baseUrl/member/updateMemberMajor');

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "major": major,
      }),
    );
    return response;
  }

  static Future<http.Response> updateLanguage({
    required String username,
    required String language,
  }) async {
    final url = Uri.parse('$baseUrl/member/updateMemberLanguage');

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "language": language,
      }),
    );
    return response;
  }

  /* 통합 코드
  static Future<http.Response> updateUserInfo({
    required String username,
    required int grade,
    required String major,
    required String language,
  }) async {
    final url = Uri.parse('$baseUrl/member/udateInfo');

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "grade": grade,
        "major": major,
        "language": language,
      }),
    );
    return response;
  }
   */

  // 토큰 가져오기
  static Future<String?> getToken() async {
    final token = await storage.read(key: "accessToken");
    print("🔐 읽은 토큰: $token"); // 토큰 읽기 확인 로그
    return token;
  }

  // 로그아웃 - 토큰 삭제
  static Future<void> logout() async {
    await storage.delete(key: "accessToken");
  }
}
