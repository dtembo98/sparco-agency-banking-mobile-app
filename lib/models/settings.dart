import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ViewState { idle, busy }

class Settings extends ChangeNotifier {
  final String prefThemeKey = "theme";
  final String prefReqAuthKey = "reqAuth";
  SharedPreferences prefs;
  bool _darkTheme;
  bool _reqAuth;

  bool get isDarkTheme => _darkTheme;
  bool get reqAuth => _reqAuth;

  Settings() {
    _darkTheme = false;
    _reqAuth = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  toggleAuthReq() {
    _reqAuth = !_reqAuth;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(prefThemeKey) ?? true;
    _reqAuth = prefs.getBool(prefThemeKey) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(prefThemeKey, _darkTheme);
    prefs.setBool(prefReqAuthKey, _reqAuth);
  }
}
