
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/qr_item.dart';

class StorageService {
  static const String _historyKey = 'qr_history';
  static const String _savedKey = 'qr_saved';

  Future<List<QRItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_historyKey) ?? [];

    return items.map((item) {
      return QRItem.fromJson(
        jsonDecode(item) as Map<String, dynamic>,
      );
    }).toList();
  }

  Future<void> saveToHistory(QRItem item) async {
    final history = await getHistory();

    history.removeWhere((existing) => existing.id == item.id);
    history.insert(0, item);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _historyKey,
      history.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  Future<List<QRItem>> getSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(_savedKey) ?? [];

    return items.map((item) {
      return QRItem.fromJson(
        jsonDecode(item) as Map<String, dynamic>,
      );
    }).toList();
  }

  Future<void> toggleSaved(QRItem item) async {
    final saved = await getSaved();
    final alreadySaved = saved.any((existing) => existing.id == item.id);

    if (alreadySaved) {
      saved.removeWhere((existing) => existing.id == item.id);
    } else {
      saved.insert(0, item.copyWith(isSaved: true));
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _savedKey,
      saved.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }

  Future<void> deleteHistoryItem(String id) async {
    final history = await getHistory();
    history.removeWhere((item) => item.id == id);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _historyKey,
      history.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
  
Future<void> removeFromSaved(String id) async {
  final saved = await getSaved();
  saved.removeWhere((item) => item.id == id);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    _savedKey,
    saved.map((item) => jsonEncode(item.toJson())).toList(),
  );
}

Future<void> clearHistory() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_historyKey);
}

Future<bool> isSaved(String id) async {
  final saved = await getSaved();
  return saved.any((item) => item.id == id);
}
}
/* 
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/qr_item.dart';

class StorageService {
  static const String _historyKey = 'qr_studio_history_v1';
  static const String _savedKey = 'qr_studio_saved_v1';

  Future<List<QRItem>> getHistory() async {
    return _readItems(_historyKey);
  }

  Future<List<QRItem>> getSaved() async {
    return _readItems(_savedKey);
  }

  Future<List<QRItem>> _readItems(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final storedData = preferences.getString(key);

    if (storedData == null || storedData.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(storedData) as List<dynamic>;

      return decoded
          .map(
            (item) => QRItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (_) {
      // Avoid crashing the app if stored data is malformed.
      return [];
    }
  }

  Future<void> _writeItems(
    String key,
    List<QRItem> items,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );

    await preferences.setString(key, encoded);
  }

  Future<void> addToHistory(QRItem item) async {
    final history = await getHistory();

    // Move repeated entries to the top instead of duplicating them.
    history.removeWhere((existing) => existing.id == item.id);
    history.insert(0, item);

    // Keep recent history manageable.
    final limitedHistory = history.take(100).toList();

    await _writeItems(_historyKey, limitedHistory);
  }

  Future<void> toggleSaved(QRItem item) async {
    final saved = await getSaved();
    final alreadySaved = saved.any(
      (existing) => existing.id == item.id,
    );

    if (alreadySaved) {
      saved.removeWhere((existing) => existing.id == item.id);
    } else {
      saved.insert(0, item.copyWith(isSaved: true));
    }

    await _writeItems(_savedKey, saved);
  }

  Future<void> removeFromSaved(String id) async {
    final saved = await getSaved();

    saved.removeWhere((item) => item.id == id);

    await _writeItems(_savedKey, saved);
  }

  Future<void> removeFromHistory(String id) async {
    final history = await getHistory();

    history.removeWhere((item) => item.id == id);

    await _writeItems(_historyKey, history);
  }

  Future<void> clearHistory() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_historyKey);
  }

  Future<bool> isSaved(String id) async {
    final saved = await getSaved();

    return saved.any((item) => item.id == id);
  }
}
 */