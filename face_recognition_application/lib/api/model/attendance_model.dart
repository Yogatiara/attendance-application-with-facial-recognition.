import 'dart:io';

class AttendanceModel {
  String? action;
  String? status;
  File? targetFaceImage;
  String? time;
  String? date;
  int? userId;

  AttendanceModel({
    this.action,
    this.status,
    this.targetFaceImage,
    this.time,
    this.date,
    this.userId,
  });
}
