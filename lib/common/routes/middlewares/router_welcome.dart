import 'package:cat_news/common/routes/routes.dart';
import 'package:cat_news/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 第一次欢迎页面
class RouteWelcomeMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  // @override
  // int? priority = 0;

  // RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (Global.isFirstOpen == true) {
      return null;
    } else if (Global.isOfflineLogin) {
      return const RouteSettings(name: AppRoutes.application);
    } else {
      return const RouteSettings(name: AppRoutes.signIn);
    }
  }
}
