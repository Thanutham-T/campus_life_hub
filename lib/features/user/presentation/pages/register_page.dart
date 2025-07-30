import 'package:campus_life_hub/core/widgets/widgets.dart';
import 'package:campus_life_hub/core/constants/constants.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_bloc.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_event.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';


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
    super.dispose();
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
              ? null 
              : _phoneController.text.trim(),
          studentId: _studentIdController.text.trim().isEmpty 
              ? null 
              : _studentIdController.text.trim(),
          department: _departmentController.text.trim().isEmpty 
              ? null 
              : _departmentController.text.trim(),
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
            context.go('/login');
          } else if (state is RegisterFailure) {
            Fluttertoast.showToast(
              msg: state.message,
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
                        Text(
                          'ข้อมูลการศึกษา (ไม่บังคับ)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _studentIdController,
                          label: 'รหัสนักศึกษา',
                          prefixIcon: Icons.badge,
                        ),
                        const SizedBox(height: AppSizes.spaceM),
                        AppTextField(
                          controller: _departmentController,
                          label: 'ภาควิชา/หน่วยงาน',
                          prefixIcon: Icons.business,
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
                    onPressed: () => context.go('/login'),
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


