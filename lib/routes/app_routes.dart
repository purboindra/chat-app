part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const INTRODUCTION = _Paths.INTRODUCTION;
  static const PROFILE = _Paths.PROFILE;
  static const CHAT = _Paths.CHAT;
  static const SEARCH = _Paths.SEARCH;
  static const UPDATESTATUS = _Paths.UPDATESTATUS;
  static const CHANGEPROFILE = _Paths.CHANGEPROFILE;
  static const CHATPAGE = _Paths.CHATPAGE;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const INTRODUCTION = '/introduction';
  static const PROFILE = '/profile';
  static const CHAT = '/chat';
  static const SEARCH = '/search';
  static const UPDATESTATUS = '/updatestatus';
  static const CHANGEPROFILE = '/changeprofile';
  static const CHATPAGE = '/chatpage';
}
