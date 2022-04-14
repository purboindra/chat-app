// ignore_for_file: prefer_const_constructors

import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/home_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/search_controller.dart';
import 'package:chat_app_getx_12_03_2022/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends GetView<HomeController> {
  final authController = Get.find<AuthController>();
  final homeController = Get.put(HomeController());
  final searchC = Get.put(SearchController());

  HomePage({Key? key}) : super(key: key);

  final light = ThemeData.light(
      // brightness: Brightness.light,
      // primaryColor: Colors.white,
      // accentColor: Colors.black,
      // buttonColor: Color(0xff8E05C2),
      );
  final dark = ThemeData.dark(
      // brightness: Brightness.dark,
      // primaryColor: Color.fromARGB(255, 0, 0, 0),
      // accentColor: Color(0xff700B97),
      // buttonColor: Color(0xff8E05C2),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.theme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () => Get.toNamed(AppRoutes.SEARCH),
      ),
      body: Column(children: [
        Material(
          elevation: 5,
          child: Container(
            margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.PROFILE),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: authController.user.value.photoUrl ==
                                        "noImage"
                                    ? Image.asset(
                                        "assets/logo/noimage.png",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        authController.user.value.photoUrl!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              radius: 24,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                authController.user.value.name!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.more,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.width,
                  height: 50,
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      labelText: "Search",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatStream(authController.user.value.email!),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listChatsDocs = snapshot1.data!.docs;
                  // streamBuilder untuk memantau friend list firebase
                  if (listChatsDocs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: listChatsDocs.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: homeController.friendStream(
                                  listChatsDocs[index]["connection"]),
                              builder: (context, snapshot2) {
                                if (snapshot2.connectionState ==
                                    ConnectionState.active) {
                                  var data = snapshot2.data!.data();
                                  return data!["status"] == ""
                                      ? Slidable(
                                          key: ValueKey(1),
                                          startActionPane: ActionPane(
                                            dismissible: DismissiblePane(
                                                onDismissed: () {
                                              authController.deleteChat(
                                                "${listChatsDocs[index]["connection"]}",
                                              );
                                            }),
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  authController.deleteChat(
                                                    "${listChatsDocs[index]["connection"]}",
                                                  );
                                                },
                                                backgroundColor: Colors.black,
                                                icon: Icons.delete,
                                                label: "Delete",
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            onTap: () =>
                                                controller.goToChatRoom(
                                              "${listChatsDocs[index].id}",
                                              authController.user.value.email!,
                                              listChatsDocs[index]
                                                  ["connection"],
                                            ),
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.black26,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: data["photoUrl"] ==
                                                        "noimage"
                                                    ? Image.asset(
                                                        "assets/logo/noimage.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "${data["photoUrl"]}",
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            title: Text(
                                              "${data["name"]}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            trailing: listChatsDocs[index]
                                                        ["totalUnread"] ==
                                                    0
                                                ? SizedBox()
                                                : Chip(
                                                    backgroundColor:
                                                        Colors.red[900],
                                                    label: Text(
                                                      "${listChatsDocs[index]["totalUnread"]}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                          ),
                                        )
                                      : ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 20,
                                          ),
                                          onTap: () => controller.goToChatRoom(
                                            "${listChatsDocs[index].id}",
                                            authController.user.value.email!,
                                            listChatsDocs[index]["connection"],
                                          ),
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.black26,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child:
                                                  data["photoUrl"] == "noimage"
                                                      ? Image.asset(
                                                          "assets/logo/noimage.png",
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          "${data["photoUrl"]}",
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),
                                          title: Text(
                                            "${data["name"]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${data["status"]}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: listChatsDocs[index]
                                                      ["totalUnread"] ==
                                                  0
                                              ? SizedBox()
                                              : Chip(
                                                  backgroundColor:
                                                      Colors.red[900],
                                                  label: Text(
                                                    "${listChatsDocs[index]["totalUnread"]}",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                        );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              });
                        });
                  } else {
                    return Center(
                      child: Container(
                        width: Get.width * 0.7,
                        height: Get.height * 0.7,
                        child: Lottie.asset(
                          'assets/lottie/lo.json',
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        )
      ]),
    );
  }
}


 // return StreamBuilder<
                                //         DocumentSnapshot<Map<String, dynamic>>>(
                                //     stream: controller.friendStream(
                                //         listChatsDocs[index]["connection"]),
                                //     builder: (context, snapshot2) {
                                //       if (snapshot2.connectionState ==
                                //           ConnectionState.active) {
                                //         print(snapshot2);
                                //         var data = snapshot2.data!.data();
                                //         return data!["status"] == ""
                                //             ? ListTile(
                                //                 contentPadding: EdgeInsets.symmetric(
                                //                     horizontal: 20, vertical: 15),
                                //                 leading: CircleAvatar(
                                //                   child: ClipRRect(
                                //                     borderRadius:
                                //                         BorderRadius.circular(100),
                                //                     child:
                                //                         data["photoUrl"] == "noImage"
                                //                             ? Image.asset(
                                //                                 "assets/logo/noimage.png",
                                //                                 fit: BoxFit.cover,
                                //                               )
                                //                             : Image.network(
                                //                                 data['photoUrl'],
                                //                                 fit: BoxFit.cover,
                                //                               ),
                                //                   ),
                                //                   radius: 32,
                                //                 ),
                                //                 title: Text("${data["name"]}"),
                                //                 trailing: listChatsDocs[index]
                                //                             ["totalUnread"] ==
                                //                         0
                                //                     ? SizedBox()
                                //                     : Chip(
                                //                         backgroundColor: Colors.blue,
                                //                         label: Text(
                                //                             "${listChatsDocs[index]["totalUnread"]}"),
                                //                         labelStyle: TextStyle(
                                //                             color: Colors.white),
                                //                       ),
                                //                 onTap: () {
                                //                   controller.goToChatRoom(
                                //                     "${listChatsDocs[index]["chatId"]}",
                                //                     authController.user.value.email!,
                                //                     "${listChatsDocs[index]["friendEmail"]}",
                                //                   );
                                //                 })
                                //             : ListTile(
                                //                 contentPadding: EdgeInsets.symmetric(
                                //                     horizontal: 20, vertical: 15),
                                //                 leading: CircleAvatar(
                                //                   backgroundColor: Colors.grey,
                                //                   child: ClipRRect(
                                //                     borderRadius:
                                //                         BorderRadius.circular(100),
                                //                     child:
                                //                         data["photoUrl"] == "noImage"
                                //                             ? Image.asset(
                                //                                 "assets/logo/noimage.png",
                                //                                 fit: BoxFit.cover,
                                //                               )
                                //                             : Image.network(
                                //                                 data['photoUrl'],
                                //                                 fit: BoxFit.cover,
                                //                               ),
                                //                   ),
                                //                   radius: 32,
                                //                 ),
                                //                 title: Text(
                                //                     "${listChatsDocs[index]["name"]}"),
                                //                 subtitle: Text("${data["status"]}"),
                                //                 trailing: listChatsDocs[index]
                                //                             ["totalUnread"] ==
                                //                         0
                                //                     ? SizedBox()
                                //                     : Chip(
                                //                         backgroundColor: Colors.blue,
                                //                         label: Text(
                                //                             "${listChatsDocs[index]["totalUnread"]}"),
                                //                         labelStyle: TextStyle(
                                //                             color: Colors.white),
                                //                       ),
                                //                 onTap: () {
                                //                   controller.goToChatRoom(
                                //                     "${listChatsDocs[index]["chatId"]}",
                                //                     authController.user.value.email!,
                                //                     "${listChatsDocs[index]["friendEmail"]}",
                                //                   );
                                //                 });
                                //       } else {
                                //         return Center(
                                //             child: CircularProgressIndicator());
                                //       }
                                //     });