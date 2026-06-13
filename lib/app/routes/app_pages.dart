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
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/support/bindings/support_binding.dart';
import '../modules/support/views/support_view.dart';
import '../modules/edit_work/bindings/edit_work_binding.dart';
import '../modules/edit_work/views/edit_work_view.dart';
import '../modules/job_detail/bindings/job_detail_binding.dart';
import '../modules/job_detail/views/job_detail_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/private_messages/bindings/private_messages_binding.dart';
import '../modules/private_messages/views/private_messages_view.dart';
import '../modules/private_messages/views/private_chat_view.dart';
import '../modules/my_family/views/family_member_form_view.dart';
import '../modules/my_businesses/bindings/my_businesses_binding.dart';
import '../modules/my_businesses/views/my_businesses_view.dart';
import '../modules/my_businesses/bindings/edit_business_binding.dart';
import '../modules/my_businesses/views/edit_business_view.dart';
import '../modules/my_listings/bindings/my_listings_binding.dart';
import '../modules/my_listings/views/my_listings_view.dart';
import '../modules/listing_form/bindings/listing_form_binding.dart';
import '../modules/listing_form/views/listing_form_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final List<GetPage<dynamic>> routes = [
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
    GetPage(
      name: _Paths.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.support,
      page: () => const SupportView(),
      binding: SupportBinding(),
    ),
    GetPage(
      name: _Paths.editWork,
      page: () => const EditWorkView(),
      binding: EditWorkBinding(),
    ),
    GetPage(
      name: _Paths.jobDetail,
      page: () => const JobDetailView(),
      binding: JobDetailBinding(),
    ),
    GetPage(
      name: _Paths.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.privateMessages,
      page: () => const PrivateMessagesView(),
      binding: PrivateMessagesBinding(),
    ),
    GetPage(
      name: _Paths.privateChat,
      page: () => const PrivateChatView(),
      binding: PrivateMessagesBinding(),
    ),
    GetPage(
      name: _Paths.addFamilyMember,
      page: () => const FamilyMemberFormView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.myBusinesses,
      page: () => const MyBusinessesView(),
      binding: MyBusinessesBinding(),
    ),
    GetPage(
      name: _Paths.editBusiness,
      page: () => const EditBusinessView(),
      binding: EditBusinessBinding(),
    ),
    GetPage(
      name: _Paths.myListings,
      page: () => const MyListingsView(),
      binding: MyListingsBinding(),
    ),
    GetPage(
      name: _Paths.listingForm,
      page: () => const ListingFormView(),
      binding: ListingFormBinding(),
    ),
  ];
}
