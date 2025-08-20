import 'package:flutter/material.dart';
import '../../../../core/constants/dimens.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // บัญชีผู้ใช้ Section
          SettingsSection(
            title: 'บัญชีผู้ใช้',
                children: [
                  SettingsItem(
                    icon: Icons.person,
                    title: 'ข้อมูลส่วนตัว',
                    subtitle: 'จัดการข้อมูลโปรไฟล์ของคุณ',
                    onTap: () {
                      // Navigate to profile editing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ฟีเจอร์นี้จะเปิดใช้งานเร็วๆ นี้'),
                        ),
                      );
                    },
                  ),
                  SettingsItem(
                    icon: Icons.security,
                    title: 'ความปลอดภัย',
                    subtitle: 'เปลี่ยนรหัสผ่านและการยืนยันตัวตน',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ฟีเจอร์นี้จะเปิดใช้งานเร็วๆ นี้'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimens.paddingLarge),
              
              // การแจ้งเตือน Section
              SettingsSection(
                title: 'การแจ้งเตือน',
                children: [
                  SettingsItem(
                    icon: Icons.notifications,
                    title: 'การแจ้งเตือนทั่วไป',
                    subtitle: 'ข่าวสาร กิจกรรม ประกาศต่างๆ',
                    trailing: Switch(
                      value: true,
                      onChanged: (bool value) {
                        // Handle notification toggle
                      },
                      activeColor: const Color(0xFF1565C0),
                    ),
                    onTap: null,
                  ),
                  SettingsItem(
                    icon: Icons.calendar_today,
                    title: 'กิจกรรมและอีเวนต์',
                    subtitle: 'แจ้งเตือนเมื่อมีกิจกรรมใหม่',
                    trailing: Switch(
                      value: false,
                      onChanged: (bool value) {
                        // Handle event notification toggle
                      },
                      activeColor: const Color(0xFF1565C0),
                    ),
                    onTap: null,
                  ),
                  SettingsItem(
                    icon: Icons.groups,
                    title: 'กลุ่มการเรียน',
                    subtitle: 'แจ้งเตือนข้อความและการเปลี่ยนแปลง',
                    trailing: Switch(
                      value: true,
                      onChanged: (bool value) {
                        // Handle study group notification toggle
                      },
                      activeColor: const Color(0xFF1565C0),
                    ),
                    onTap: null,
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimens.paddingLarge),
              
              // รูปลักษณ์ Section
              SettingsSection(
                title: 'รูปลักษณ์',
                children: [
                  SettingsItem(
                    icon: Icons.language,
                    title: 'ภาษา',
                    subtitle: 'ระบุชนิดภาษาที่แสดงผล',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ฟีเจอร์นี้จะเปิดใช้งานเร็วๆ นี้'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
  }
}
