// class UserModel {
//   String? uid;
//   String? name;
//   String? keyName;
//   String? email;
//   String? creationTime;
//   String? lastSignInTime;
//   String? photoUrl;
//   String? status;
//   String? updatedTime;
//   List<Chats>? chatsRoom;

//   UserModel(
//       {this.uid,
//       this.name,
//       this.keyName,
//       this.email,
//       this.creationTime,
//       this.lastSignInTime,
//       this.photoUrl,
//       this.status,
//       this.updatedTime,
//       this.chatsRoom});

//   UserModel.fromJson(Map<String, dynamic> json) {
//     uid = json['uid'];
//     name = json['name'];
//     keyName = json['keyName'];
//     email = json['email'];
//     creationTime = json['creationTime'];
//     lastSignInTime = json['lastSignInTime'];
//     photoUrl = json['photoUrl'];
//     status = json['status'];
//     updatedTime = json['updatedTime'];
//     if (json['chats'] != null) {
//       chatsRoom = <Chats>[];
//       json['chats'].forEach((v) {
//         chatsRoom!.add(new Chats.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['uid'] = this.uid;
//     data['name'] = this.name;
//     data['keyName'] = this.keyName;
//     data['email'] = this.email;
//     data['creationTime'] = this.creationTime;
//     data['lastSignInTime'] = this.lastSignInTime;
//     data['photoUrl'] = this.photoUrl;
//     data['status'] = this.status;
//     data['updatedTime'] = this.updatedTime;
//     if (this.chatsRoom != null) {
//       data['chats'] = this.chatsRoom!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Chats {
//   String? connection;
//   String? chatId;
//   String? lastTime;
//   int? totalUnread;

//   Chats({this.connection, this.chatId, this.lastTime, this.totalUnread});

//   Chats.fromJson(Map<String, dynamic> json) {
//     connection = json['connection'];
//     chatId = json['chat_id'];
//     lastTime = json['lastTime'];
//     totalUnread = json['total_unread'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['connection'] = this.connection;
//     data['chat_id'] = this.chatId;
//     data['lastTime'] = this.lastTime;
//     data['total_unread'] = this.totalUnread;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

UserModel usersModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String usersModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.name,
    this.keyName,
    this.email,
    this.creationTime,
    this.lastSignInTime,
    this.photoUrl,
    this.status,
    this.updatedTime,
    this.chatsRoom,
  });

  String? uid;
  String? name;
  String? keyName;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updatedTime;
  List<ChatUser>? chatsRoom;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        keyName: json["keyName"],
        email: json["email"],
        creationTime: json["creationTime"],
        lastSignInTime: json["lastSignInTime"],
        photoUrl: json["photoUrl"],
        status: json["status"],
        updatedTime: json["updatedTime"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "keyName": keyName,
        "email": email,
        "creationTime": creationTime,
        "lastSignInTime": lastSignInTime,
        "photoUrl": photoUrl,
        "status": status,
        "updatedTime": updatedTime,
      };
}

class ChatUser {
  ChatUser({
    this.connection,
    this.chatId,
    this.lastTime,
    this.totalUnread,
  });

  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        connection: json["connection"],
        chatId: json["chat_id"],
        lastTime: json["lastTime"],
        totalUnread: json["totalUnread"],
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "lastTime": lastTime,
        "totalUnread": totalUnread,
      };
}
