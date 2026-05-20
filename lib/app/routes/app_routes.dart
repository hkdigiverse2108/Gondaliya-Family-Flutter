part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const FAMILY = _Paths.FAMILY;
  static const BUSINESS = _Paths.BUSINESS;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const FAMILY = '/family';
  static const BUSINESS = '/business';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
}
