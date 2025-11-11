import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/upload_controller.dart';
import '../widgets/glass_card.dart';
import '../widgets/custom_button.dart';

class UploadPage extends GetView<UploadController> {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            const Color(0xFF0D0D0D), // deep black base
            const Color(0xFF3A0CA3).withOpacity(0.7), // vivid purple accent
            const Color(0xFF7209B7).withOpacity(0.8), // glowing violet tone
            const Color(0xFF0D0D0D), // back to dark
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: SafeArea(
          child: Obx(() => controller.isAnalyzing.value
              ? _buildAnalyzingView()
              : _buildUploadView(context)),
        ),
      ),
    );
  }

  Widget _buildAnalyzingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use a simple loading animation instead of Lottie if asset is missing
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated circles
                ...List.generate(3, (index) {
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 1500 + (index * 200)),
                    builder: (context, double value, child) {
                      return Container(
                        width: 60 + (value * 60 * (index + 1)),
                        height: 60 + (value * 60 * (index + 1)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                const Color(0xFF7D3C98).withOpacity(1 - value),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  );
                }),
                // Center icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7D3C98),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7D3C98).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Analyzing Chart...',
            style: Get.textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            'AI is processing your chart',
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              backgroundColor: Color(0xFF1E1E1E),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7D3C98)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7D3C98).withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7D3C98).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_graph,
                    size: 50,
                    color: Color(0xFF7D3C98),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'AI Chart Analyzer 📊',
                  style: Get.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  'Upload your crypto or gold chart\nAI will suggest a trading bias',
                  style: Get.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Image Preview or Upload Area
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.hasImage
                    ? _buildImagePreview()
                    : _buildUploadButtons(),
              )),

          const SizedBox(height: 30),

          // Analyze Button
          Obx(() => CustomButton(
                text: 'Analyze Now',
                icon: Icons.psychology,
                onPressed: controller.analyzeChart,
                isEnabled: controller.hasImage,
              )),

          const SizedBox(height: 20),

          // Error Message
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildUploadButtons() {
    return GlassCard(
      key: const ValueKey('upload'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 80,
            color: Color(0xFF7D3C98),
          ),
          const SizedBox(height: 24),
          Text(
            'Choose Upload Method',
            style: Get.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildOptionButton(
            icon: Icons.photo_library,
            label: 'Upload from Gallery',
            onTap: controller.pickImageFromGallery,
          ),
          const SizedBox(height: 16),
          _buildOptionButton(
            icon: Icons.camera_alt,
            label: 'Capture with Camera',
            onTap: controller.captureImageFromCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return GlassCard(
      key: const ValueKey('preview'),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chart Preview',
                style: Get.textTheme.displaySmall,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: controller.clearImage,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              controller.selectedImage.value!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 55, 20, 70).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 79, 32, 98).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color.fromARGB(255, 65, 32, 80)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Get.textTheme.bodyLarge,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF7D3C98),
            ),
          ],
        ),
      ),
    );
  }
}
