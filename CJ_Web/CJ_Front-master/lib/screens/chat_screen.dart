import 'package:flutter/material.dart';
import 'settings_screen.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 🌐 다국어 지원

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key); // key 받도록 수정

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Widget> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isBotResponding = false;
  bool _usePersonalization = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUsePersonalization();
    _checkLoginStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_messages.isEmpty) {
      final local = AppLocalizations.of(context)!;
      setState(() {
        _messages.addAll([
          _buildChatBubble(local.chaGreeting, isBot: true),
          _buildSuggestionBubble(),
        ]);
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('user');
    setState(() {
      _isLoggedIn = username != null && username.isNotEmpty;
    });
  }

  Future<void> _loadUsePersonalization() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usePersonalization = prefs.getBool('usePersonalization') ?? true;
    });
  }

  Future<void> _saveUsePersonalization(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usePersonalization', value);
  }

  Widget _buildChatBubble(String text,
      {bool isBot = false, bool isLoading = false}) {
    final local = AppLocalizations.of(context)!;

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isBot ? Colors.white : Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage('assets/run.png'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  local.chaGenerating,
                  style: TextStyle(
                    color: isBot ? Colors.black : Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final linkRegExp = RegExp(r'https?:\/\/[^\s)]+');
    final matches = linkRegExp.allMatches(text).toList();
    List<InlineSpan> spans = [];
    int lastIndex = 0;
    int linkCount = 1;

    String summarizeTitle(String title) {
      final stopWords = ['안내', '공지', '선발', '모집', '학년도', '파견', '신청', '공고'];
      final words = title
          .split(RegExp(r'\s+'))
          .where((word) =>
      !stopWords.contains(word) && word
          .trim()
          .isNotEmpty)
          .toList();
      return words.take(3).join(' ');
    }

    bool isValidTitle(String t) {
      return t
          .trim()
          .isNotEmpty &&
          t
              .trim()
              .length > 1 &&
          RegExp(r'[가-힣a-zA-Z]').hasMatch(t);
    }

    for (final match in matches) {
      final link = match.group(0)!;
      final start = match.start;
      final before = text.substring(lastIndex, start);

      spans.add(TextSpan(
        text: before,
        style: TextStyle(
          color: isBot ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ));

      final lines = before.trim().split('\n');
      String titleCandidate = '';
      if (lines.isNotEmpty) {
        for (int i = lines.length - 1; i >= 0; i--) {
          final line = lines[i].trim();
          if (line.toLowerCase().startsWith('링크')) continue;
          if (line == '🔗') continue;
          if (line.isNotEmpty) {
            titleCandidate = line;
            break;
          }
        }
      }

      final rawTitle = summarizeTitle(titleCandidate);
      final hasValidTitle = isValidTitle(rawTitle);

      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            onPressed: () async {
              final uri = Uri.parse(link);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('링크를 열 수 없습니다.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              textStyle: TextStyle(fontSize: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(hasValidTitle ? rawTitle : "공지 $linkCount 바로가기"),
          ),
        ),
      ));

      lastIndex = match.end;
      linkCount++;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          color: isBot ? Colors.black : Colors.white,
          fontSize: 14,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isBot ? Colors.white : Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: RichText(
            text: TextSpan(children: spans),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionBubble() {
    final local = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.chaGreetingButton),
              Wrap(
                spacing: 8,
                children: [
                  local.chaButton1,
                  local.chaButton2,
                  local.chaButton3,
                  local.chaButton4,
                  local.chaButton5,
                ].map((name) =>
                    ChoiceChip(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.blue),
                      label: Text(name),
                      selected: false,
                      onSelected: _isBotResponding ? null : (selected) =>
                          _sendMessage(name),
                    )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty && !_isBotResponding) {
      setState(() {
        _isBotResponding = true;
        _messages.add(_buildChatBubble(message));
        _messages.add(_buildChatBubble("", isBot: true, isLoading: true));
      });
      _controller.clear();
      _scrollToBottom();

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('user') ?? '';
      final language = prefs.getString('selectedLanguage') ?? '';
      final major = _usePersonalization ? prefs.getString(
          'selectedDepartment') ?? '학과' : '학과';
      final gradeRaw = prefs.getString('selectedGrade') ?? '';
      final grade = _usePersonalization ? gradeRaw.replaceAll(
          RegExp(r'[^0-9]'), '') : '학년';

      final response = await ApiService.sendMessage(
        username: username,
        question: message,
        major: major,
        grade: grade,
        language: language,
        usePersonalization: _usePersonalization, // ← 여기 추가
      );

      setState(() {
        _isBotResponding = false;
        _messages.removeLast();

        if (response.contains('### 월요일') && response.contains('### 금요일')) {
          final parsed = parseWeeklyMealResponse(response);
          _messages.add(WeeklyMealSlider(weeklyMeals: parsed));
        } else if (response.contains('### 중식') && response.contains('### 석식')) {
          final parsed = parseSingleDayMeal(response);
          _messages.add(SingleDayMealCard(
            day: parsed['day'],
            lunchMenu: parsed['lunch'],
            dinnerMenu: parsed['dinner'],
          ));
        } else {
          _messages.add(_buildChatBubble(response, isBot: true));
        }
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showOptions() {
    final loc = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8,
            children: [
              loc.chaPlusInfo,
              loc.chaPlusSch,
              loc.chaPlusCall,
            ].map((option) {
              return ChoiceChip(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.blue),
                label: Text(option),
                selected: false,
                onSelected: _isBotResponding
                    ? null
                    : (selected) {
                  Navigator.pop(context);
                  String responseText = '';

                  if (option.contains(loc.chaPlusInfo)) {
                    responseText = loc.chaPlusInfoRes;
                  } else if (option.contains(loc.chaPlusSch)) {
                    responseText = loc.chaPlusSchRes;
                  } else if (option.contains(loc.chaPlusCall)) {
                    responseText = loc.chaPlusCallRes;
                  }

                  setState(() {
                    _messages.add(_buildChatBubble(option));
                    _messages.add(_buildChatBubble(responseText, isBot: true));
                  });

                  _scrollToBottom();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return WillPopScope( // ← 여기 추가
      onWillPop: () async => false, // ← 뒤로가기 차단
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          centerTitle: true,
          title: Text('Chat JJ'),
          actions: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                Tooltip(
                  message: _isLoggedIn ? '' : AppLocalizations.of(context)!
                      .setLoginRequired,
                  child: Switch(
                    value: _usePersonalization,
                    onChanged: _isLoggedIn
                        ? (val) async {
                      setState(() {
                        _usePersonalization = val;
                      });
                      await _saveUsePersonalization(val);
                    }
                        : null,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.blue[200],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/jjHi.png', height: 150),
                    );
                  }
                  return _messages[index - 1];
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                  onPressed: _isBotResponding ? null : _showOptions,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(height: 1),
                    controller: _controller,
                    enabled: !_isBotResponding,
                    decoration: InputDecoration(
                      hintText: local.chaInsertChat,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (value) => _sendMessage(value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _isBotResponding ? null : () =>
                      _sendMessage(_controller.text),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class SingleDayMealCard extends StatelessWidget {
  final String day;
  final List<String> lunchMenu;
  final List<String> dinnerMenu;

  const SingleDayMealCard({
    required this.day,
    required this.lunchMenu,
    required this.dinnerMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$day 학식', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Text('🍱 중식', style: TextStyle(fontWeight: FontWeight.bold)),
            ...lunchMenu.map((e) => Text('• $e')),
            SizedBox(height: 8),
            Text('🍽 석식', style: TextStyle(fontWeight: FontWeight.bold)),
            ...dinnerMenu.map((e) => Text('• $e')),
          ],
        ),
      ),
    );
  }
}

class WeeklyMealSlider extends StatelessWidget {
  final Map<String, Map<String, List<String>>> weeklyMeals;

  const WeeklyMealSlider({required this.weeklyMeals});

  @override
  Widget build(BuildContext context) {
    final days = weeklyMeals.keys.toList();

    return Container(
      height: 260,
      child: PageView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final lunch = weeklyMeals[day]?['중식'] ?? [];
          final dinner = weeklyMeals[day]?['석식'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📅 $day', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('🍽  중식', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...lunch.map((e) => Text('• $e')),
                    SizedBox(height: 8),
                    Text('🍽 석식', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...dinner.map((e) => Text('• $e')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Map<String, dynamic> parseSingleDayMeal(String response) {
  final lines = response.split('\n');
  List<String> lunch = [];
  List<String> dinner = [];
  List<String>? target;

  for (var line in lines) {
    line = line.trim();
    if (line.startsWith('### 중식')) {
      target = lunch;
    } else if (line.startsWith('### 석식')) {
      target = dinner;
    } else if (line.isNotEmpty && target != null) {
      target.add(line.replaceAll(RegExp(r'^[0-9.]+ '), '').trim());
    }
  }

  return {
    'day': '오늘',
    'lunch': lunch,
    'dinner': dinner,
  };
}

Map<String, Map<String, List<String>>> parseWeeklyMealResponse(String response) {
  final dayHeaders = ['월요일', '화요일', '수요일', '목요일', '금요일'];
  final result = <String, Map<String, List<String>>>{};
  String? currentDay;
  String? currentMeal;

  for (var line in response.split('\n')) {
    line = line.trim();
    if (line.startsWith('###')) {
      for (var d in dayHeaders) {
        if (line.contains(d)) {
          currentDay = d;
          result[currentDay] = {'중식': [], '석식': []};
        }
      }
    } else if (line.contains('중식')) {
      currentMeal = '중식';
    } else if (line.contains('석식')) {
      currentMeal = '석식';
    } else if (line.isNotEmpty && currentDay != null && currentMeal != null) {
      result[currentDay]![currentMeal]!.add(
        line.replaceAll(RegExp(r'^[0-9.]+ '), '').trim(),
      );
    }
  }

  return result;
}
