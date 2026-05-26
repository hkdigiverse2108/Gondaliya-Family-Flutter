import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  static const String _themeKey = 'is_dark_mode';
  static const String _authTokenKey = 'authToken';
  static const String _userKey = 'user_data';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // --- Theme ---
  bool get isDarkMode => _box.read<bool>(_themeKey) ?? false;
  void saveThemeMode(bool isDark) => _box.write(_themeKey, isDark);

  // --- Auth Token ---
  String? get authToken => _box.read<String>(_authTokenKey);
  Future<void> saveAuthToken(String token) async =>
      await _box.write(_authTokenKey, token);
  Future<void> clearAuthToken() async => await _box.remove(_authTokenKey);

  // --- User Data ---
  UserModel? get currentUser {
    final userData = _box.read<Map<String, dynamic>>(_userKey);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async =>
      await _box.write(_userKey, user.toJson());
  Future<void> clearUser() async => await _box.remove(_userKey);

  // --- Daily Chat Limit ---
  String _getDailyChatLimitKey(String userId) {
    final now = DateTime.now();
    return 'chat_limit_${userId}_${now.year}_${now.month}_${now.day}';
  }

  int getDailyChatCount(String userId) {
    if (userId.isEmpty) return 0;
    return _box.read<int>(_getDailyChatLimitKey(userId)) ?? 0;
  }

  Future<void> incrementDailyChatCount(String userId) async {
    if (userId.isEmpty) return;
    final key = _getDailyChatLimitKey(userId);
    final current = _box.read<int>(key) ?? 0;
    await _box.write(key, current + 1);
  }
}
