part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static const family = _Paths.family;
  static const business = _Paths.business;
  static const familyMembers = _Paths.familyMembers;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const chat = _Paths.chat;
  static const announcements = _Paths.announcements;
  static const myBusiness = _Paths.myBusiness;
  static const splash = _Paths.splash;
  static const placeholderHome = _Paths.placeholderHome;
  static const listingDetail = _Paths.listingDetail;
  static const editProfile = _Paths.editProfile;
  static const support = _Paths.support;
  static const editWork = _Paths.editWork;
  static const jobDetail = _Paths.jobDetail;
  static const notifications = _Paths.notifications;
  static const privateMessages = _Paths.privateMessages;
  static const privateChat = _Paths.privateChat;
  static const addFamilyMember = _Paths.addFamilyMember;
}

abstract class _Paths {
  _Paths._();

  static const home = '/home';
  static const family = '/family';
  static const business = '/business';
  static const familyMembers = '/family-members';
  static const login = '/login';
  static const register = '/register';
  static const chat = '/chat';
  static const announcements = '/announcements';
  static const myBusiness = '/my-business';
  static const splash = '/splash';
  static const placeholderHome = '/placeholder-home';
  static const listingDetail = '/listing-detail';
  static const editProfile = '/edit-profile';
  static const support = '/support';
  static const editWork = '/edit-work';
  static const jobDetail = '/job-detail';
  static const notifications = '/notifications';
  static const privateMessages = '/private-messages';
  static const privateChat = '/private-chat/:conversationId';
  static const addFamilyMember = '/add-family-member';
}
