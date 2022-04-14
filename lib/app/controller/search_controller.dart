// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchCont;
  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    print(data);
    if (data.length == 0) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);
      if (queryAwal.length == 0 && data.length == 1) {
        //panggil fungsi yang akan dijalankan pada ketikan pertama (1 huruf)
        //aktifkan indexes di firestore jika menggukana 2 where or query (keyName dan email = query)
        //jika query hanya 1, tidak perlu indexes di firestore
        CollectionReference users = firestore.collection('users');
        final keyNameResult = await users
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .where("email", isNotEqualTo: email)
            .get();

        print('total data ${keyNameResult.docs.length}');
        if (keyNameResult.docs.length > 0) {
          for (var i = 0; i < keyNameResult.docs.length; i++) {
            queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print("Query result: $queryAwal ");
        } else {
          print("tidak ada data");
        }
      }

      if (queryAwal.length != 0) {
        tempSearch.value = [];
        queryAwal.forEach((element) {
          if (element["name"].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        });
      }
    }
    queryAwal.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchCont = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchCont.dispose();
    super.onClose();
  }
}
