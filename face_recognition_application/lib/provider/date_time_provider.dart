import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class DateTimeProvider with ChangeNotifier {
  String? _formattedTime;
  String? _formattedDate;
  String? _chekInTime;
  String? _chekOutTime;

  DateTime _now = DateTime.now();
  Timer? _timer;

  DateTimeProvider() {
    _formattedTime = DateFormat("hh:mm:ss a").format(_now);
    _formattedDate =
        DateFormat("dd MMM yyyy").format(_now); // Year, month, and day
    _startTimer();
  }

  String? get formattedTime => _formattedTime;
  String? get formattedDate => _formattedDate;
  String? get chekInTime => _chekInTime;
  String? get chekOutTime => _chekOutTime;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    _now = DateTime.now();
    _formattedTime = DateFormat("hh:mm:ss a").format(_now);
    _formattedDate = DateFormat("dd MMM yyyy").format(_now);
    notifyListeners(); // Notify listeners about the change
  }

  set setChekoutTime(String time) {
    _chekOutTime = time;
    notifyListeners();
  }

  set setChekInTime(String time) {
    _chekInTime = time;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
