import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../data/services/ai_service.dart';
import '../routes/app_routes.dart';

class UploadController extends GetxController {
  final AIService _aiService = Get.find<AIService>();
  final ImagePicker _picker = ImagePicker();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isAnalyzing = false.obs;
  final RxString errorMessage = ''.obs;

  bool get hasImage => selectedImage.value != null;

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick image: $e';
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Capture image from camera
  Future<void> captureImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Failed to capture image: $e';
      Get.snackbar(
        'Error',
        'Failed to capture image from camera',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Clear selected image
  void clearImage() {
    selectedImage.value = null;
    errorMessage.value = '';
  }

  // Analyze the chart
  Future<void> analyzeChart() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'No Image',
        'Please select or capture an image first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isAnalyzing.value = true;
    errorMessage.value = '';

    try {
      final result = await _aiService.analyzeChart(selectedImage.value!);

      // Navigate to results page with the analysis
      Get.toNamed(
        Routes.RESULT,
        arguments: {
          'result': result,
          'image': selectedImage.value,
        },
      );

      // Clear the image for next analysis
      selectedImage.value = null;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Analysis Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isAnalyzing.value = false;
    }
  }
}
