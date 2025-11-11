import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/analysis_result.dart';

class AIService {
  final Dio _dio = Dio();

  String get _apiKey => 'YOUR-API-KEY';

  Future<AnalysisResult> analyzeChart(File imageFile) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception('API key not found. Please configure your key.');
      }

      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // ✅ CORRECT & UPDATED endpoint (use v1 instead of v1beta)

      final url =
          'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$_apiKey';

      debugPrint('🔄 Calling Gemini API: $url');

      final prompt = '''
You are an expert trading analyst. Analyze this trading chart image carefully.

Respond with ONLY valid JSON in this exact format (no markdown, no extra text):
{
  "asset": "detected asset name (e.g., BTC/USD, Gold, EUR/USD)",
  "timeframe": "detected timeframe (e.g., 1H, 4H, Daily)",
  "trend": "current trend direction (Bullish/Bearish/Neutral)",
  "support": "key support level(s)",
  "resistance": "key resistance level(s)",
  "pattern": "detected chart pattern or setup",
  "suggested_trade": {
    "bias": "BUY or SELL or HOLD",
    "entry": "suggested entry price/zone",
    "stop_loss": "suggested stop loss level",
    "take_profit": "suggested take profit level"
  },
  "risks": "key risks or considerations",
  "disclaimer": "This analysis is for educational purposes only and not financial advice."
}

Be specific, concise, and realistic. If you cannot determine something, use "Unknown" or "N/A".
''';

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image,
                }
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.4,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 2048,
        }
      };

      debugPrint('📤 Sending request...');

      // Make API call
      final response = await _dio.post(
        url,
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('✅ Success! Parsing response...');

        final candidates = response.data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No response from AI model');
        }

        final content = candidates.first['content'];
        final parts = content['parts'] as List;
        final textResponse = parts.first['text'] as String;

        debugPrint('📄 Raw AI response: $textResponse');

        // Clean markdown if Gemini returns ```json blocks
        String cleanedResponse = textResponse.trim();
        if (cleanedResponse.startsWith('```json')) {
          cleanedResponse =
              cleanedResponse.replaceAll(RegExp(r'^```json|```$'), '').trim();
        } else if (cleanedResponse.startsWith('```')) {
          cleanedResponse =
              cleanedResponse.replaceAll(RegExp(r'^```|```$'), '').trim();
        }

        debugPrint('🧹 Cleaned response: $cleanedResponse');

        final Map<String, dynamic> analysisData = json.decode(cleanedResponse);
        return AnalysisResult.fromJson(analysisData);
      } else {
        debugPrint('❌ API Error: ${response.statusCode}');
        debugPrint('Error details: ${response.data}');
        throw Exception('API Error: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Network error: ${e.message}');
      if (e.response != null) {
        debugPrint('Response data: ${e.response?.data}');
        throw Exception(
            'Network error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        throw Exception('Connection error: ${e.message}');
      }
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');
      throw Exception('Analysis failed: $e');
    }
  }
}
