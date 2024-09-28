class ErrorModel {
  int? statusCode;
  String detail;
  String? data;
  bool? dataBool;

  ErrorModel({this.statusCode, required this.detail, this.data, this.dataBool});
}
