import 'dart:convert';

import 'package:ptest/main/core/data/local/base_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPreferencesImpl implements BaseStorage {
  final SharedPreferences _pref;

  SharedPreferencesImpl(this._pref);

  @override
  Future<void> clear() async {
    await _pref.clear();
  }

  @override
  String getString({required String key}) {
    return _pref.getString(key) ?? '';
  }

  @override
  Future<void> putString({required String key, required String value}) async {
    await _pref.setString(key, value);
  }

  @override
  Future<void> remove({required String key}) async {
    await _pref.remove(key);
  }

  @override
  Map getUserInfo({required String key}) {
    return jsonDecode(getString(key: key));
  }

  @override
  Future<void> putUserInfo({required String key, required Map value}) async {
    await _pref.setString(key, jsonEncode(value));
  }
}
