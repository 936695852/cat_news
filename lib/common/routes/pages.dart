import 'package:cat_news/pages/application/application.dart';
import 'package:cat_news/pages/category/category.dart';
import 'package:cat_news/pages/detail/detail.dart';
import 'package:cat_news/pages/sign_in/sign_in.dart';
import 'package:cat_news/pages/sign_up/sign_up.dart';
import 'package:cat_news/pages/welcome/welcome.dart';
import 'package:get/get.dart';

import 'routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.initial;

  static final List<GetPage> routes = [
    // 免登陆
    GetPage(
      name: AppRoutes.initial,
      page: () => const WelcomePage(),
      middlewares: [
        RouteWelcomeMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInPage(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpPage(),
    ),

    // 需要登录
    GetPage(
      name: AppRoutes.application,
      page: () => const ApplicationPage(),
      middlewares: [
        RouteAuthMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailPage(),
      middlewares: [
        RouteAuthMiddleware(),
      ],
    ),

    // 分类列表
    GetPage(
      name: AppRoutes.category,
      page: () => const CategoryPage(),
    ),
  ];
}
