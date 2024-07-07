import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepository extends GetxService {
  LocalRepository();

  late SharedPreferences _preferences;

  Future<LocalRepository> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> put(String key, dynamic value) async {
    if (value is String) {
      _preferences.setString(key, value);
    } else if (value is bool) {
      _preferences.setBool(key, value);
    } else if (value is int) {
      _preferences.setInt(key, value);
    } else if (value is double) {
      _preferences.setDouble(key, value);
    } else if (value is List<String>) {
      _preferences.setStringList(key, value);
    }
  }

  Future<dynamic> get<T>(String key, dynamic defaultValue) async {
    if (defaultValue is String) {
      return _preferences.getString(key) ?? defaultValue;
    } else if (defaultValue is bool) {
      return _preferences.getBool(key) ?? defaultValue;
    } else if (defaultValue is int) {
      return _preferences.getInt(key) ?? defaultValue;
    } else if (defaultValue is double) {
      return _preferences.getDouble(key) ?? defaultValue;
    } else if (defaultValue is List<String>) {
      return _preferences.getStringList(key) ?? defaultValue;
    }
  }

  remove(String key) async {
    return _preferences.remove(key);
  }

  removeAll() async {
    return _preferences.clear();
  }
}
