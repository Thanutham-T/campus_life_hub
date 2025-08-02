import 'package:flutter/material.dart';
import '../../../profile/di/profile_di.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800), // เพิ่มเวลาให้นานขึ้น
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic, // ใช้ curve ที่นุ่มนวลกว่า
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Virtual Student Card with flip animation
            GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  // ปรับปรุงการคำนวณ perspective และการพลิก
                  final isShowingFront = _flipAnimation.value < 0.5;
                  final angle = _flipAnimation.value * 3.14159;
                  
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0008) // perspective ที่นุ่มนวลกว่า
                      ..rotateY(angle),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1), // switch ทันที
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
            const SizedBox(height: 24),
            
            // Profile Details
            _buildProfileDetails(),
          ],
        ),
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
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // ลายน้ำ DEV เล็กๆ 5 อัน เฉียงแนวเดียวกัน
          Positioned(
            top: 30,
            left: 40,
            child: Transform.rotate(
              angle: -0.3, // เฉียงแนวเดียวกัน
              child: Opacity(
                opacity: 0.1,
                child: Text(
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
              angle: -0.3, // เฉียงแนวเดียวกัน
              child: Opacity(
                opacity: 0.08,
                child: Text(
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
              angle: -0.3, // เฉียงแนวเดียวกัน
              child: Opacity(
                opacity: 0.1,
                child: Text(
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
          Positioned(
            top: 100,
            right: 30,
            child: Transform.rotate(
              angle: -0.3, // เฉียงแนวเดียวกัน
              child: Opacity(
                opacity: 0.09,
                child: Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 120,
            child: Transform.rotate(
              angle: -0.3, // เฉียงแนวเดียวกัน
              child: Opacity(
                opacity: 0.08,
                child: Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
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
                const SizedBox(height: 10), // ลดระยะห่างจากด้านบน
                
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
                            painter: FullBarcodePainter(), // ใช้ Painter ใหม่
                            size: const Size(250, 70),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // รหัสนักศึกษาใต้บาร์โค้ด
                        Text(
                          ProfileDI.getStudentId(),
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
                
                // ข้อมูลด้านล่าง (ขยายตัวอักษรให้ใหญ่ขึ้น)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // มุมซ้ายล่าง - มหาวิทยาลัยโมบายแอพ
                    Text(
                      'มหาวิทยาลัยโมบายแอพ',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16, // เพิ่มจาก 12 เป็น 16
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // มุมขวาล่าง - DEV
                    Text(
                      'DEV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28, // เพิ่มจาก 20 เป็น 28
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

  Widget _buildVirtualStudentCard() {
    return Container(
      width: double.infinity,
      height: 220, // กลับไปเป็นขนาดเดิม
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF1565C0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              height: 40, // ความสูงของแถบสี
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0), // สีน้ำเงินเข้ม
                borderRadius: const BorderRadius.only(
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
                color: Colors.white.withValues(alpha: 0.1),
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
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // ลายน้ำ DEV บนบัตรด้านหน้า
          Positioned(
            top: 60,
            left: 30,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.08,
                child: Text(
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
            top: 80,
            right: 40,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.06,
                child: Text(
                  'DEV',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 60,
            child: Transform.rotate(
              angle: -0.3,
              child: Opacity(
                opacity: 0.07,
                child: Text(
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
          
          // Card content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20), // ลด padding ด้านบนจาก 20 เป็น 8
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
                const SizedBox(height: 16), // ลดระยะห่าง
                
                // Main content area
                Expanded(
                  flex: 3, // เพิ่ม flex เพื่อให้มีพื้นที่มากขึ้น
                  child: Row(
                    children: [
                      // Left side - Student info
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Thai name (ลบคำนำหน้า)
                            Text(
                              ProfileDI.getUserName().replaceAll(RegExp(r'^(นาย|นาง|นางสาว|Mr\.|Ms\.|Mrs\.)\s*'), ''),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 4),
                            
                            const SizedBox(height: 12),
                            
                            // Student ID
                            Text(
                              ProfileDI.getStudentId(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 12), // เพิ่มระยะห่างระหว่างข้อความกับรูป
                      
                      // Right side - Avatar (เพิ่มความสูงให้ตรงตามภาพ)
                      Container(
                        width: 110,
                        height: 150, // เพิ่มความสูงจาก 130 เป็น 150px
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bottom area - University info
                Container(
                  height: 50, // กำหนดความสูงคงที่เพื่อป้องกัน overflow
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left - DEV logo and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'DEV',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'มหาวิทยาลัยโมบายแอพ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Right - Faculty (เปลี่ยนจากสาขาเป็นคณะ)
                      Text(
                        ProfileDI.getUserFaculty(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('รหัสนักศึกษา', ProfileDI.getStudentId()),
                _buildDetailRow('ชื่อ-นามสกุล', ProfileDI.getUserName()),
                _buildDetailRow('ระดับการศึกษา', 'ไม่พบข้อมูล'),
                _buildDetailRow('วิทยาเขต', 'ไม่พบข้อมูล'),
                _buildDetailRow('คณะ', ProfileDI.getUserFaculty()),
                _buildDetailRow('สาขาวิชา', ProfileDI.getUserDepartment()),
                _buildDetailRow('หลักสูตร', 'ไม่พบข้อมูล', isLast: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

// Custom Painter สำหรับวาดบาร์โค้ด
class BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // สร้างรูปแบบบาร์โค้ดที่มีความหนาแตกต่างกัน
    final List<double> barWidths = [
      1.0, 0.5, 1.5, 2.0, 0.5, 1.0, 0.5, 0.5, 1.5, 2.0,
      0.5, 1.0, 0.5, 1.5, 2.0, 0.5, 0.5, 1.0, 0.5, 1.5,
      2.0, 0.5, 0.5, 1.5, 2.0, 0.5, 1.0, 0.5, 1.5, 0.5,
      0.5, 1.0, 2.0, 0.5, 1.5, 0.5, 0.5, 1.0, 2.0, 0.5,
      1.0, 0.5, 1.5, 2.0, 0.5, 0.5, 1.0, 0.5, 1.5, 2.0,
      1.0, 0.5, 1.5, 0.5, 2.0, 0.5, 1.0, 1.5, 0.5, 1.0,
      0.5, 1.5, 2.0, 0.5, 1.0, 0.5, 0.5, 1.5, 1.0, 2.0,
    ];

    double currentX = 8; // เริ่มจากขอบซ้าย
    final double barHeight = size.height - 16; // ความสูงของแถบ
    
    for (int i = 0; i < barWidths.length && currentX < size.width - 8; i++) {
      final double barWidth = barWidths[i] * 2; // คูณ 2 เพื่อให้เห็นความแตกต่างชัดขึ้น
      
      // วาดแถบสีดำ
      final rect = Rect.fromLTWH(
        currentX,
        8, // เริ่มจากด้านบน
        barWidth,
        barHeight,
      );
      canvas.drawRect(rect, paint);
      
      currentX += barWidth + (0.5 * (i % 3 + 1)); // เว้นระยะที่แตกต่างกัน
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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


