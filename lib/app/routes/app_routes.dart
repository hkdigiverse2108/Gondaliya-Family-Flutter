part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static const family = _Paths.family;
  static const business = _Paths.business;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const chat = _Paths.chat;
  static const announcements = _Paths.announcements;
  static const myBusiness = _Paths.myBusiness;
  static const splash = _Paths.splash;
}

abstract class _Paths {
  _Paths._();

  static const home = '/home';
  static const family = '/family';
  static const business = '/business';
  static const login = '/login';
  static const register = '/register';
  static const chat = '/chat';
  static const announcements = '/announcements';
  static const myBusiness = '/my-business';
  static const splash = '/splash';
}
