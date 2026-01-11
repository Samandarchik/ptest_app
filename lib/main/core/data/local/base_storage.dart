abstract class BaseStorage {
  Future<void> putString({required String key, required String value});
  Future<void> putUserInfo({required String key, required Map value});
  String getString({required String key});
  Future<void> remove({required String key});
  Future<void> clear();
  Map getUserInfo({required String key});
}
