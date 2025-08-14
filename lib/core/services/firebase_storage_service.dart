import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _picker = ImagePicker();

  /// เลือกรูปภาพจาก Gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85, // ลดคุณภาพเพื่อประหยัดพื้นที่
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      rethrow;
    }
  }

  /// เลือกรูปภาพจาก Camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      // ถ้า camera ใช้ไม่ได้ (เช่นใน emulator) ให้ fallback เป็น gallery
      print('Camera not available, falling back to gallery...');
      return await pickImageFromGallery();
    }
  }

  /// แสดง Dialog เลือกรูปจาก Gallery หรือ Camera
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'เลือกรูปภาพ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Option
                InkWell(
                  onTap: () async {
                    try {
                      final file = await pickImageFromGallery();
                      if (context.mounted) {
                        Navigator.pop(context, file);
                      }
                    } catch (e) {
                      print('Error picking from gallery: $e');
                      if (context.mounted) {
                        Navigator.pop(context, null);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.photo_library, size: 40, color: Colors.blue),
                        SizedBox(height: 8),
                        Text('แกลเลอรี่'),
                      ],
                    ),
                  ),
                ),
                // Camera Option
                InkWell(
                  onTap: () async {
                    try {
                      final file = await pickImageFromCamera();
                      if (context.mounted) {
                        Navigator.pop(context, file);
                      }
                    } catch (e) {
                      print('Error picking from camera: $e');
                      if (context.mounted) {
                        Navigator.pop(context, null);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text('กล้อง'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('ยกเลิก'),
            ),
          ],
        ),
      ),
    );
  }

  /// อัพโหลดรูปภาพ Event ไป Firebase Storage
  static Future<String?> uploadEventImage(String eventId, File imageFile) async {
    try {
      // ตรวจสอบไฟล์ก่อน
      if (!await imageFile.exists()) {
        throw Exception('ไฟล์รูปภาพไม่พบ');
      }

      // ตรวจสอบขนาดไฟล์ (จำกัดที่ 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('ไฟล์รูปภาพใหญ่เกินไป (เกิน 10MB)');
      }

      // สร้าง path สำหรับเก็บรูป
      final String fileName = 'main_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage
          .ref()
          .child('events')
          .child(eventId)
          .child(fileName);

      print('🔄 Starting upload for event: $eventId');
      
      // อัพโหลดไฟล์
      final UploadTask uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'eventId': eventId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // รอให้การอัพโหลดเสร็จสิ้น
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {
        print('🔄 Upload task completed for event: $eventId');
      });
      
      // ตรวจสอบสถานะการอัพโหลด
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        print('✅ Image uploaded successfully: $downloadUrl');
        return downloadUrl;
      } else {
        throw Exception('การอัพโหลดไม่สำเร็จ: ${snapshot.state}');
      }
      
    } catch (e) {
      print('❌ Error uploading image: $e');
      rethrow;
    }
  }

  /// ลบรูปภาพ Event จาก Firebase Storage
  static Future<bool> deleteEventImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print('✅ Image deleted successfully: $imageUrl');
      return true;
    } catch (e) {
      print('❌ Error deleting image: $e');
      return false;
    }
  }

  /// อัพโหลดรูปพร้อม Progress Callback
  static Future<String?> uploadEventImageWithProgress(
    String eventId,
    File imageFile,
    Function(double progress)? onProgress,
  ) async {
    try {
      final String fileName = 'main_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage
          .ref()
          .child('events')
          .child(eventId)
          .child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);

      // Listen to progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
      
    } catch (e) {
      print('❌ Error uploading image with progress: $e');
      rethrow;
    }
  }
}
