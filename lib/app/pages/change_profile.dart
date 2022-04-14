// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/change_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfilePage extends GetView<ChangeProfileController> {
  final authController = Get.find<AuthController>();
  final controller = Get.put(ChangeProfileController());
  ChangeProfilePage({Key? key}) : super(key: key);

  final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    // accentColor: Colors.black,
    // buttonColor: Color(0xff8E05C2),
  );
  final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 0, 0, 0),
    // accentColor: Color(0xff700B97),
    // buttonColor: Color(0xff8E05C2),
  );

  @override
  Widget build(BuildContext context) {
    controller.emailController.text = authController.user.value.email!;
    controller.nameController.text = authController.user.value.name!;
    controller.statusController.text = authController.user.value.status!;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              authController.changeProfile(controller.nameController.text,
                  controller.statusController.text);
            },
            icon: Icon(Icons.save),
          ),
        ],
        title: Text(
          "Change Profile",
          // style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: ListView(
          children: [
            AvatarGlow(
              endRadius: 100,
              glowColor: Colors.black,
              duration: Duration(
                seconds: 2,
              ),
              child: Obx(() => ClipRRect(
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
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.emailController,
              readOnly: true,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 59, 59, 59),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.nameController,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 59, 59, 59),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.statusController,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                authController.changeProfile(controller.nameController.text,
                    controller.statusController.text);
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Status',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 107, 107, 107),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 59, 59, 59),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<ChangeProfileController>(builder: (c) {
                  return c.pickImage != null
                      ? Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(c.pickImage!.path),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () => c.resetImage(),
                                    icon: Icon(Icons.delete)),
                                SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                    onPressed: () => c
                                            .uploadImage(
                                                authController.user.value.uid!)
                                            .then((value) {
                                          if (value != null) {
                                            authController
                                                .updatePhotoUrl(value);
                                          }
                                        }),
                                    child: Text("Upload")),
                              ],
                            ),
                          ],
                        )
                      : Text("No Image");
                }),
                TextButton(
                  onPressed: () {
                    controller.selectImage();
                  },
                  child: Text('Pilih gambar'),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  // primary: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  authController.changeProfile(controller.nameController.text,
                      controller.statusController.text);
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
