// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/chat_room_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/search_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ChatRoomPage extends GetView<ChatRoomController> {
  final authC = Get.find<AuthController>();
  final String chatId = (Get.arguments as Map<String, dynamic>)["chatId"];
  ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    final searchController = Get.put(SearchController());
    final chatRoomController = Get.put(ChatRoomController());
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color(0xffA63EC5),
            titleSpacing: 10,
            // backgroundColor: Colors.blue,
            leadingWidth: 80,
            leading: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => Get.back(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.arrow_back),
                  // SizedBox(
                  //   width: ,
                  // ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: StreamBuilder<DocumentSnapshot<Object?>>(
                        stream: controller.streamFriendData((Get.arguments
                            as Map<String, dynamic>)["friendEmail"]),
                        builder: (context, snapshotFriendUser) {
                          if (snapshotFriendUser.connectionState ==
                              ConnectionState.active) {
                            var dataFriend = snapshotFriendUser.data!.data()
                                as Map<String, dynamic>;
                            if (dataFriend["photoUrl"] == "noImage") {
                              return Image.asset(
                                'assets/logo/noimage.png',
                                fit: BoxFit.cover,
                              );
                            } else {
                              return Image.network(
                                dataFriend["photoUrl"],
                                fit: BoxFit.cover,
                              );
                            }
                          }
                          return Image.asset(
                            'assets/logo/noimage.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: false,
            title: StreamBuilder<DocumentSnapshot<Object?>>(
                stream: controller.streamFriendData(
                    (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                builder: (context, snapshotFriendUser) {
                  if (snapshotFriendUser.connectionState ==
                      ConnectionState.active) {
                    var dataFriend =
                        snapshotFriendUser.data!.data() as Map<String, dynamic>;
                    return WillPopScope(
                      onWillPop: () {
                        if (controller.isShowEmoji.isTrue) {
                          controller.isShowEmoji.value = false;
                        } else {
                          Navigator.pop(context);
                        }
                        return Future.value(false);
                      },
                      child: dataFriend["status"] == ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "${dataFriend["name"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${dataFriend["status"]}",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${dataFriend["name"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${dataFriend["status"]}",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                    );
                  }
                  return SizedBox();
                }),
          ),
          preferredSize: Size.fromHeight(65)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              width: Get.width,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamChats(chatId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    // Timer(
                    //     Duration.zero,
                    //     () => controller.scrollController.jumpTo(controller
                    //         .scrollController.position.maxScrollExtent));
                    var dataChat = snapshot.data!.docs;
                    var listChatsDocs = snapshot.data!;
                    if (dataChat.isNotEmpty) {
                      return ListView.builder(
                          controller: controller.scrollController,
                          itemCount: dataChat.length,
                          itemBuilder: ((context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  Text(
                                    "${dataChat[index]["groupTime"]}",
                                  ),
                                  Chat(
                                    message: "${dataChat[index]["pesan"]}",
                                    isSender: dataChat[index]["pengirim"] ==
                                            authC.user.value.email
                                        ? true
                                        : false,
                                    time: "${dataChat[index]["time"]}",
                                  ),
                                ],
                              );
                            } else {
                              if (dataChat[index]["groupTime"] ==
                                  dataChat[index - 1]["groupTime"]) {
                                return Chat(
                                  message: "${dataChat[index]["pesan"]}",
                                  isSender: dataChat[index]["pengirim"] ==
                                          authC.user.value.email
                                      ? true
                                      : false,
                                  time: "${dataChat[index]["time"]}",
                                );
                              } else {
                                return Column(
                                  children: [
                                    Text(
                                      "${dataChat[index]["groupTime"]}",
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Chat(
                                      message: "${dataChat[index]["pesan"]}",
                                      isSender: dataChat[index]["pengirim"] ==
                                              authC.user.value.email
                                          ? true
                                          : false,
                                      time: "${dataChat[index]["time"]}",
                                    ),
                                  ],
                                );
                              }
                            }
                          }));
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/lottie/sayhi.json",
                                repeat: true),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Say hi to your new friend",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Oops Something Wrong"),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: controller.isShowEmoji.isTrue
                  ? 5
                  : context.mediaQueryPadding.bottom,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: TextField(
                      autocorrect: false,
                      onEditingComplete: () => controller.newChat(
                        authC.user.value.email!,
                        Get.arguments as Map<String, dynamic>,
                        controller.chatController.text,
                      ),
                      controller: controller.chatController,
                      focusNode: controller.focusNode,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            controller.focusNode.unfocus();
                            controller.isShowEmoji.toggle();
                          },
                          icon: Icon(Icons.emoji_emotions_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Material(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.black,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      controller.newChat(
                        authC.user.value.email!,
                        Get.arguments as Map<String, dynamic>,
                        controller.chatController.text,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => (controller.isShowEmoji.isTrue)
                ? Container(
                    height: 325,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        controller.addEmojiToChat(emoji);
                      },
                      onBackspacePressed: () {
                        // Backspace-Button tapped logic
                        // Remove this line to also remove the button in the UI
                        controller.deleteEmoji();
                      },
                      config: Config(
                          columns: 7,
                          // emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.black,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.black,
                          progressIndicatorColor: Colors.black,
                          backspaceColor: Colors.black,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: "No Recents",
                          noRecentsStyle: const TextStyle(
                              fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class Chat extends StatelessWidget {
  const Chat({
    Key? key,
    required this.isSender,
    required this.message,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isSender
          ? EdgeInsets.only(
              bottom: 20,
              left: 50,
            )
          : EdgeInsets.only(
              bottom: 20,
              right: 20,
            ),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: isSender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                color: Color(0xffA63EC5)),
            padding: EdgeInsets.all(10),
            child: Text(
              "$message",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            DateFormat.jm().format(
              DateTime.parse(time),
            ),
            style: TextStyle(
                // color: Get.isDarkMode
                //     ? Color.fromARGB(255, 204, 204, 204)
                //     : Color.fromARGB(255, 119, 119, 119)
                ),
          ),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
