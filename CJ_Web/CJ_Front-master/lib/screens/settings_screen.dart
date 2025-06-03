import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/screens/grade_screen.dart';
import 'package:first/screens/department_screen.dart';
import 'package:first/screens/appInfo_screen.dart';
import 'package:first/screens/inquiry_screen.dart';
import 'package:first/services/auth_service.dart';
import 'package:first/main.dart';
import 'package:first/screens/chat_screen.dart';
import 'package:first/screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 다국어 지원
import 'package:first/models/department_keys.dart'; // 학과 다국어화
import 'package:first/extentions/app_localizations_extension.dart'; // 학과 다국어화


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = '한국어';
  final List<String> _languages = ['한국어', 'English', '中文', '日本語', 'Tiếng Việt'];
  String _selectedGrade = '학년';
  String _selectedDepartment = '학과';
  String _userName = '이름';


  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    _loadSelectedGrade();
    _loadSelectedDepartment();
    _loadUserName();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? '한국어';
    });
  }

  Future<void> _loadSelectedGrade() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedGrade = prefs.getString('selectedGrade') ?? '';
    });
  }

  Future<void> _loadSelectedDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDepartment = prefs.getString('selectedDepartment') ?? '';
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? '';
    });
  }

  Future<void> _saveSelectedLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }

  Future<void> _saveSelectedGrade(String grade) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGrade', grade);
  }

  Future<void> _saveSelectedDepartment(String dept) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDepartment', dept);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final departmentKey = departmentKeyMap[_selectedDepartment];
    final localizedDepartment = departmentKey != null
        ? (local.getString(departmentKey) ?? _selectedDepartment)
        : _selectedDepartment;

    String getLocalizedGrade(String grade, AppLocalizations local) {
      switch (grade) {
        case '1학년': return local.gra1st;
        case '2학년': return local.gra2nd;
        case '3학년': return local.gra3rd;
        case '4학년': return local.gra4th;
        default: return grade;
      }
    }

    Locale _getLocaleFromLang(String lang) {
      switch (lang) {
        case 'English':
          return const Locale('en');
        case '日本語':
          return const Locale('ja');
        case '中文':
          return const Locale('zh');
        case 'Tiếng Việt':
          return const Locale('vi');
        default:
          return const Locale('ko');
      }
    }

    final bool isLoggedIn = _userName.isNotEmpty;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(local.setMyInfo),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage('assets/profile_icon.png'),
              ),
              const SizedBox(height: 12),
              Text(
                '$_userName',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                localizedDepartment,
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 28),

              _buildCard(
                title: 'Language',
                children: _languages.map((lang) {
                  return ListTile(
                    leading: Icon(Icons.language, color: Colors.black87),
                    title: Text(lang),
                    trailing: _selectedLanguage == lang
                        ? Icon(Icons.check, color: Colors.blue)
                        : null,
                      onTap: () async {
                        setState(() {
                          _selectedLanguage = lang;
                        });
                        await _saveSelectedLanguage(lang);

                        //앱 언어 설정 변경
                        final locale = _getLocaleFromLang(_selectedLanguage);
                        MyApp.setLocale(context, locale);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChatScreen(key: UniqueKey())),
                        );

                        // 서버에 업데이트 요청 추가
                        final prefs = await SharedPreferences.getInstance();
                        final username = prefs.getString('user') ?? '';

                        final res = await AuthService.updateLanguage(
                          username: username,
                          language: _selectedLanguage,
                        );

                        if (res.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('언어가 변경되었습니다.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('변경 실패: ${res.body}')),
                          );
                        }
                      }
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              _buildCard(
                title: 'Academy Info',
                children: [
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('${local.setGrade} (${getLocalizedGrade(_selectedGrade, local)})'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      if (!isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(local.setLoginRequired)),
                        );
                        return;
                      }

                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GradeSelectionScreen(selectedGrade: _selectedGrade),
                        ),
                      );

                      if (selected != null && selected is String) {
                        setState(() {
                          _selectedGrade = selected;
                        });
                        await _saveSelectedGrade(selected);

                        final prefs = await SharedPreferences.getInstance();
                        final username = prefs.getString('user') ?? '';
                        final gradeInt = int.tryParse(selected.replaceAll('학년', '')) ?? 0;

                        final res = await AuthService.updateGrade(username: username, grade: gradeInt);
                        if (res.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('학년이 변경되었습니다.')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('변경 실패: ${res.body}')));
                        }
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('${local.setDep} ($localizedDepartment)'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      if (!isLoggedIn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(local.setLoginRequired)),
                        );
                        return;
                      }

                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentSelectionScreen(selectedDepartment: _selectedDepartment),
                        ),
                      );

                      if (selected != null && selected is String) {
                        setState(() {
                          _selectedDepartment = selected;
                        });
                        await _saveSelectedDepartment(selected);

                        final prefs = await SharedPreferences.getInstance();
                        final username = prefs.getString('user') ?? '';
                        final res = await AuthService.updateMajor(username: username, major: _selectedDepartment);

                        if (res.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('학과가 변경되었습니다.')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('변경 실패: ${res.body}')));
                        }
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildCard(
                title: 'Support',
                children: [
                  ListTile(
                    leading: Icon(Icons.login, color: Colors.black87),
                    title: Text(local.setInq),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InquiryScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(local.setInfo),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppInfoScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16), // 버튼 위 간격

              ElevatedButton.icon(
                icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
                label: Text(isLoggedIn ? 'Logout' : 'Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  if (isLoggedIn) {
                    // 로그아웃 처리
                    await prefs.clear();
                    setState(() {
                      _userName = '';
                      _selectedGrade = '';
                      _selectedDepartment = '';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그아웃되었습니다.')),
                    );
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(key: UniqueKey()))
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
