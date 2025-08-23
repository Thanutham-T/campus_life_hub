import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// อัปโหลดรูปโปรไฟล์ไปยัง Firebase Storage
  Future<String?> uploadProfileImage({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      final String fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('users/$userId/$fileName');
      
      // สร้าง metadata สำหรับไฟล์
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // อัปโหลดไฟล์
      final UploadTask uploadTask = ref.putFile(
        File(imageFile.path),
        metadata,
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      Fluttertoast.showToast(
        msg: 'เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  }

  /// เลือกรูปจาก Gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      print('Error picking image from gallery: $e');
      Fluttertoast.showToast(
        msg: 'เกิดข้อผิดพลาดในการเลือกรูปภาพ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  }

  /// เลือกรูปจาก Camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      print('Error picking image from camera: $e');
      Fluttertoast.showToast(
        msg: 'เกิดข้อผิดพลาดในการถ่ายรูป',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return null;
    }
  }

  /// แสดง dialog เลือกแหล่งที่มารูปภาพ
  void showImageSourceDialog(BuildContext context, Function(XFile) onImageSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกรูปโปรไฟล์'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากแกลเลอรี่'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await pickImageFromGallery();
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('ถ่ายรูปใหม่'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await pickImageFromCamera();
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// ลบรูปโปรไฟล์เก่าจาก Firebase Storage
  Future<void> deleteOldProfileImage(String imageUrl) async {
    try {
      if (imageUrl.contains('firebase')) {
        final Reference ref = _storage.refFromURL(imageUrl);
        await ref.delete();
      }
    } catch (e) {
      print('Error deleting old profile image: $e');
      // ไม่แสดง error เพราะไม่ใช่เรื่องสำคัญ
    }
  }
}
