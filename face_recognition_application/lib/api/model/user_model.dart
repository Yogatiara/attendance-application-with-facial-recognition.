import 'dart:io';

class User {
  String? userName;
  String? email;
  int? nim;
  File? faceIamge;
  String token;

  User(
      {this.userName,
      this.email,
      this.nim,
      this.faceIamge,
      required this.token});
}
