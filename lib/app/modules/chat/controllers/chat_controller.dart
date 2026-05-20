import 'package:get/get.dart';

enum ChatMode { give, take }

class ChatController extends GetxController {
  final chatMode = ChatMode.give.obs;
  
  // Variables to manage messaging limits and state
  final remainingMessages = 32.obs;
}
