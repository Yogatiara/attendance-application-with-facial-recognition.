import 'dart:io';

class UserModel {
  int? userId;
  String? userName;
  String? email;
  int? nim;
  File? faceIamge;
  String? token;
  String message;

  UserModel(
      {this.userId,
      this.userName,
      this.email,
      this.nim,
      this.faceIamge,
      this.token,
      required this.message});
}
