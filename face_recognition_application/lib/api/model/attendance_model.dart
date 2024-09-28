import 'dart:io';

class AttendanceModel {
  String? action;
  String? status;
  File? targetFaceImage;
  String? dateTime;
  int? userId;
  String? userName;
  int? nim;
  double? lat;
  double? long;
  double? distance;
  String message;

  AttendanceModel({
    required this.message,
    this.userName,
    this.nim,
    this.lat,
    this.long,
    this.distance,
    this.action,
    this.status,
    this.targetFaceImage,
    this.dateTime,
    this.userId,
  });


  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      dateTime: json['date_time'],
      action: json['action'],
      status: json['status'], message: '',
    );
  }

}
