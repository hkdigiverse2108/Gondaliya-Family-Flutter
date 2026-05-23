class AppConfig {
  AppConfig._();

  // Replace with your real base URL before release
  // Format: http://<local-ip>:<port>  e.g. http://192.168.29.26:5000
  static const String baseUrl = 'http://192.168.29.26:5000';
  // static const String baseUrl = 'https://api-gondaliya.hkdigiverse.com';

  // Set to true to enable verbose network logs in release builds (use with caution)
  static const bool forceNetworkLogs = false;
}
