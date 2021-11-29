import 'package:cat_news/common/routes/routes.dart';
import 'package:cat_news/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 检查是否登录
class RouteAuthMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  // @override
  // int? priority = 0;

  // RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (Global.isOfflineLogin ||
        route == AppRoutes.signIn ||
        route == AppRoutes.signUp ||
        route == AppRoutes.initial) {
      return null;
    } else {
      Future.delayed(
          const Duration(seconds: 1), () => Get.snackbar("提示", "登录过期,请重新登录"));
      return const RouteSettings(name: AppRoutes.signIn);
    }
  }
}
