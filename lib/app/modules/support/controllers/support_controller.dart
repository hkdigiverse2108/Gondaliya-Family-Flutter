import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/support.dart';
import '../../../data/repositories/auth_repository.dart';

class SupportController extends GetxController {
  final _authRepo = AuthRepository();

  final supportInfo = Rxn<Support>();
  final isLoading = false.obs;
  final isSuccess = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSupportInfo();
  }

  Future<void> fetchSupportInfo() async {
    isLoading.value = true;
    isSuccess.value = true;
    try {
      final response = await _authRepo.getSupportInfo();
      if (response.success && response.data != null) {
        supportInfo.value = response.data;
        isSuccess.value = true;
      } else {
        isSuccess.value = false;
      }
    } catch (e) {
      isSuccess.value = false;
      debugPrint('fetchSupportInfo error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('Error', 'Could not initiate call to $phoneNumber');
      }
    } catch (e) {
      debugPrint('makeCall error: $e');
    }
  }

  Future<void> sendEmail(String emailAddress) async {
    final uri = Uri.parse('mailto:$emailAddress?subject=Gondaliya%20Family%20Support');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar('Error', 'Could not open email client');
      }
    } catch (e) {
      debugPrint('sendEmail error: $e');
    }
  }

  Future<void> openMap(String address) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Success
      } else {
        Get.snackbar('Error', 'Could not open maps application');
      }
    } catch (e) {
      debugPrint('openMap error: $e');
    }
  }
}
