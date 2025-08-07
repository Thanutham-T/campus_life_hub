import 'package:campus_life_hub/core/constants/constants.dart';
import 'package:campus_life_hub/config/routes/app_routes.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_bloc.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_event.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core_modules.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _departmentController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _campusController = TextEditingController();
  final _facultyController = TextEditingController();
  final _majorController = TextEditingController();
  final _curriculumController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    _educationLevelController.dispose();
    _campusController.dispose();
    _facultyController.dispose();
    _majorController.dispose();
    _curriculumController.dispose();
    super.dispose();
  }

  void _fillSampleData() {
    _studentIdController.text = '6510110321';
    _educationLevelController.text = 'master degree';
    _campusController.text = 'hatyai';
    _facultyController.text = 'engineering';
    _majorController.text = 'computer engineer';
    _curriculumController.text = 'international program';
    _departmentController.text = 'computer engineering';
    _phoneController.text = '0812345678';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        Fluttertoast.showToast(
          msg: "รหัสผ่านไม่ตรงกัน",
          gravity: ToastGravity.TOP,
        );
        return;
      }

      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _phoneController.text.trim(),
          studentId: _studentIdController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _studentIdController.text.trim(),
          department: _departmentController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _departmentController.text.trim(),
          educationLevel: _educationLevelController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _educationLevelController.text.trim(),
          campus: _campusController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _campusController.text.trim(),
          faculty: _facultyController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _facultyController.text.trim(),
          major: _majorController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _majorController.text.trim(),
          curriculum: _curriculumController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _curriculumController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("สร้างบัญชีผู้ใช้ใหม่"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Fluttertoast.showToast(
              msg: "สร้างบัญชีผู้ใช้สำเร็จ",
              gravity: ToastGravity.TOP,
            );
            context.go(Routes.login);
          } else if (state is RegisterFailure) {
            Fluttertoast.showToast(
              msg: state.message.isNotEmpty ? state.message : "เกิดข้อผิดพลาดในการสร้างบัญชี",
              gravity: ToastGravity.TOP,
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.spaceM),
                  
                  // Welcome Text
                  Text(
                    'สร้างบัญชีใหม่',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Text(
                    'กรอกข้อมูลเพื่อสร้างบัญชีผู้ใช้',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceL),

                  // Personal Information Section
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ข้อมูลส่วนตัว',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _firstNameController,
                          label: 'ชื่อ',
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกชื่อ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _lastNameController,
                          label: 'นามสกุล',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกนามสกุล';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _phoneController,
                          label: 'เบอร์โทรศัพท์ (ไม่บังคับ)',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // Academic Information Section
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ข้อมูลการศึกษา (ไม่บังคับ)',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextButton(
                              onPressed: _fillSampleData,
                              child: Text(
                                'ใส่ข้อมูลตัวอย่าง',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _studentIdController,
                          label: 'รหัสนักศึกษา',
                          prefixIcon: Icons.badge,
                          hint: 'เช่น 6510110321',
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _educationLevelController,
                          label: 'ระดับการศึกษา',
                          prefixIcon: Icons.school,
                          hint: 'เช่น ปริญญาตรี, ปริญญาโท, ปริญญาเอก',
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _campusController,
                          label: 'วิทยาเขต',
                          prefixIcon: Icons.location_city,
                          hint: 'เช่น วิทยาเขตบางมด, วิทยาเขตกำแพงแสน',
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _facultyController,
                          label: 'คณะ',
                          prefixIcon: Icons.account_balance,
                          hint: 'เช่น คณะวิทยาศาสตร์, คณะวิศวกรรมศาสตร์',
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _majorController,
                          label: 'สาขาวิชา',
                          prefixIcon: Icons.book,
                          hint: 'เช่น วิทยาการคอมพิวเตอร์, วิศวกรรมคอมพิวเตอร์',
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _curriculumController,
                          label: 'หลักสูตร',
                          prefixIcon: Icons.description,
                          hint: 'เช่น หลักสูตรปกติ 4 ปี, หลักสูตรนานาชาติ',
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _departmentController,
                          label: 'ภาควิชา/หน่วยงาน',
                          prefixIcon: Icons.business,
                          hint: 'เช่น ภาควิชาวิทยาการคอมพิวเตอร์',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // Account Information Section
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ข้อมูลบัญชีผู้ใช้',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _emailController,
                          label: 'อีเมล',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'กรุณากรอกอีเมล';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'รูปแบบอีเมลไม่ถูกต้อง';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _passwordController,
                          label: 'รหัสผ่าน',
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกรหัสผ่าน';
                            }
                            if (value.length < 6) {
                              return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _confirmPasswordController,
                          label: 'ยืนยันรหัสผ่าน',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณายืนยันรหัสผ่าน';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceL),

                  // Submit Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is RegisterLoading;
                      return AppButton(
                        text: 'สร้างบัญชี',
                        onPressed: isLoading ? null : _submit,
                        type: AppButtonType.primary,
                        isFullWidth: true,
                        isLoading: isLoading,
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // Login Link
                  TextButton(
                    onPressed: () => context.go(Routes.login),
                    child: RichText(
                      text: TextSpan(
                        text: 'มีบัญชีแล้ว? ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                        children: [
                          TextSpan(
                            text: 'เข้าสู่ระบบ',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


