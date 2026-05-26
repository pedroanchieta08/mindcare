import 'package:flutter/foundation.dart';

class SentimentStore extends ChangeNotifier {
  SentimentStore._internal();
  static final SentimentStore _instance = SentimentStore._internal();
  factory SentimentStore() => _instance;

  final Map<String, String> _data = {};

  String _key(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  void save(DateTime date, String emoji) {
    _data[_key(date)] = emoji;
    notifyListeners();
  }

  String? get(DateTime date) => _data[_key(date)];

  Map<String, String> all() => Map.from(_data);
}
