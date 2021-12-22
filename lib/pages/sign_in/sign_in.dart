import 'package:cat_news/common/api/api.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/routes/routes.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:cat_news/common/widgets/widgets.dart';
import 'package:cat_news/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _handleSignIn() async {
    // if (!duIsEmail(_emailController.value.text)) {
    //   toastInfo(msg: '请输入正确的邮件');
    //   return;
    // }
    // if (!duCheckStringLength(_passController.value.text, 6)) {
    //   toastInfo(msg: '密码不能小于6位');
    //   return;
    // }

    UserLoginRequestEntity params = UserLoginRequestEntity(
      email: _emailController.value.text,
      password: _passController.value.text,
    );

    UserLoginResponseEntity res = await UserApi.login(params: params);
    Global.saveProfile(res);
    Get.offAndToNamed(AppRoutes.application);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              _buildLogo(),
              _buildInputForm(),
              const Spacer(),
              _buildThirdPartyLogin(),
              _buildSignupButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSignupButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: btnFlatButtonWidget(
        onPressed: () {
          Get.toNamed(AppRoutes.signUp);
        },
        width: 294,
        gbColor: AppColors.secondaryElement,
        fontColor: AppColors.primaryText,
        title: 'Sign up',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }

  Container _buildThirdPartyLogin() {
    return Container(
      width: 295.w,
      margin: EdgeInsets.only(bottom: 40.h),
      child: Column(
        children: [
          Text(
            'Or sign in with social networks',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              children: [
                btnFlatButtonBorderOnlyWidget(
                  onPressed: () {},
                  width: 88,
                ),
                const Spacer(),
                btnFlatButtonBorderOnlyWidget(
                  onPressed: () {},
                  width: 88,
                ),
                const Spacer(),
                btnFlatButtonBorderOnlyWidget(
                  onPressed: () {},
                  width: 88,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildInputForm() {
    return Container(
      width: 295.w,
      margin: EdgeInsets.only(top: 49.h),
      child: Column(
        children: [
          InputTextEdit(
            controller: _emailController,
            hintText: 'Email',
          ),
          InputTextEdit(
            controller: _passController,
            hintText: 'Password',
            isPassword: true,
          ),
          Container(
            height: 44.h,
            margin: EdgeInsets.only(top: 15.h),
            child: Row(
              children: [
                btnFlatButtonWidget(
                  onPressed: () {},
                  gbColor: AppColors.thirdElement,
                  title: 'Sign up',
                ),
                const Spacer(),
                btnFlatButtonWidget(
                  onPressed: _handleSignIn,
                  gbColor: AppColors.primaryElement,
                  title: 'Sign in',
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.h),
            child: TextButton(
              onPressed: () => {},
              child: Text(
                'Fogot password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryElementText,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildLogo() {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(top: (40 + 44.0).h), // 顶部导航栏 44px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 76.w,
            width: 76.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 76.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(38, 27, 27, 29),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular((76 * 0.5).w),
                      ), // 父容器的50%
                    ),
                  ),
                ),
                Positioned(
                  top: 13.w,
                  child: Image.network(
                    'https://dummyimage.com/36x48',
                    fit: BoxFit.none,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Text(
              "SECTOR",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
                height: 1,
              ),
            ),
          ),
          Text(
            "news",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
