import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/interfaces/local.repository.interface.dart';

class LocalRepository extends GetxService implements ILocalRepository {
  LocalRepository();

  late SharedPreferences _preferences;

  Future<LocalRepository> init() async {
    _preferences = await SharedPreferences.getInstance();
    return this;
  }

  @override
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

  @override
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

  @override
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  @override
  Future<bool> removeAll() async {
    return await _preferences.clear();
  }
}
