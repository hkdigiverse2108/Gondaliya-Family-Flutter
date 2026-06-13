class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String logout = '/auth/logout';

  // User
  static const String userById = '/user/{id}';
  static const String updateUser = '/user/update';
  static const String upload = '/upload';

  // Location
  static const String location = '/location/all';

  // Family
  static const String familyMembers = '/user/family';

  // Business

  static const String business = '/businesses/{id}';
  static const String businessesAll = '/businesses/all';

  // Announcements
  static const String getAnnouncements = '/announcements/all';

  // Notifications
  static const String notificationsAll = '/notifications/all';
  static const String notificationsReadAll = '/notifications/read-all';

  // Chat
  static const String chatRooms = '/chat/all';
  static const String chatDelete = '/chat/{id}';
  static const String addChatMessage = '/chat/add';
  static const String blockUser = '/chat/block';

  // Private Chat
  static const String startPrivateChat = '/private-chat/start';
  static const String privateConversations = '/private-chat/conversations';
  static const String privateMessages = '/private-chat/{id}/messages';
  static const String readPrivateMessages = '/private-chat/{id}/read';
  static const String deletePrivateConversation = '/private-chat/{id}';
  static const String usersAll = '/user/all';

  // Listings
  static const String listingsAll = '/listings/all';
  static const String listing = '/listings/{id}';

  // Parivar
  static const String parivarVillages = '/parivar/villages';
  static const String parivarAll = '/parivar/all';

  // Feedback
  static const String feedback = '/feedback';
  static const String feedbackAdd = '/feedback/add';

  // Inquiry
  static const String inquiry = '/inquiry';

  // Support
  static const String support = '/support';
  static const String supportAll = '/support/all';

  /// Replace {id} placeholder in path
  static String replaceId(String path, String id) =>
      path.replaceFirst('{id}', id);

  /// Paths that do NOT require an Authorization header
  static const List<String> publicPaths = [
    '/auth/login',
    '/auth/signup',
    '/location',
    '/upload',
  ];
}
