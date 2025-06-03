import 'package:flutter/material.dart';
import 'package:first/screens/writeInquiry_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 다국어 지원

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  List<Map<String, String>> inquiries = [];
  static const String baseUrl = "http://172.20.10.3:8080";

  @override
  void initState() {
    super.initState();
    fetchInquiries(); // 초기 로드
  }

  void _navigateToWriteScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WriteInquiryScreen()),
    );

    if (result == true) {
      fetchInquiries(); // 등록 성공 시 목록 갱신
    }
  }


  Future<void> fetchInquiries() async {
    final url = Uri.parse('$baseUrl/inquiry/getInquiry');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          inquiries = data.map<Map<String, String>>((item) {
            return {
              'title': item['inquiryTitle'] ?? '',
              'content': item['inquiryContent'] ?? '',
            };
          }).toList();
        });
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 1,
        title: Text(local.inqInquiry, style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: BackButton(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: inquiries.length,
        itemBuilder: (context, index) {
          final inquiry = inquiries[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inquiry['title'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  inquiry['content'] ?? '',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 120, // 👈 버튼 너비 조절
        height: 48, // 👈 버튼 높이 조절 (선택 사항)
        child: FloatingActionButton.extended(
          onPressed: _navigateToWriteScreen,
          backgroundColor: Colors.lightBlueAccent,
          label: Text(local.inqWriteInq, style: TextStyle(fontSize: 14, color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
