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
}
