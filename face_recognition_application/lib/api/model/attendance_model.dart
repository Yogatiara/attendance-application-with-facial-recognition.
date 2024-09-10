import 'dart:io';

class AttendanceModel {
  String? action;
  String? timeStamp;
  String? status;
  File? faceIamge;

  AttendanceModel({
    this.action,
    this.timeStamp,
    this.status,
    this.faceIamge,
  });
}
