import 'package:flutter/material.dart';

class SlideActionProvider extends ChangeNotifier {
  bool _isSlid = false;
  bool _isSlideEnabled = false;
  String _text = "Slide to check in";

  bool get isSlid => _isSlid;
  bool get isSlideEnabled => _isSlideEnabled;
  String get text => _text;

  void completeSlide() {
    _isSlid = true;
    notifyListeners();
  }

  set slideSwitch(bool action) {
    _isSlideEnabled = true;
    notifyListeners();
  }

  set setText(String text) {
    _text = text;
    notifyListeners();
  }
}
