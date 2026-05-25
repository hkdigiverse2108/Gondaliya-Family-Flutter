import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/announcements/bindings/announcements_binding.dart';
import '../modules/announcements/views/announcements_view.dart';
import '../modules/my_business/bindings/my_business_binding.dart';
import '../modules/my_business/views/my_business_view.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/placeholder_home/bindings/placeholder_home_binding.dart';
import '../modules/placeholder_home/views/placeholder_home_view.dart';

import '../modules/business_detail/bindings/business_detail_binding.dart';
import '../modules/business_detail/views/business_detail_view.dart';
import '../modules/member_detail/bindings/member_detail_binding.dart';
import '../modules/member_detail/views/member_detail_view.dart';
import '../modules/my_family/views/my_family_view.dart';
import '../modules/listing_detail/bindings/listing_detail_binding.dart';
import '../modules/listing_detail/views/listing_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.announcements,
      page: () => const AnnouncementsView(),
      binding: AnnouncementsBinding(),
    ),
    GetPage(
      name: _Paths.myBusiness,
      page: () => const MyBusinessView(),
      binding: MyBusinessBinding(),
    ),
    GetPage(
      name: _Paths.placeholderHome,
      page: () => const PlaceholderHomeView(),
      binding: PlaceholderHomeBinding(),
    ),
    GetPage(
      name: _Paths.business,
      page: () => const BusinessDetailView(),
      binding: BusinessDetailBinding(),
    ),
    GetPage(
      name: _Paths.family,
      page: () => const MemberDetailView(),
      binding: MemberDetailBinding(),
    ),
    GetPage(
      name: _Paths.familyMembers,
      page: () => const MyFamilyView(),
      binding: HomeBinding(), // ProfileController is initialized in HomeBinding
    ),
    GetPage(
      name: _Paths.listingDetail,
      page: () => const ListingDetailView(),
      binding: ListingDetailBinding(),
    ),
  ];
}
