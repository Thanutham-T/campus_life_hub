import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/profile_image_service.dart';
import '../../../user/domain/entities/profile_entity.dart';
import '../../../user/presentation/bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/auth_event.dart';

class VirtualStudentCard extends StatefulWidget {
  final ProfileEntity profile;

  const VirtualStudentCard({
    super.key,
    required this.profile,
  });

  @override
  State<VirtualStudentCard> createState() => _VirtualStudentCardState();
}

class _VirtualStudentCardState extends State<VirtualStudentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showImageUploadDialog(BuildContext context) {
    final profileImageService = ProfileImageService();
    
    profileImageService.showImageSourceDialog(context, (imageFile) async {
      // Show loading state
      context.read<AuthBloc>().add(ProfileImageUploadRequested(imagePath: imageFile.path));
    });
  }

  void _flipCard() {
    if (!_isFlipped) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _flipCard,
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final isShowingFront = _flipAnimation.value < 0.5;
            final angle = _flipAnimation.value * 3.14159;
            
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008)
                ..rotateY(angle),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1),
                child: isShowingFront
                    ? _buildVirtualStudentCard()
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: _buildVirtualStudentCardBack(),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVirtualStudentCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF1565C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // แถบสีน้ำเงินเข้มด้านบน
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1565C0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
          ),
          
          // Background pattern
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // ลายน้ำ DEV
          Positioned(
            top: 60,
            left: 30,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.08,
                child: const Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Card content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Virtual Student Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Main content area
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      // Left side - Student info
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Thai name 
                            Text(
                              _getFullDisplayName(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            
                            // Student ID
                            Text(
                              _getDisplayValue(widget.profile.studentId, 'ไม่มีรหัสนักศึกษา'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Faculty/Department
                            Text(
                              widget.profile.faculty.isNotEmpty 
                                  ? widget.profile.faculty 
                                  : _getDisplayValue(widget.profile.department, 'ไม่ระบุคณะ'),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Right side - Avatar
                      GestureDetector(
                        onTap: () => _showImageUploadDialog(context),
                        child: Container(
                          width: 110,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              // Profile Image
                              widget.profile.profileImageUrl != null && 
                                     widget.profile.profileImageUrl!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.profile.profileImageUrl!,
                                      width: 110,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.grey[600],
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[600],
                                  ),
                              
                              // Camera icon overlay
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom area - University info
                SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left - DEV logo
                      const Text(
                        'DEV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      // Right - มหาวิทยาลัยโมบายแอพ
                      Text(
                        'มหาวิทยาลัยโมบายแอพ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualStudentCardBack() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF1565C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // ลายน้ำ DEV เล็กๆ หลายอัน
          Positioned(
            top: 30,
            left: 40,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.1,
                child: const Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 60,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.08,
                child: const Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.1,
                child: const Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // เนื้อหาด้านหลัง
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // บาร์โค้ด
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // บาร์โค้ดเต็มแถบสีขาว
                        Container(
                          width: 250,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomPaint(
                            painter: FullBarcodePainter(),
                            size: const Size(250, 70),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // รหัสนักศึกษาใต้บาร์โค้ด
                        Text(
                          _getDisplayValue(widget.profile.studentId, 'ไม่มีรหัสนักศึกษา'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // ข้อมูลด้านล่าง
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // มุมซ้ายล่าง - มหาวิทยาลัยโมบายแอพ
                    Text(
                      'มหาวิทยาลัยโมบายแอพ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // มุมขวาล่าง - DEV
                    const Text(
                      'DEV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayValue(String? value, String defaultValue) {
    if (value == null || value.trim().isEmpty || value.toLowerCase().trim() == 'null') {
      return defaultValue;
    }
    return value.trim();
  }

  String _getFullDisplayName() {
    final firstName = _getDisplayValue(widget.profile.firstName, '');
    final lastName = _getDisplayValue(widget.profile.lastName, '');
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    }
    
    if (firstName.isNotEmpty) {
      return firstName;
    }
    
    if (lastName.isNotEmpty) {
      return lastName;
    }
    
    return 'ไม่มีชื่อ';
  }
}

// Custom Painter สำหรับวาดบาร์โค้ดเต็มแถบ
class FullBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // สร้างรูปแบบบาร์โค้ดที่กระจายเต็มพื้นที่และไม่ถี่เกินไป
    final List<double> barWidths = [
      2.0, 1.0, 3.0, 1.5, 2.5, 1.0, 3.5, 2.0, 1.5, 3.0,
      1.0, 2.5, 3.0, 1.5, 2.0, 3.5, 1.0, 2.5, 3.0, 1.5,
      2.0, 1.0, 3.5, 2.5, 1.5, 3.0, 2.0, 1.0, 2.5, 3.0,
      1.5, 2.0, 3.5, 1.0, 2.5, 3.0, 1.5, 2.0, 3.5, 1.0,
      2.5, 3.0, 1.5, 2.0, 3.5, 1.0, 2.5, 3.0, 2.0, 1.5,
    ];

    double currentX = 6; // เริ่มใกล้ขอบซ้าย
    final double barHeight = size.height - 12; // ใช้พื้นที่เกือบเต็ม
    final double totalWidth = size.width - 12; // พื้นที่ที่ใช้ได้
    
    // คำนวณ scale เพื่อให้บาร์โค้ดเต็มพื้นที่
    double totalBarWidth = 0;
    for (double width in barWidths) {
      totalBarWidth += width * 2.5 + 1.5; // รวมความกว้างและช่องว่าง
    }
    double scale = totalWidth / totalBarWidth;
    
    for (int i = 0; i < barWidths.length && currentX < size.width - 8; i++) {
      final double barWidth = barWidths[i] * 2.5 * scale;
      
      // วาดแถบสีดำ
      final rect = Rect.fromLTWH(
        currentX,
        6, // เริ่มใกล้ด้านบน
        barWidth,
        barHeight,
      );
      canvas.drawRect(rect, paint);
      
      currentX += barWidth + (1.5 * scale); // เว้นระยะสม่ำเสมอ
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
