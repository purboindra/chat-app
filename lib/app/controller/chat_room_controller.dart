import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  int totalUnread = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late FocusNode focusNode;
  late TextEditingController chatController;
  late ScrollController scrollController;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chatId) {
    CollectionReference chats = firestore.collection("chats");
    return chats
        .doc(chatId)
        .collection("chats")
        .orderBy(
          "time",
        )
        .snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamFriendData(String friendEmail) {
    CollectionReference users = firestore.collection("users");
    return users.doc(friendEmail).snapshots();
  }

  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    if (chat != "") {
      CollectionReference chats = firestore.collection("chats");
      CollectionReference users = firestore.collection("users");
      String date = DateTime.now().toIso8601String();

      await chats.doc(argument["chatId"]).collection("chats").add({
        //membuat chat baru
        "pengirim": email,
        "penerima": argument["friendEmail"],
        "pesan": chat,
        "time": date,
        "isRead": false,
        "groupTime": DateFormat.yMMMMd().format(DateTime.parse(date)),
      });

      Timer(
        Duration.zero,
        () =>
            scrollController.jumpTo(scrollController.position.maxScrollExtent),
      );

      chatController.clear();

      //change last time user
      await users
          .doc(email)
          .collection("chats")
          .doc(argument["chatId"])
          .update({
        "lastTime": date,
      });

      //added data friend
      final checkChatFriends = await users
          .doc(argument["friendEmail"])
          .collection("chats")
          .doc(argument["chatId"])
          .get();

      if (checkChatFriends.exists) {
        //terdapat data chat from friendEmail
        //first check total unread

        final checkTotalUnread = await chats
            .doc(argument['chatId'])
            .collection("chats")
            .where("isRead", isEqualTo: false)
            .where("pengirim", isEqualTo: email)
            .get();

        //total unRead for friendEmail
        totalUnread = checkTotalUnread.docs.length;

        await users
            .doc(argument["friendEmail"])
            .collection("chats")
            .doc(argument["chatId"])
            .update({"lastTime": date, "totalUnread": totalUnread});
      } else {
        //not exist

        await users
            .doc(argument["friendEmail"])
            .collection("chats")
            .doc(argument["chatId"])
            .set({
          "connection": email,
          "lasTime": date,
          "totalUnread": 1,
        });
      }
    }
  }

  void addEmojiToChat(Emoji emoji) {
    chatController.text = chatController.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatController.text =
        chatController.text.substring(0, chatController.text.length - 2);
  }

  @override
  void onInit() {
    chatController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    chatController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
