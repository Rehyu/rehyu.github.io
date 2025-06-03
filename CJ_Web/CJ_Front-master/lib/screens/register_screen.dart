import 'package:first/screens/department_screen.dart';
import 'package:first/screens/grade_screen.dart';
import 'package:flutter/material.dart';
import 'package:first/services/auth_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 🌐 다국어 번역 사용

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String _selectedGrade = '';
  String _selectedDepartment = '';
  String _selectedLanguage = ''; // 기본 선택값
  final List<String> _languages = ['한국어', 'English', '中文', '日本語', 'Tiếng Việt'];

  InputDecoration buildInputDecoration(String hint, {bool isPassword = false, VoidCallback? toggleVisibility, bool isVisible = false}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: isPassword ? const Icon(Icons.lock_outline) : null,
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: toggleVisibility,
      )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: Text(local.regRegist, style: const TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Text(local.regId)),
            const SizedBox(height: 8),
            TextField(
              controller: idController,
              decoration: buildInputDecoration(local.logEnterId),
            ),
            const SizedBox(height: 16),

            Align(alignment: Alignment.centerLeft, child: Text(local.regPassword)),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: buildInputDecoration(
                local.logEnterPassword,
                isPassword: true,
                isVisible: isPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            Align(alignment: Alignment.centerLeft, child: Text(local.regPasswordConfirm)),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              obscureText: !isConfirmPasswordVisible,
              decoration: buildInputDecoration(
                local.regPasswordConfirm,
                isPassword: true,
                isVisible: isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            Align(alignment: Alignment.centerLeft, child: Text(local.regName)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: buildInputDecoration(local.regName),
            ),
            const SizedBox(height: 16),

            Align(alignment: Alignment.centerLeft, child: Text(local.regGrade)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: ListTile(
                title: Text(_selectedGrade.isEmpty ? local.graGrade : _selectedGrade),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final selected = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GradeSelectionScreen(selectedGrade: _selectedGrade)),
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedGrade = selected;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            Align(alignment: Alignment.centerLeft, child: Text(local.regDepartment)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: ListTile(
                title: Text(_selectedDepartment.isEmpty ? local.depChooseDep : _selectedDepartment),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  final selected = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DepartmentSelectionScreen(selectedDepartment: _selectedDepartment)),
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedDepartment = selected;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            Align(alignment: Alignment.centerLeft, child: Text(local.regLanguage)),
            const SizedBox(height: 8),
            DropdownButton2<String>(
              isExpanded: true,
              underline: const SizedBox.shrink(),
              hint: Text(local.regLanguage),
              value: _selectedLanguage.isEmpty ? null : _selectedLanguage,
              items: _languages.map((lang) => DropdownMenuItem<String>(
                value: lang,
                child: Text(lang),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
                    );
                    return;
                  }

                  try {
                    final res = await AuthService.register(
                      username: idController.text,
                      userRealName: nameController.text,
                      password: passwordController.text,
                      grade: int.tryParse(_selectedGrade.replaceAll('학년', '')) ?? 0,
                      major: _selectedDepartment,
                      language: _selectedLanguage,
                    );

                    if (res.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("회원가입 성공! 로그인 해주세요.")),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("회원가입 실패: ${res.body}")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("오류 발생: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C2D57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  local.regRegist,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
    );
  }
}
