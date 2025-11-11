class AnalysisResult {
  final String asset;
  final String timeframe;
  final String trend;
  final String support;
  final String resistance;
  final String pattern;
  final SuggestedTrade suggestedTrade;
  final String risks;
  final String disclaimer;

  AnalysisResult({
    required this.asset,
    required this.timeframe,
    required this.trend,
    required this.support,
    required this.resistance,
    required this.pattern,
    required this.suggestedTrade,
    required this.risks,
    required this.disclaimer,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      asset: json['asset'] ?? 'Unknown',
      timeframe: json['timeframe'] ?? 'Unknown',
      trend: json['trend'] ?? 'Unknown',
      support: json['support'] ?? 'N/A',
      resistance: json['resistance'] ?? 'N/A',
      pattern: json['pattern'] ?? 'No pattern detected',
      suggestedTrade: SuggestedTrade.fromJson(json['suggested_trade'] ?? {}),
      risks: json['risks'] ?? 'Unknown risks',
      disclaimer: json['disclaimer'] ??
          'This is for educational purposes only. Not financial advice.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset': asset,
      'timeframe': timeframe,
      'trend': trend,
      'support': support,
      'resistance': resistance,
      'pattern': pattern,
      'suggested_trade': suggestedTrade.toJson(),
      'risks': risks,
      'disclaimer': disclaimer,
    };
  }
}

class SuggestedTrade {
  final String bias;
  final String entry;
  final String stopLoss;
  final String takeProfit;

  SuggestedTrade({
    required this.bias,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
  });

  factory SuggestedTrade.fromJson(Map<String, dynamic> json) {
    return SuggestedTrade(
      bias: json['bias'] ?? 'HOLD',
      entry: json['entry'] ?? 'N/A',
      stopLoss: json['stop_loss'] ?? 'N/A',
      takeProfit: json['take_profit'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bias': bias,
      'entry': entry,
      'stop_loss': stopLoss,
      'take_profit': takeProfit,
    };
  }
}
