import 'package:get/get.dart';
import '../controllers/private_messages_controller.dart';
import '../controllers/private_chat_controller.dart';

class PrivateMessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivateMessagesController>(
      PrivateMessagesController.new,
    );
    Get.lazyPut<PrivateChatController>(
      PrivateChatController.new,
    );
  }
}
