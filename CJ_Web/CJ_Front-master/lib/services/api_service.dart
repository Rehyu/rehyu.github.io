import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://172.20.10.3:8080";
  static final FlutterSecureStorage storage = FlutterSecureStorage(); // 수정된 부분

  static Future<String> sendMessage({
    required String username,
    required String question,
    required String major,
    required dynamic grade, // grade는 숫자 또는 "학년" 문자열
    required String language,
    required bool usePersonalization, // ← 추가
  }) async {
    final useLoginChat = username.isNotEmpty && usePersonalization;
    final url = Uri.parse('$baseUrl/api/${useLoginChat ? 'loginChat' : 'chat'}');
    final token = await storage.read(key: 'accessToken');
    final body = useLoginChat
        ? {
      'username': username,
      'question': question,
      'major': major,
      'grade': grade,
      'language': language,
    }
        : {
      'question': question,
    };
    print("🔍 선택된 API: ${useLoginChat ? 'loginChat' : 'chat'}");
    print("📦 요청 body: $body");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map && decoded.containsKey("response")) {
          return decoded["response"];
        } else {
          return "서버 응답 형식 오류";
        }
      } else {
        return "서버 오류: ${response.statusCode}";
      }
    } catch (e) {
      return "네트워크 오류: $e";
    }
  }
}
