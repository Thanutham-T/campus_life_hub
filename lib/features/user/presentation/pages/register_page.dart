import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:campus_life_hub/config/routes/app_routes.dart';

import 'package:campus_life_hub/features/user/presentation/bloc/auth_bloc.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_event.dart';
import 'package:campus_life_hub/features/user/presentation/bloc/auth_state.dart';

// Custom painter for diagonal lines
class DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw diagonal lines
    for (int i = 0; i < 8; i++) {
      final startX = -50.0 + (i * 100);
      final path = Path();
      path.moveTo(startX, 0);
      path.quadraticBezierTo(
        startX + 50, size.height * 0.3,
        startX + 100, size.height * 0.6,
      );
      path.quadraticBezierTo(
        startX + 150, size.height * 0.9,
        startX + 200, size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


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
  final _curriculumController = TextEditingController();

  // Dropdown values
  String? _selectedEducationLevel;
  String? _selectedCampus;
  String? _selectedFaculty;
  String? _selectedMajor;

  // Step control
  int _currentStep = 0;
  final PageController _pageController = PageController();

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
    _curriculumController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Personal Information
        return _firstNameController.text.trim().isNotEmpty &&
               _lastNameController.text.trim().isNotEmpty &&
               _emailController.text.trim().isNotEmpty &&
               RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
      case 1: // Academic Information (optional)
        return true;
      case 2: // Account Information
        return _passwordController.text.isNotEmpty &&
               _passwordController.text == _confirmPasswordController.text;
      default:
        return false;
    }
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
          educationLevel: _selectedEducationLevel?.isEmpty == true
              ? 'ไม่ระบุ' 
              : _selectedEducationLevel ?? 'ไม่ระบุ',
          campus: _selectedCampus?.isEmpty == true
              ? 'ไม่ระบุ' 
              : _selectedCampus ?? 'ไม่ระบุ',
          faculty: _selectedFaculty?.isEmpty == true
              ? 'ไม่ระบุ' 
              : _selectedFaculty ?? 'ไม่ระบุ',
          major: _selectedMajor?.isEmpty == true
              ? 'ไม่ระบุ' 
              : _selectedMajor ?? 'ไม่ระบุ',
          curriculum: _curriculumController.text.trim().isEmpty 
              ? 'ไม่ระบุ' 
              : _curriculumController.text.trim(),
        ),
      );
    }
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = step <= _currentStep;
    final isCompleted = step < _currentStep;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
                ? Colors.white 
                : Colors.white.withOpacity(0.3),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Color(0xFF1976D2),
                    size: 20,
                  )
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive 
                          ? const Color(0xFF1976D2) 
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'ข้อมูลพื้นฐาน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        // First name and last name row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF1976D2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'นามสกุล',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF1976D2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกนามสกุล';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Email field
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'อีเมล',
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Color(0xFF1976D2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
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
        const SizedBox(height: 20),
        
        // Phone field
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'เบอร์โทรศัพท์ (ไม่บังคับ)',
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: Color(0xFF1976D2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        
        const Spacer(),
        
        // Next button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_validateCurrentStep()) {
                _nextStep();
              } else {
                Fluttertoast.showToast(
                  msg: "กรุณากรอกข้อมูลให้ครบถ้วน",
                  gravity: ToastGravity.TOP,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'ต่อไป',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicInfoStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ข้อมูลการศึกษา (ไม่บังคับ)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Student ID
          TextFormField(
            controller: _studentIdController,
            decoration: InputDecoration(
              labelText: 'รหัสนักศึกษา',
              prefixIcon: const Icon(
                Icons.badge_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          
          // Education level dropdown
          DropdownButtonFormField<String>(
            value: _selectedEducationLevel,
            decoration: InputDecoration(
              labelText: 'ระดับการศึกษา',
              prefixIcon: const Icon(
                Icons.school_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'ปริญญาตรี', child: Text('ปริญญาตรี')),
              DropdownMenuItem(value: 'ปริญญาโท', child: Text('ปริญญาโท')),
              DropdownMenuItem(value: 'ปริญญาเอก', child: Text('ปริญญาเอก')),
              DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedEducationLevel = value;
              });
            },
          ),
          const SizedBox(height: 20),
          
          // Campus dropdown
          DropdownButtonFormField<String>(
            value: _selectedCampus,
            decoration: InputDecoration(
              labelText: 'วิทยาเขต',
              prefixIcon: const Icon(
                Icons.location_city_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'วิทยาเขตหาดใหญ่', child: Text('วิทยาเขตหาดใหญ่')),
              DropdownMenuItem(value: 'วิทยาเขตภูเก็ต', child: Text('วิทยาเขตภูเก็ต')),
              DropdownMenuItem(value: 'วิทยาเขตสุราษฎร์ธานี', child: Text('วิทยาเขตสุราษฎร์ธานี')),
              DropdownMenuItem(value: 'วิทยาเขตตรัง', child: Text('วิทยาเขตตรัง')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCampus = value;
              });
            },
          ),
          const SizedBox(height: 20),
          
          // Faculty dropdown
          DropdownButtonFormField<String>(
            value: _selectedFaculty,
            decoration: InputDecoration(
              labelText: 'คณะ',
              prefixIcon: const Icon(
                Icons.account_balance_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'คณะวิศวกรรมศาสตร์', child: Text('คณะวิศวกรรมศาสตร์')),
              DropdownMenuItem(value: 'คณะวิทยาศาสตร์', child: Text('คณะวิทยาศาสตร์')),
              DropdownMenuItem(value: 'คณะเทคโนโลยีสารสนเทศ', child: Text('คณะเทคโนโลยีสารสนเทศ')),
              DropdownMenuItem(value: 'คณะแพทยศาสตร์', child: Text('คณะแพทยศาสตร์')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFaculty = value;
                _selectedMajor = null;
              });
            },
          ),
          const SizedBox(height: 20),
          
          // Major dropdown
          DropdownButtonFormField<String>(
            value: _selectedMajor,
            decoration: InputDecoration(
              labelText: 'สาขาวิชา',
              prefixIcon: const Icon(
                Icons.book_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: _selectedFaculty == 'คณะวิศวกรรมศาสตร์'
                ? const [
                    DropdownMenuItem(value: 'วิศวกรรมคอมพิวเตอร์', child: Text('วิศวกรรมคอมพิวเตอร์')),
                    DropdownMenuItem(value: 'วิศวกรรมโยธา', child: Text('วิศวกรรมโยธา')),
                    DropdownMenuItem(value: 'วิศวกรรมไฟฟ้า', child: Text('วิศวกรรมไฟฟ้า')),
                    DropdownMenuItem(value: 'วิศวกรรมเครื่องกล', child: Text('วิศวกรรมเครื่องกล')),
                  ]
                : _selectedFaculty == 'คณะวิทยาศาสตร์'
                    ? const [
                        DropdownMenuItem(value: 'คณิตศาสตร์', child: Text('คณิตศาสตร์')),
                        DropdownMenuItem(value: 'ฟิสิกส์', child: Text('ฟิสิกส์')),
                        DropdownMenuItem(value: 'เคมี', child: Text('เคมี')),
                        DropdownMenuItem(value: 'ชีววิทยา', child: Text('ชีววิทยา')),
                      ]
                    : _selectedFaculty == 'คณะเทคโนโลยีสารสนเทศ'
                        ? const [
                            DropdownMenuItem(value: 'วิทยาการคอมพิวเตอร์', child: Text('วิทยาการคอมพิวเตอร์')),
                            DropdownMenuItem(value: 'เทคโนโลยีสารสนเทศ', child: Text('เทคโนโลยีสารสนเทศ')),
                            DropdownMenuItem(value: 'ระบบสารสนเทศ', child: Text('ระบบสารสนเทศ')),
                          ]
                        : _selectedFaculty == 'คณะแพทยศาสตร์'
                            ? const [
                                DropdownMenuItem(value: 'แพทยศาสตร์', child: Text('แพทยศาสตร์')),
                                DropdownMenuItem(value: 'พยาบาลศาสตร์', child: Text('พยาบาลศาสตร์')),
                                DropdownMenuItem(value: 'เทคนิคการแพทย์', child: Text('เทคนิคการแพทย์')),
                              ]
                            : const [
                                DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                              ],
            onChanged: (value) {
              setState(() {
                _selectedMajor = value;
              });
            },
          ),
          const SizedBox(height: 20),
          
          // Curriculum field
          TextFormField(
            controller: _curriculumController,
            decoration: InputDecoration(
              labelText: 'หลักสูตร',
              prefixIcon: const Icon(
                Icons.menu_book_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Department field
          TextFormField(
            controller: _departmentController,
            decoration: InputDecoration(
              labelText: 'ภาควิชา/หน่วยงาน',
              prefixIcon: const Icon(
                Icons.apartment_outlined,
                color: Color(0xFF1976D2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _previousStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ย้อนกลับ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ต่อไป',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Extra padding at bottom
        ],
      ),
    );
  }

  Widget _buildAccountInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'ยืนยันข้อมูล',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        // Password field
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'รหัสผ่าน',
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFF1976D2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
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
        const SizedBox(height: 20),
        
        // Confirm Password field
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'ยืนยันรหัสผ่าน',
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: Color(0xFF1976D2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณายืนยันรหัสผ่าน';
            }
            if (value != _passwordController.text) {
              return 'รหัสผ่านไม่ตรงกัน';
            }
            return null;
          },
        ),
        
        const Spacer(),
        
        // Navigation buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _previousStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'ย้อนกลับ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is RegisterLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : () {
                      if (_validateCurrentStep()) {
                        _submit();
                      } else {
                        Fluttertoast.showToast(
                          msg: "กรุณากรอกข้อมูลให้ครบถ้วน",
                          gravity: ToastGravity.TOP,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'สร้างบัญชี',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.8, -1.0),
                end: Alignment(0.8, 1.0),
                colors: [
                  Color(0xFF1565C0), // Deep Blue
                  Color(0xFF1976D2), // Dark Blue
                  Color(0xFF1E88E5), // Medium Blue
                  Color(0xFF42A5F5), // Light Blue
                  Color(0xFF64B5F6), // Lighter Blue
                ],
                stops: [0.0, 0.2, 0.5, 0.8, 1.0],
              ),
            ),
          ),
          
          // Decorative elements
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 100,
            left: -80,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // Diagonal lines
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: DiagonalLinesPainter(),
          ),
          
          // Main content
          BlocListener<AuthBloc, AuthState>(
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
              child: Column(
                children: [
                  // Header with back button and title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_currentStep > 0) {
                              _previousStep();
                            } else {
                              context.go(Routes.login);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'สร้างบัญชีใหม่',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                  ),
                  
                  // App Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title and subtitle
                  const Text(
                    'เริ่มต้นการใช้งาน',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    'สร้างบัญชีเพื่อเข้าใช้งานแอปพลิเคชัน',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Step indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStepIndicator(0, 'ข้อมูลส่วนตัว'),
                      const SizedBox(width: 40),
                      _buildStepIndicator(1, 'ข้อมูลการศึกษา'),
                      const SizedBox(width: 40),
                      _buildStepIndicator(2, 'ยืนยัน'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Content card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              _currentStep = index;
                            });
                          },
                          children: [
                            _buildPersonalInfoStep(),
                            _buildAcademicInfoStep(),
                            _buildAccountInfoStep(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
