import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WriteInquiryScreen extends StatefulWidget {
  @override
  _WriteInquiryScreenState createState() => _WriteInquiryScreenState();
}

class _WriteInquiryScreenState extends State<WriteInquiryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _user = '';
  static const String baseUrl = "http://172.20.10.3:8080";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = prefs.getString('user') ?? '익명';
    });
  }

  Future<void> _submitInquiry() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final local = AppLocalizations.of(context)!;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/inquiry/saveInquiry');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'inquiryTitle': title,
        'inquiryContent': content,
        'username': _user,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문의가 등록되었습니다.')),
      );
      Navigator.pop(context, true); // 등록 성공 시 true 반환
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록에 실패했습니다. 다시 시도해주세요.')),
      );
      print("등록 실패 : ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(local.wriWriteInq),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: local.wriTitle),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: local.wriContent),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitInquiry,
              child: Text(local.wriReg),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
