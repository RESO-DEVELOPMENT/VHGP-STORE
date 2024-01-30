// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());
String userToJsonUpdate(UserModel data) => json.encode(data.toJsonUpdate());
String userToJsonUpdateName(UserModel data) =>
    json.encode(data.toJsonUpdateName());

class UserModel {
  String id;
  dynamic password;
  String name;
  String roleId;
  dynamic status;
  dynamic imageUrl;

  UserModel({
    required this.id,
    this.password,
    required this.name,
    required this.roleId,
    this.status,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        password: json["password"],
        name: json["name"],
        roleId: json["roleId"],
        status: json["status"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "name": name,
        "roleId": roleId,
        "status": status,
        "imageUrl": imageUrl
      };

  Map<String, dynamic> toJsonUpdate() =>
      {"id": id, "name": name, "imageUrl": imageUrl};
  Map<String, dynamic> toJsonUpdateName() =>
      {"id": id, "name": name, "imageUrl": null};
}
