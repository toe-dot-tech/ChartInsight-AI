import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/result_controller.dart';
import '../widgets/analysis_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';

class ResultPage extends GetView<ResultController> {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildChartPreview(),
                      const SizedBox(height: 24),
                      _buildTradeSignal(),
                      const SizedBox(height: 24),
                      _buildAnalysisSection(),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Try Another Chart',
                        icon: Icons.refresh,
                        onPressed: controller.tryAnotherChart,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: controller.tryAnotherChart,
          ),
          const SizedBox(width: 8),
          Text(
            'AI Analysis Result 🤖',
            style: Get.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildChartPreview() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyzed Chart',
            style: Get.textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              controller.chartImage,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeSignal() {
    final bias = controller.result.suggestedTrade.bias.toUpperCase();
    Color signalColor;

    switch (bias) {
      case 'BUY':
        signalColor = const Color(0xFF00E676);
        break;
      case 'SELL':
        signalColor = const Color(0xFFFF1744);
        break;
      default:
        signalColor = const Color(0xFFFFB300);
    }

    return GlassCard(
      color: signalColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.getBiasEmoji(),
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Signal',
                    style: Get.textTheme.bodyMedium,
                  ),
                  Text(
                    bias,
                    style: Get.textTheme.displayMedium?.copyWith(
                      color: signalColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildTradeRow('Entry', controller.result.suggestedTrade.entry),
                const Divider(height: 24, color: Colors.white24),
                _buildTradeRow(
                    'Stop Loss', controller.result.suggestedTrade.stopLoss),
                const Divider(height: 24, color: Colors.white24),
                _buildTradeRow(
                    'Take Profit', controller.result.suggestedTrade.takeProfit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium,
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analysis',
          style: Get.textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        AnalysisCard(
          title: 'Asset',
          value: controller.result.asset,
          icon: Icons.currency_bitcoin,
          iconColor: const Color(0xFFFFC107),
        ),
        const SizedBox(height: 12),
        AnalysisCard(
          title: 'Timeframe',
          value: controller.result.timeframe,
          icon: Icons.access_time,
          iconColor: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 12),
        AnalysisCard(
          title: 'Trend Direction',
          value: controller.result.trend,
          icon: Icons.trending_up,
          iconColor: const Color(0xFF00E676),
        ),
        const SizedBox(height: 12),
        AnalysisCard(
          title: 'Support Zone',
          value: controller.result.support,
          icon: Icons.arrow_downward,
          iconColor: const Color(0xFF00E676),
        ),
        const SizedBox(height: 12),
        AnalysisCard(
          title: 'Resistance Zone',
          value: controller.result.resistance,
          icon: Icons.arrow_upward,
          iconColor: const Color(0xFFFF1744),
        ),
        const SizedBox(height: 12),
        AnalysisCard(
          title: 'Pattern / Setup',
          value: controller.result.pattern,
          icon: Icons.show_chart,
          iconColor: const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 12),
        AnalysisCard(
          title: 'Risks & Considerations',
          value: controller.result.risks,
          icon: Icons.warning_amber,
          iconColor: const Color(0xFFFF9800),
        ),
      ],
    );
  }
}
