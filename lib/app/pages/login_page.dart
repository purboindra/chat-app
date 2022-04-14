import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends GetView<AuthController> {
  final authController = Get.find<AuthController>();
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width * 0.7,
                      height: Get.height * 0.4,
                      child: Lottie.asset('assets/lottie/intro4.json'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        primary: Colors.orange,
                      ),
                      onPressed: () => authController.login(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/google3d.png',
                            width: 32,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Sign In With Google',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("PurboyChats App"),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Version 1.1.1'),
                  ],
                ),
              ]),
          // ],
        ),
      ),
    );
  }
}
