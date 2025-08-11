import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

import 'package:campus_life_hub/config/routes/app_routes.dart';


class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "header": "ยินดีต้อนรับสู่\nCampus Life Hub. ",
      "description": "จัดการชีวิตในมหาวิทยาลัยได้ง่ายขึ้นในแอปเดียว\nตารางเรียน, กิจกรรม, กลุ่มเรียน และอื่นๆ",
      "next_button": "เริ่มต้นเลย",
      "lottie": "assets/lotties/welcome.json"
    },
    {
      "header": "พก Schedule ไปกับคุณ\nทุกที่ ทุกเวลา",
      "description": "จัดการ และดูตารางเรียนรายวัน หรือราย session พร้อมแจ้งเตือนก่อนเข้าเรียน",
      "next_button": "ถัดไป",
      "lottie": "assets/lotties/schedule.json"
    },
    {
      "header": "Event เด็ด\nเด็กมหาลัยไม่ควรพลาด !",
      "description": "พบกับกิจกรรมสนุก ๆ ที่จัดขึ้นภายในมหาวิทยาลัย\nติดตามและเข้าร่วมกิจกรรมที่คุณไม่ควรพลาด\nเพื่อประสบการณ์มหา'ลัยที่สมบูรณ์แบบ",
      "next_button": "ถัดไป",
      "lottie": "assets/lotties/event.json"
    },
    {
      "header": "ไปด้วยกันไปได้ไกล\nกับ Study Group ที่ใช่ !",
      "description": "ไม่ต้องเรียนคนเดียวอีกต่อไป ! \nค้นหา หรือสร้างกลุ่มติว พูดคุย และเตรียมสอบไปพร้อมกับเพื่อนในคณะ หรือวิชาเดียวกัน",
      "next_button": "ถัดไป",
      "lottie": "assets/lotties/study_group.json"
    },
    {
      "header": "หลงก็ไม่กลัว เพราะมี\nCampus Map อยู่ข้าง ๆ",
      "description": "หาตึกเรียนไม่เจอ ? ไม่ต้องกังวล !\nดูแผนที่มหาวิทยาลัยแบบโต้ตอบ พร้อมเส้นทางเดิน \nอาคารสำคัญ และข้อมูลสถานที่ใช้งานได้ทันที",
      "next_button": "ถัดไป",
      "lottie": "assets/lotties/campus_map.json"
    },
    {
      "header": "ไม่พลาดทุก Announce \nที่สำคัญ !",
      "description": "รับข่าวสารและประกาศแบบเรียลไทม์ \nพร้อมระบบแจ้งเตือนให้คุณไม่พลาดสิ่งที่สำคัญที่สุด\nในชีวิตมหาลัย",
      "next_button": "ถัดไป",
      "lottie": "assets/lotties/announcement.json"
    },
    {
      "header": "แม้ไม่มีเน็ตก็พร้อมกับ \nOffline access !",
      "description": "ตารางเรียน ประกาศ หรือแผนที่ \nดาวน์โหลดไว้ดูได้ทุกที่ แม้ไม่มีอินเทอร์เน็ต \nแอปพร้อมให้คุณเข้าถึงข้อมูลสำคัญเสมอ",
      "next_button": "เริ่มต้นกันเลย !",
      "lottie": "assets/lotties/offline_access.json"
    },
  ];

  Future<void> _completeOnBoarding() async {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (slide['lottie'] != null)
                          Lottie.asset(
                            slide['lottie']!,
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        const SizedBox(height: 24),
                        Text(
                          slide['header']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 32 : 16,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                );
              }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _completeOnBoarding,
                    child: const Text("ข้าม"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _slides.length - 1) {
                        _completeOnBoarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(_slides[_currentPage]['next_button']!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
