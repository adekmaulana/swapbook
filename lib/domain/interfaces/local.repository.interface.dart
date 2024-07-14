abstract class ILocalRepository {
  Future<void> put(String key, dynamic value);
  Future<dynamic> get<T>(String key, dynamic defaultValue);
  Future<bool> remove(String key);
  Future<bool> removeAll();
}
