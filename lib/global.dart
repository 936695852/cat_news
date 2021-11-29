import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/utils/utils.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:flutter/material.dart';

class Global {
  // 用户配置
  static UserLoginResponseEntity? profile = UserLoginResponseEntity(
    accessToken: null,
  );

  // 是否第一次打开
  static bool isFirstOpen = false;

  // 是否离线登录
  static bool isOfflineLogin = false;

  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    // 运行初始化
    WidgetsFlutterBinding.ensureInitialized();

    // 工具初始
    await StorageUtil.init();
    HttpUtil();

    // 读取设备第一次打开
    bool isFirstOpen = !StorageUtil().getBool(storageDeviceAlreadyOpenKey);
    if (isFirstOpen) {
      StorageUtil().setBool(storageDeviceAlreadyOpenKey, true);
    }

    // 读取离线用户信息
    var _profileJSON = StorageUtil().getJSON(storageUserProfileKey);
    if (_profileJSON != null) {
      profile = UserLoginResponseEntity.fromJson(_profileJSON);
      isOfflineLogin = true;
    }

    // if (Platform.isAndroid) {
    //   SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    //     statusBarColor: AppColors.primaryBackground, //设置为透明
    //     statusBarIconBrightness: Brightness.dark,
    //   );
    //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // }
  }

  // 持久化 用户信息
  static Future<bool> saveProfile(UserLoginResponseEntity userResponse) {
    profile = userResponse;
    return StorageUtil().setJSON(storageUserProfileKey, userResponse.toJson());
  }
}
