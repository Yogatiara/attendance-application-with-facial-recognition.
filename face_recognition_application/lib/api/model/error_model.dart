class ErrorModel {
  int? statusCode;
  String detail;
  String? data;

  ErrorModel({this.statusCode, required this.detail, this.data});
}
