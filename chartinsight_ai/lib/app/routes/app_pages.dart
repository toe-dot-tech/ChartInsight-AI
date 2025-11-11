import 'package:get/get.dart';

import '../bindings/upload_binding.dart';
import '../bindings/result_binding.dart';
import '../ui/pages/upload_page.dart';
import '../ui/pages/result_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.UPLOAD;

  static final routes = [
    GetPage(
      name: Routes.UPLOAD,
      page: () => const UploadPage(),
      binding: UploadBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.RESULT,
      page: () => const ResultPage(),
      binding: ResultBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
