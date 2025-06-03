import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(local.appInfo),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // 전체 페이지 패딩
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(local.appVersion, 'beta 0.0.1'),
                  const SizedBox(height: 12),
                  _buildInfoRow(local.appMade, '전주대 컴퓨터공학과 재학생'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }
}
