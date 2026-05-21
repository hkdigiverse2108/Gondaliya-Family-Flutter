import 'package:get/get.dart';
import 'api_service.dart';

abstract class BaseRepository {
  DioApiService get api => Get.find<DioApiService>();
}
