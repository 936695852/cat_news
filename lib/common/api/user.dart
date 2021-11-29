import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/utils/utils.dart';

class UserApi {
  static Future<UserLoginResponseEntity> login(
      {required UserLoginRequestEntity params}) async {
    var response = await HttpUtil().post('/user/login', params: params);
    return UserLoginResponseEntity.fromJson(response);
  }
}
