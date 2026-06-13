// extensions/json_map_extension.dart
extension SafeJsonMap on Map<String, dynamic> {
  T getOrDefault<T>(String key, T defaultValue) {
    final value = this[key];
    return value is T ? value : defaultValue;
  }

  T? getOrNull<T>(String key) {
    final value = this[key];
    return value is T ? value : null;
  }

  // Specific helpers for common types
  String getString(String key, [String fallback = '']) =>
      getOrDefault<String>(key, fallback);

  int getInt(String key, [int fallback = 0]) =>
      getOrDefault<int>(key, fallback);

  double getDouble(String key, [double fallback = 0.0]) =>
      getOrDefault<double>(key, fallback);

  bool getBool(String key, [bool fallback = false]) =>
      getOrDefault<bool>(key, fallback);

  List<T> getList<T>(String key) {
    final value = this[key];
    if (value is List) {
      return value.whereType<T>().toList();
    }
    return [];
  }

  Map<String, dynamic> getMap(String key) {
    final value = this[key];
    return value is Map<String, dynamic> ? value : {};
  }
}
