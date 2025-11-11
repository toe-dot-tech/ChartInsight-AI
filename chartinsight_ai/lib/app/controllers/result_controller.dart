import 'dart:io';
import 'package:get/get.dart';
import '../data/models/analysis_result.dart';
import '../routes/app_routes.dart';

class ResultController extends GetxController {
  late final AnalysisResult result;
  late final File chartImage;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;
    result = args['result'] as AnalysisResult;
    chartImage = args['image'] as File;
  }

  void tryAnotherChart() {
    Get.offAllNamed(Routes.UPLOAD);
  }

  String getBiasColor() {
    switch (result.suggestedTrade.bias.toUpperCase()) {
      case 'BUY':
        return '#00E676';
      case 'SELL':
        return '#FF1744';
      default:
        return '#FFB300';
    }
  }

  String getBiasEmoji() {
    switch (result.suggestedTrade.bias.toUpperCase()) {
      case 'BUY':
        return '📈';
      case 'SELL':
        return '📉';
      default:
        return '⏸️';
    }
  }
}
