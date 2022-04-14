// ignore_for_file: prefer_const_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<AuthController> {
  final authController = Get.find<AuthController>();
  ProfilePage({Key? key}) : super(key: key);

  final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    accentColor: Color.fromARGB(255, 224, 224, 224),
    buttonColor: Color.fromARGB(255, 0, 0, 0),
  );
  final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 29, 29, 29),
    accentColor: Color.fromARGB(255, 31, 31, 31),
    buttonColor: Color.fromARGB(255, 255, 255, 255),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? Color.fromARGB(255, 36, 36, 36)
            : Color.fromARGB(255, 228, 228, 228),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => authController.logout(),
            icon: Icon(
              Icons.logout,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                AvatarGlow(
                  endRadius: 100,
                  glowColor: Colors.black,
                  duration: Duration(
                    seconds: 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: authController.user.value.photoUrl == "NoImage"
                          ? Image.asset(
                              'assets/logo/noimage.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              authController.user.value.photoUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                Obx(
                  () => Text(
                    "${authController.user.value.name}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${authController.user.value.email}",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  ListTile(
                    onTap: () => Get.toNamed(AppRoutes.UPDATESTATUS),
                    leading: Icon(Icons.note),
                    title: Text(
                      "Update Status",
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(AppRoutes.CHANGEPROFILE),
                    leading: Icon(Icons.person_rounded),
                    title: Text(
                      "Change Profile",
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () => Get.changeTheme(
                        Get.isDarkMode ? ThemeData.light() : ThemeData.dark()),
                    leading: Icon(
                        Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    title: Text(
                      "Change Theme",
                    ),
                    trailing: Get.isDarkMode ? Text("Light") : Text("Dark"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: context.mediaQueryPadding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chat App',
                  style: TextStyle(
                    color: Color.fromARGB(255, 145, 145, 145),
                  ),
                ),
                Text(
                  'V 1.0.0',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
