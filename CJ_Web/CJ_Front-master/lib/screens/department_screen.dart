import 'package:flutter/material.dart';
import 'package:first/models/department_keys.dart';
import 'package:first/extentions/app_localizations_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 로컬라이제이션

class DepartmentSelectionScreen extends StatefulWidget {
  final String selectedDepartment;

  DepartmentSelectionScreen({required this.selectedDepartment});

  @override
  _DepartmentSelectionScreenState createState() =>
      _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState
    extends State<DepartmentSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<String> _allDepartments = [
    'IT금융학과', '간호학과', '건축공학과', '건축학과(5년제)', '게임콘텐츠학과',
    '경영학과', '경찰학과', '공연방송연기학과', '공연예술학과', '관광경영학과',
    '교육학과', '금융보험학과', '기계공학과', '기계자동차공학과', '농식품경영학과',
    '데이터공학과', '문헌정보학과', '물류무역학과', '물리치료학과', '반려동물산업학과',
    '반려동식물학과', '방사선학과', '법학과', '보건관리학과', '부동산국토정보학과',
    '사회복지학과', '산업공학과', '산업디자인학과', '상담심리학과', '생활체육학과',
    '소방안전공학과', '스마트미디어학과', '시각디자인학과', '식품영양학과',
    '신소재화학공학과', '신학과경배찬양학과', '역사콘텐츠학과', '영어영문학과',
    '영화방송학과', '예술심리치료학과', '외식산업조리학과', '운동처방학과',
    '웹툰만화콘텐츠학과', '인공지능학과', '일본언어문화학과', '작업치료학과',
    '재활학과', '전기전자공학과', '정보통신공학과', '중국어중국학과',
    '창업경영금융학과', '축구학과', '친환경자동차학과', '컴퓨터공학과',
    '태권도학과', '토목환경공학과', '패션산업학과', '한국어문학과', '한식조리학과',
    '행정학과', '호텔경영학과', '환경생명과학과', '회계세무학과', '음악학과',
  ];


  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final filtered = _allDepartments.where((dept) {
      final key = departmentKeyMap[dept];
      if (key == null) return false;

      final localizedName = local.getString(key);
      if (localizedName == null) return false;

      return localizedName.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(local.depChooseDep),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 검색창
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {
                _searchText = value;
              }),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: local.depSelectDep,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // 학과 리스트
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final dept = filtered[index];
                    return ListTile(
                      title: Text(local.getString(departmentKeyMap[dept]!) ?? dept),
                      trailing: dept == widget.selectedDepartment
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () => Navigator.pop(context, dept),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
