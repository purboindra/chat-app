// ignore_for_file: avoid_print

import 'package:chat_app_getx_12_03_2022/models/user_models.dart';
import 'package:chat_app_getx_12_03_2022/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/chats_models.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UserModel().obs;
  var chat = Chat().obs;

  Future<void> firstInitialize() async {
    //mengubah isAuth menjadi true
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });
    await skipIntro().then((value) {
      //mengubah isSkipIntro menjadi true
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    final box = GetStorage();
    //mengubah nilai isAtuh menjadi true
    //mengubah nilai isSkip/introduction menjadi true
    if (box.read('isSkipIntro') != null || box.read('isSkipIntro') == true) {
      print("box read ${box.read("isSkipIntro")}");
      return true;
    }
    return false;
  }

  //Function auto login
  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        print("ini current user $_currentUser");
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("credential $credential");

        CollectionReference users = firestore.collection('users');

        final checkUser = await users.doc(_currentUser!.email).get();
        print("checkUser $checkUser");

        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currentUserData = currUser.data() as Map<String, dynamic>;
        user(UserModel.fromJson(currentUserData));

        user.refresh();
        //membuat lis<chatuser>
        final listChat =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChat.docs.length != 0) {
          List<ChatUser> dataListChats = <ChatUser>[];
          listChat.docs.forEach((element) {
            var dataDocumentChat = element.data();
            var dataDocumentChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocumentChatId,
              connection: dataDocumentChat["connection"],
              lastTime: dataDocumentChat["lastTime"],
              totalUnread: dataDocumentChat["totalUnread"],
            ));
          });
          user.update((user) {
            user!.chatsRoom = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chatsRoom = [];
          });
        }

        user.refresh();

        return true;
      }
      return false;
    } catch (error) {
      print('error auto login $error');
      return false;
    }
  }

  //function login
  Future<void> login() async {
    //membuat fungsi login dengan google
    try {
      //tujuan signin.signout untuk handel kebocoran data
      //user sebelum login
      await _googleSignIn.signOut();
      //mendapatkan google account user
      await _googleSignIn.signIn().then(
            (value) => _currentUser = value,
          );
      //mengecek kondisi/status login user (apakah login or tidak)
      final isSigin = await _googleSignIn.isSignedIn();
      if (isSigin) {
        //Login succes
        print("Logged");
        print(_currentUser);
        final googleAuth = await _currentUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        //simpan firebase
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);
        print("User credential $userCredential ");
        //simpan login dan tidak akan menampilkan introduction
        final box = GetStorage();
        if (box.read('isSkipIntro') != null) {
          print("box remove isSkipIntro ${box.remove('isSkipIntro')}");
          box.remove('isSkipIntro');
        }
        box.write('isSkipIntro', true);
        //masukan ke firebase/firestore
        CollectionReference users = firestore.collection('users');
        final checkUser = await users.doc(_currentUser!.email).get();
        //menambahkan user baru or user first time login
        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noImage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updateTime": DateTime.now().toIso8601String(),
          });
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });

          await users.doc(_currentUser!.email).collection("chats");
        }
        final currUser = await users.doc(_currentUser!.email).get();
        final currentUserData = currUser.data() as Map<String, dynamic>;

        user(UserModel.fromJson(currentUserData));

        user.refresh();
        //membuat lis<chatuser>
        final listChat =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChat.docs.length != 0) {
          List<ChatUser> dataListChats = <ChatUser>[];
          listChat.docs.forEach((element) {
            var dataDocumentChat = element.data();
            var dataDocumentChatId = element.id;

            dataListChats.add(ChatUser(
              chatId: dataDocumentChatId,
              connection: dataDocumentChat["connection"],
              lastTime: dataDocumentChat["lastTime"],
              totalUnread: dataDocumentChat["totalUnread"],
            ));
          });
          user.update((user) {
            user!.chatsRoom = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chatsRoom = [];
          });
        }

        user.refresh();

        isAuth.value = true;
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        print("Login gagal");
      }
    } catch (error) {
      print("catch error $error");
    }
  }

  //function logout
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  //PROFILE
  //update firebase
  void changeProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updateTime": date,
    });

    //update model
    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.snackbar(
      "Congratulations",
      "Your profile has been update",
      duration: Duration(seconds: 3),
    );
  }

  //update status
  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');
    users.doc(_currentUser!.email).update({
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updateTime": date,
    });

    user.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.snackbar(
      "Congratulations",
      "Your status has been updated",
      duration: Duration(seconds: 3),
    );
  }

  //Delete chat list
  void deleteChat(String friendEmail) async {
    CollectionReference chatsRoom = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');
    final listChat = await users
        .doc(_currentUser!.email)
        .collection("chats")
        .where("connection", isEqualTo: friendEmail)
        .get();

    if (listChat.docs.isNotEmpty) {
      listChat.docs.forEach((element) async {
        var dataDocumentChat = element.data();
        var dataDocumentChatId = element.id;
        print(dataDocumentChat);
        print(dataDocumentChatId);
        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .where("connection", isEqualTo: friendEmail)
            .get();

        final usersChat = await chatsRoom.where('connection').get();
        if (usersChat.docs.isNotEmpty) {
          users
              .doc(_currentUser!.email)
              .collection("chats")
              .doc(dataDocumentChatId)
              .delete();
        }
      });
    }
    user.refresh();
  }

  //SEARCH
  void addNewConnections(String? friendEmail) async {
    bool flagNewConnection = false;
    var chatId;
    String date = DateTime.now().toIso8601String();
    CollectionReference chatsRoom = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final documentChat =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (documentChat.docs.length != 0) {
      //user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.length != 0) {
        //sudah pernah buat koneksi dengan friendEmail
        flagNewConnection = false;
        //chatId from chats collection
        chatId = checkConnection.docs[0].id;
      }
      //belum pernah buat koneksi dengan friendEmail
      //buat koneksi
      flagNewConnection = true;
    } else {
      //belum pernah buat koneksi dengan friendEmail
      //buat koneksi
      flagNewConnection = true;
    }

    //FIXING COLLECTION CHAT USER
    if (flagNewConnection == true) {
      //cek dari chats collection
      //apakah ada dokumen yang collectionnya antara mereka berdua
      //cek collection => mereka berdua
      //kondisi pertama:
      final chatDocs = await chatsRoom.where(
        'connection',
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatDocs.docs.length != 0) {
        final chatsDataId = chatDocs.docs[0].id;
        final chatsData = chatDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatsDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "totalUnread": 0,
        });

        final listChat =
            await users.doc(_currentUser!.email).collection("chats").get();

        //update model
        if (listChat.docs.isNotEmpty) {
          List<ChatUser> dataListChats = <ChatUser>[];
          listChat.docs.forEach((element) {
            var dataDocumentChat = element.data();
            var dataDocumentChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocumentChatId,
              connection: dataDocumentChat["connection"],
              lastTime: dataDocumentChat["lastTime"],
              totalUnread: dataDocumentChat["totalUnread"],
            ));
          });
          user.update((user) {
            user!.chatsRoom = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chatsRoom = [];
          });
        }

        //DATA YANG LAMA TIDAK DIHAPUS/DIREPLACE
        chatId = chatsDataId;
        user.refresh();
      } else {
        final newChatDocument = await chatsRoom.add({
          "connection": [
            _currentUser!.email,
            friendEmail,
          ],
        });

        await chatsRoom.doc(newChatDocument.id).collection("chats");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDocument.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "totalUnread": 0,
        });

        final listChat =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChat.docs.isNotEmpty) {
          List<ChatUser> dataListChats = <ChatUser>[];
          listChat.docs.forEach((element) {
            var dataDocumentChat = element.data();
            var dataDocumentChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocumentChatId,
              connection: dataDocumentChat["connection"],
              lastTime: dataDocumentChat["lastTime"],
              totalUnread: dataDocumentChat["totalUnread"],
            ));
          });
          user.update((user) {
            user!.chatsRoom = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chatsRoom = [];
          });
        }
        chatId = newChatDocument.id;
        user.refresh();
      }
    }
    print("Your chat id: $chatId");

    final updateStatusChats = await chatsRoom
        .doc(chatId)
        .collection("chats")
        .where('isRead', isEqualTo: false)
        .where("penerima", isEqualTo: _currentUser!.email)
        .get();
    updateStatusChats.docs.forEach((element) async {
      element.id;
      await chatsRoom.doc(chatId).collection('chats').doc(element.id).update({
        "isRead": true,
      });
    });

    await users
        .doc(_currentUser!.email)
        .collection('chats')
        .doc(chatId)
        .update({
      "totalUnread": 0,
    });

    Get.toNamed(AppRoutes.CHAT, arguments: {
      "chatId": "$chatId",
      "friendEmail": friendEmail,
    });
  }

  void updatePhotoUrl(String photoUrl) async {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = firestore.collection('users');
    await users.doc(_currentUser!.email).update({
      "photoUrl": photoUrl,
      "updateTime": date,
    });

    user.update((user) {
      user!.photoUrl = photoUrl;

      user.updatedTime = date;
    });

    user.refresh();
    Get.snackbar(
      "Congratulations",
      "Your photo profile has been updated",
      duration: Duration(seconds: 3),
    );
  }
}
