import 'package:get/get.dart';
import '../controllers/private_messages_controller.dart';
import '../controllers/private_chat_controller.dart';

class PrivateMessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivateMessagesController>(
      () => PrivateMessagesController(),
    );
    Get.lazyPut<PrivateChatController>(
      () => PrivateChatController(),
    );
  }
}
