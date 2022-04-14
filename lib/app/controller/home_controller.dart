import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection("chats")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  void goToChatRoom(String chatId, String email, String friendEmail) async {
    CollectionReference chatsRoom = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    final updateStatusChat = await chatsRoom
        .doc(chatId)
        .collection("chats")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: friendEmail)
        .get();

    updateStatusChat.docs.forEach((element) async {
      await chatsRoom
          .doc(chatId)
          .collection("chats")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(email)
        .collection("chats")
        .doc(chatId)
        .update({"totalUnread": 0});

    Get.toNamed(AppRoutes.CHAT, arguments: {
      "chatId": chatId,
      "friendEmail": friendEmail,
    });
  }
}
