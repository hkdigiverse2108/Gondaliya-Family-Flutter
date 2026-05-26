import 'package:get/get.dart';
import '../../../data/models/listing.dart';
import '../home_repository.dart';

class MarketplaceController extends GetxController {
  final HomeRepository _homeRepo;

  MarketplaceController(this._homeRepo);

  final listings = <Listing>[].obs;
  final isFeedLoading = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // fetchListings(); // Commented out to prevent API call while marketplace is disabled
  // }

  Future<void> fetchListings() async {
    isFeedLoading.value = true;
    try {
      final fetchedListings = await _homeRepo.getListings();
      listings.assignAll(fetchedListings);
    } catch (e) {
      _injectDummyData();
    } finally {
      isFeedLoading.value = false;
    }
  }

  void _injectDummyData() {
    listings.assignAll([
      Listing(
        id: '1',
        title: 'Shop for Rent in Varachha',
        description:
            'Prime location shop available for rent on the main road. Suitable for clothing or electronics store.',
        type: 'Rent',
        price: 25000,
        priceUnit: 'Month',
        postedBy: 'User1',
        availableFrom: DateTime.now(),
        location: const ListingLocation(city: 'Surat', pincode: '395006'),
        contactPhone: '9876543210',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Listing(
        id: '2',
        title: 'Used Honda City 2021',
        description:
            'Well-maintained Honda City ZX, 1st owner, 30,000 km driven. Excellent condition.',
        type: '2nd Hand',
        price: 950000,
        priceUnit: 'FIXED',
        postedBy: 'User2',
        availableFrom: DateTime.now(),
        location: const ListingLocation(city: 'Surat', pincode: '395004'),
        contactPhone: '9876543211',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      Listing(
        id: '3',
        title: 'Mangoes (Kesar) Box',
        description:
            'Fresh organic Kesar mangoes directly from our farm in Junagadh. 10kg box.',
        type: 'Seasonal',
        price: 1200,
        priceUnit: 'Box',
        postedBy: 'User3',
        availableFrom: DateTime.now(),
        location: const ListingLocation(city: 'Junagadh', pincode: '362001'),
        contactPhone: '9876543212',
        createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      ),
    ]);
  }
}
