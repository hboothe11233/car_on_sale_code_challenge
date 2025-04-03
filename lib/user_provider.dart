import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    notifyListeners();
  }

  Future<void> setUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    _userId = userId;
    await prefs.setString('userId', userId);
    notifyListeners();
  }

  /// Clears the stored user data and resets the internal user state.
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _userId = null;
    notifyListeners();
  }
}
