import 'dart:io';

class AttendanceModel {
  String? action;
  String? status;
  File? targetFaceImage;
  String? dateTime;
  int? userId;
  String userName;
  int nim;
  String message;

  AttendanceModel({
    required this.message,
    required this.userName,
    required this.nim,
    this.action,
    this.status,
    this.targetFaceImage,
    this.dateTime,
    this.userId,
  });
}
