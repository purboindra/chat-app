import 'package:chat_app_getx_12_03_2022/app/pages/change_profile.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/chat.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/chat_room.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/home_page.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/login_page.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/profile.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/search_page.dart';
import 'package:chat_app_getx_12_03_2022/app/pages/update_status.dart';
import 'package:get/get.dart';

import '../app/pages/intoduction_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionPage(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatRoomPage(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchPage(),
    ),
    GetPage(
      name: _Paths.UPDATESTATUS,
      page: () => UpdateStatusPage(),
    ),
    GetPage(
      name: _Paths.CHANGEPROFILE,
      page: () => ChangeProfilePage(),
    ),
    GetPage(
      name: _Paths.CHATPAGE,
      page: () => ChatPage(),
    ),
  ];
}
