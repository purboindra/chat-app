import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/app/utils/error_screen.dart';
import 'package:chat_app_getx_12_03_2022/app/utils/loading_screen.dart';
import 'package:chat_app_getx_12_03_2022/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/controller/home_controller.dart';
import 'app/controller/search_controller.dart';
import 'app/utils/splash_screen.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDc-YvfOAMSwkcKzVUXDh2gchHVEQXvoCo",
        appId: "1:455219808222:web:97519992d244fb285aff4f",
        messagingSenderId: "455219808222",
        projectId: "add-project-1fd3c",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final authController = Get.put(AuthController(), permanent: true);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //check for errors
        if (snapshot.hasError) {
          return const ErrorScreen();
        }
        // once complete, show ur applications
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: Future.delayed(
              const Duration(seconds: 3),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Obx(
                  () => GetMaterialApp(
                    theme: ThemeData.light(),
                    debugShowCheckedModeBanner: false,
                    initialRoute: authController.isSkipIntro.isTrue
                        ? authController.isAuth.isTrue
                            ? AppRoutes.HOME
                            : AppRoutes.INTRODUCTION
                        : AppRoutes.LOGIN,
                    getPages: AppPages.routes,
                  ),
                );
              }
              return FutureBuilder(
                  future: authController.firstInitialize(),
                  builder: (context, snapshot) => SplashScreen());
            },
          );
        }
        return LoadingScreen();
      },
    );
  }
}
