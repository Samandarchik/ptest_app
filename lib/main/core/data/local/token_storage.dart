import 'base_storage.dart';

final class TokenStorage {
  static const String _token = 'access_token';
  static const String _refreshToken = 'refresh_token';
  static const String _userInfo = 'user_info';

  final BaseStorage _baseStorage;

  TokenStorage(this._baseStorage);

  Future<void> putToken(String token) async {
    await _baseStorage.putString(key: _token, value: token);
  }

  Future<void> putUserInfo(Map userInfo) async {
    await _baseStorage.putUserInfo(key: _userInfo, value: userInfo);
  }

  String getToken() {
    return _baseStorage.getString(key: _token);
  }

  String getUserInofo() {
    return _baseStorage.getString(key: _userInfo);
  }

  Future<void> removeToken() async {
    await _baseStorage.remove(key: _token);
  }

  Future<void> removeRefreshToken() async {
    await _baseStorage.remove(key: _refreshToken);
  }
}
