import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyName = 'Name';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setName(String Name) async =>
      await _preferences?.setString(_keyName, Name);

  static String? getName() => _preferences?.getString(_keyName);

  static void erase() async => await _preferences?.clear();
}
