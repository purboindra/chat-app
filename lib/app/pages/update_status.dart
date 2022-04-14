import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/controller/update_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStatusPage extends GetView<UpdateStatusController> {
  final controller = Get.put(UpdateStatusController());
  final authController = Get.find<AuthController>();
  UpdateStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.updateStatusController.text = authController.user.value.status!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Update Status"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.updateStatusController,
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                authController
                    .updateStatus(controller.updateStatusController.text);
              },
              cursorColor: Get.isDarkMode
                  ? Color.fromARGB(255, 255, 255, 255)
                  : Color.fromARGB(255, 26, 26, 26),
              decoration: InputDecoration(
                labelText: 'Update Status',
                labelStyle: TextStyle(
                  color: Get.isDarkMode
                      ? Color.fromARGB(255, 199, 199, 199)
                      : Color.fromARGB(255, 83, 83, 83),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(255, 26, 26, 26),
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color.fromARGB(255, 26, 26, 26),
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
            Container(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  primary: Get.isDarkMode
                      ? Color.fromARGB(255, 190, 16, 161)
                      : Color.fromARGB(255, 26, 26, 26),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  authController
                      .updateStatus(controller.updateStatusController.text);
                },
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
