import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController statusController;
  ImagePicker imagePicker = ImagePicker();
  XFile? pickImage = null;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadImage(String uid) async {
    File file = File(pickImage!.path);
    Reference storageReference = firebaseStorage.ref("$uid.png");
    resetImage();
    try {
      await storageReference.putFile(file);
      final photoUrl = await storageReference.getDownloadURL();
      return photoUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void resetImage() {
    pickImage = null;
    update();
  }

  void selectImage() async {
    try {
      final checkDataImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      // final checkImageCam =
      //     await imagePicker.pickImage(source: ImageSource.camera);
      if (checkDataImage != null) {
        print(checkDataImage.name);
        print(checkDataImage.path);
        pickImage = checkDataImage;
      }
      update();
    } catch (e) {
      print(e);
      pickImage = null;
      update();
    }
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    nameController = TextEditingController();
    statusController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    statusController.dispose();
    super.onClose();
  }
}
