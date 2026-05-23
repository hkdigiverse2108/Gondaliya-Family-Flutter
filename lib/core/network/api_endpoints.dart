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
  static const String getAnnouncements = '/announcements/all';

  // Chat
  static const String chatRooms = '/chat/rooms';
  static const String chatMessages = '/chat/rooms/{id}/messages';

  // Listings
  static const String listings = '/listings';
  static const String listingsAll = '/listings/all';
  static const String listing = '/listings/{id}';

  // Parivar
  static const String parivar = '/parivar';
  static const String parivarVillages = '/parivar/villages';
  static const String parivarAll = '/parivar/all';

  // Feedback
  static const String feedback = '/feedback';

  // Inquiry
  static const String inquiry = '/inquiry';

  // Support
  static const String support = '/support';

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
