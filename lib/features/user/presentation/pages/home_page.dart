import 'package:flutter/material.dart';
import '../../../../core/core_modules.dart';
import 'login_page.dart';
import 'register_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register/Login")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/winner.png"),
              const SizedBox(height: 20),
              AppButton(
                text: "สร้างบัญชีผู้ใช้ใหม่",
                icon: Icons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              AppButton(
                text: "เข้าสู่ระบบ",
                icon: Icons.login,
                type: AppButtonType.outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


