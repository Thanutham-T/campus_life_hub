import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
            );
            context.go('/dashboard');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    
                    // Logo or Header
                    const Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      'ศูนย์กลางชีวิตมหาวิทยาลัย',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'อีเมล',
                        hintText: 'ใส่อีเมลของคุณ',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        if (!value.contains('@')) {
                          return 'รูปแบบอีเมลไม่ถูกต้อง';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'รหัสผ่าน',
                        hintText: 'ใส่รหัสผ่านของคุณ',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        if (value.length < 6) {
                          return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),
                    const SizedBox(height: 48),
                    
                    // Login button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is LoginLoading ? null : _handleLogin,
                          child: state is LoginLoading
                              ? const CircularProgressIndicator()
                              : const Text('เข้าสู่ระบบ'),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ยังไม่มีบัญชี? '),
                        GestureDetector(
                          onTap: () {
                            context.go('/register');
                          },
                          child: Text(
                            'สร้างบัญชี',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}

