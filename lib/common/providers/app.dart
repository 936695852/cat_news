import 'package:flutter/material.dart';

// 系统相应状态
class AppState with ChangeNotifier {
  bool _isGrayFilter = false;

  get isGrayFilter => _isGrayFilter;

  // 切换灰色滤镜
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }
}
