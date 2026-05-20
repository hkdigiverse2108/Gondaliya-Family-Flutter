import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';

class AuthService extends GetxService {
  final GetStorage _box = GetStorage();

  static const String _currentUserKey = 'active_user_session';
  static const String _registeredUsersKey = 'all_registered_users';

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  bool get isLoggedIn => currentUser.value != null;

  /// Initialize Auth state from storage
  Future<AuthService> init() async {
    final rawUser = _box.read<Map<String, dynamic>>(_currentUserKey);
    if (rawUser != null) {
      currentUser.value = UserModel.fromJson(rawUser);
    }
    return this;
  }

  /// Register a new user profile
  Future<bool> register(UserModel user) async {
    // Read all users
    final allUsers = _getRegisteredUsers();
    
    // Check if phone number is already registered
    if (allUsers.containsKey(user.phoneNumber)) {
      return false; // Already exists
    }

    // Add new user
    allUsers[user.phoneNumber] = user;
    await _saveRegisteredUsers(allUsers);

    // Set active session
    currentUser.value = user;
    await _box.write(_currentUserKey, user.toJson());
    return true;
  }

  /// Authenticate with phone & password
  Future<bool> login(String phoneNumber, String password) async {
    final allUsers = _getRegisteredUsers();
    
    if (!allUsers.containsKey(phoneNumber)) {
      return false; // User not found
    }

    final user = allUsers[phoneNumber]!;
    if (user.password != password) {
      return false; // Password incorrect
    }

    // Set active session
    currentUser.value = user;
    await _box.write(_currentUserKey, user.toJson());
    return true;
  }

  /// Terminate active session
  Future<void> logout() async {
    currentUser.value = null;
    await _box.remove(_currentUserKey);
  }

  /// Update the current user profile (e.g. adding a family member)
  Future<void> updateCurrentUser(UserModel updatedUser) async {
    currentUser.value = updatedUser;
    await _box.write(_currentUserKey, updatedUser.toJson());

    // Update in registered list
    final allUsers = _getRegisteredUsers();
    allUsers[updatedUser.phoneNumber] = updatedUser;
    await _saveRegisteredUsers(allUsers);
  }

  // --- Helper Methods ---

  Map<String, UserModel> _getRegisteredUsers() {
    final rawList = _box.read<List<dynamic>>(_registeredUsersKey) ?? [];
    final Map<String, UserModel> usersMap = {};
    for (var item in rawList) {
      final user = UserModel.fromJson(Map<String, dynamic>.from(item));
      usersMap[user.phoneNumber] = user;
    }
    return usersMap;
  }

  Future<void> _saveRegisteredUsers(Map<String, UserModel> usersMap) async {
    final rawList = usersMap.values.map((e) => e.toJson()).toList();
    await _box.write(_registeredUsersKey, rawList);
  }
}
