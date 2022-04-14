import 'package:chat_app_getx_12_03_2022/app/controller/auth_controller.dart';
import 'package:chat_app_getx_12_03_2022/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controller/search_controller.dart';

class SearchPage extends GetView<SearchController> {
  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    // final controller = Get.find<SearchController>();
    final searchC = Get.put(SearchController());

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 85, 85, 85),
          title: Text('Search'),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onChanged: ((value) => controller.searchFriend(
                    value, authController.user.value.email!)),
                controller: searchC.searchCont,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  hintText: "Search",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 204, 204, 204)),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Get.isDarkMode
                            ? Color.fromARGB(255, 121, 121, 121)
                            : Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Get.isDarkMode
                            ? Color.fromARGB(255, 121, 121, 121)
                            : Color.fromARGB(255, 207, 207, 207)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 216, 216, 216),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(140),
      ),
      body: Obx(
        () => searchC.tempSearch.length == 0
            ? Center(
                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.7,
                      height: Get.height * 0.7,
                      child: Lottie.asset(
                        'assets/lottie/empty.json',
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: searchC.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  onTap: () => Get.toNamed(AppRoutes.CHAT),
                  leading: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:
                          controller.tempSearch[index]['photoUrl'] == "NoImage"
                              ? Image.asset('assets/logo/noimage.png',
                                  fit: BoxFit.cover)
                              : Image.network(
                                  controller.tempSearch[index]['photoUrl'],
                                  fit: BoxFit.cover,
                                ),
                    ),
                    radius: 32,
                  ),
                  title: Text(
                    "${searchC.tempSearch[index]["name"]}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("${searchC.tempSearch[index]["status"]}"),
                  trailing: GestureDetector(
                    onTap: () => authController
                        .addNewConnections(searchC.tempSearch[index]["email"]),
                    child: Chip(
                      label: Text("Message"),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
