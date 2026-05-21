class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String logout = '/auth/logout';

  // User
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String userById = '/user/{id}';

  // Location
  static const String location = '/location';

  // Family
  static const String familyMembers = '/family/members';
  static const String familyMember = '/family/members/{id}';

  // Business
  static const String businesses = '/businesses';
  static const String business = '/businesses/{id}';

  // Announcements
  static const String announcements = '/announcements';

  // Chat
  static const String chatRooms = '/chat/rooms';
  static const String chatMessages = '/chat/rooms/{id}/messages';

  /// Replace {id} placeholder in path
  static String replaceId(String path, String id) =>
      path.replaceFirst('{id}', id);

  /// Paths that do NOT require an Authorization header
  static const List<String> publicPaths = [
    '/auth/login',
    '/auth/signup',
    '/location',
  ];
}
