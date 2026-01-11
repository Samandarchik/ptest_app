import 'base_storage.dart';

final class AppStorage {
  static const String _language = 'language';

  final BaseStorage _baseStorage;

  AppStorage(this._baseStorage);

  Future<void> putLanguage(String language) async {
    await _baseStorage.putString(key: _language, value: language);
  }

  String getLanguage() {
    return _baseStorage.getString(key: _language);
  }
}
