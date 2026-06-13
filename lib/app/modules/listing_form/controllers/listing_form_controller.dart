import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/network/api_service.dart';
import '../../../data/models/listing.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../home/home_repository.dart';
import '../../my_listings/controllers/my_listings_controller.dart';
import '../../home/controllers/marketplace_controller.dart';

class ListingFormController extends GetxController {
  final HomeRepository _homeRepo = HomeRepository(Get.find<DioApiService>());
  final AuthRepository _authRepo = AuthRepository();

  final formKey = GlobalKey<FormState>();

  final isEditMode = false.obs;
  Listing? existingListing;

  final isLoading = false.obs;

  // Form Fields
  final type = 'SALE'.obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final priceUnit = 'FIXED'.obs;
  
  final availableFrom = DateTime.now().obs;
  final availableTo = Rxn<DateTime>();

  final cityController = TextEditingController();
  final pincodeController = TextEditingController();
  final phoneController = TextEditingController();

  final status = 'ACTIVE'.obs;

  // Photos
  final existingPhotos = <String>[].obs;
  final newPhotoPaths = <String>[].obs;

  final typeOptions = ['SALE', 'RENT', 'LEASE', 'SERVICE', 'WANTED'];
  final statusOptions = ['ACTIVE', 'SOLD', 'RENTED', 'INACTIVE'];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['listing'] != null) {
      existingListing = args['listing'] as Listing;
      isEditMode.value = true;
      _populateForm(existingListing!);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _populateForm(Listing listing) {
    type.value = listing.type;
    titleController.text = listing.title;
    descriptionController.text = listing.description;
    priceController.text = listing.price.toString();
    priceUnit.value = listing.priceUnit;
    availableFrom.value = listing.availableFrom;
    availableTo.value = listing.availableTo;
    cityController.text = listing.location.city;
    pincodeController.text = listing.location.pincode;
    phoneController.text = listing.contactPhone;
    status.value = listing.status;
    if (listing.photos != null) {
      existingPhotos.assignAll(listing.photos!);
    }
  }

  void pickDate(BuildContext context, {required bool isFromDate}) async {
    final initialDate = isFromDate ? availableFrom.value : (availableTo.value ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isFromDate) {
        availableFrom.value = picked;
      } else {
        availableTo.value = picked;
      }
    }
  }

  Future<void> pickPhotos() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        allowMultiple: true,
      );

      if (result != null && result.paths.isNotEmpty) {
        final paths = result.paths.whereType<String>().toList();
        newPhotoPaths.addAll(paths);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images');
    }
  }

  void removeNewPhoto(int index) {
    newPhotoPaths.removeAt(index);
  }

  void removeExistingPhoto(int index) {
    existingPhotos.removeAt(index);
  }

  Future<void> saveListing() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final uploadedUrls = <String>[];
      
      // Upload new photos one by one
      for (final path in newPhotoPaths) {
        final uploadResp = await _authRepo.uploadFile(filePath: path);
        if (uploadResp.success && uploadResp.data != null) {
          uploadedUrls.add(uploadResp.data!['url'] as String);
        }
      }

      final allPhotos = [...existingPhotos, ...uploadedUrls];

      final payload = {
        'type': type.value,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'photos': allPhotos,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'priceUnit': priceUnit.value,
        'availableFrom': availableFrom.value.toIso8601String(),
        'availableTo': availableTo.value?.toIso8601String(),
        'location': {
          'city': cityController.text.trim(),
          'pincode': pincodeController.text.trim(),
        },
        'contactPhone': phoneController.text.trim(),
        'status': status.value,
      };

      bool success;
      if (isEditMode.value && existingListing != null) {
        success = await _homeRepo.updateListing(existingListing!.id, payload);
      } else {
        success = await _homeRepo.createListing(payload);
      }

      if (success) {
        Get.snackbar(
          'Success', 
          'Listing ${isEditMode.value ? 'updated' : 'created'} successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Refresh listings
        if (Get.isRegistered<MyListingsController>()) {
          Get.find<MyListingsController>().fetchMyListings();
        }
        if (Get.isRegistered<MarketplaceController>()) {
          Get.find<MarketplaceController>().fetchListings();
        }
        
        Get.back();
      } else {
        Get.snackbar(
          'Error', 
          'Failed to ${isEditMode.value ? 'update' : 'create'} listing',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
