import 'dart:ui';

import 'package:chat_app_getx_12_03_2022/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Connecting Everyone on Everywhere",
            body:
                "Start your difference journey of Communications with someone else",
            image: Container(
              width: Get.width * 0.7,
              child: Center(
                child: Lottie.asset('assets/lottie/intro.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "A Piece of Cake of Communications",
            body: "Join us and enjoy and let's find some friend",
            image: Container(
              width: Get.width * 0.7,
              child: Center(
                child: Lottie.asset('assets/lottie/intro2.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Halo Everyone! I am Using PurboyChat App",
            body: "Say hi to the world!",
            image: Container(
              width: Get.width * 0.7,
              child: Center(
                child: Lottie.asset('assets/lottie/intro3.json'),
              ),
            ),
          )
        ],
        onDone: () {
          // When done button is press
          Get.offAllNamed(AppRoutes.LOGIN);
        },
        showBackButton: false,
        showSkipButton: true,
        skip: Text("Skip"),
        next: Text("Next"),
        done: const Text("Say Hi!",
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
