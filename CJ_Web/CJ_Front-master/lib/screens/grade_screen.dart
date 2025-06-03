import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 다국어 지원

class GradeSelectionScreen extends StatefulWidget {
  final String selectedGrade;

  GradeSelectionScreen({required this.selectedGrade});

  @override
  _GradeSelectionScreenState createState() => _GradeSelectionScreenState();
}

class _GradeSelectionScreenState extends State<GradeSelectionScreen> {
  late String _selectedGrade;

  // 원본 학년 값은 그대로 저장
  final List<String> _grades = ['1학년', '2학년', '3학년', '4학년'];

  @override
  void initState() {
    super.initState();
    _selectedGrade = widget.selectedGrade;
  }

  void _selectGrade(String grade) {
    setState(() {
      _selectedGrade = grade;
    });
    Navigator.pop(context, grade); // 선택한 학년을 이전 화면에 전달
  }

  // 실제 표시용 다국어 변환 함수
  String _getLocalizedGrade(String grade, AppLocalizations local) {
    switch (grade) {
      case '1학년':
        return local.gra1st;
      case '2학년':
        return local.gra2nd;
      case '3학년':
        return local.gra3rd;
      case '4학년':
        return local.gra4th;
      default:
        return grade;
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(local.graGrade), // "학년" -> 다국어
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _grades.length,
            itemBuilder: (context, index) {
              final grade = _grades[index];
              return ListTile(
                title: Text(_getLocalizedGrade(grade, local)),
                trailing: grade == _selectedGrade
                    ? Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () => _selectGrade(grade),
              );
            },
          ),
        ),
      ),
    );
  }
}
