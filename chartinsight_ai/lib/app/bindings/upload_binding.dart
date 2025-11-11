import 'package:get/get.dart';
import '../controllers/upload_controller.dart';
import '../data/services/ai_service.dart';

class UploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AIService>(() => AIService());
    Get.lazyPut<UploadController>(() => UploadController());
  }
}
