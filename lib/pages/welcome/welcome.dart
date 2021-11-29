import 'package:cat_news/common/routes/routes.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            _buildPageHeadTitle(),
            _buildPageHeadDetail(),
            _buildFeatureItem(
                'Feature-1', '蓝湖上我右键点击设计稿不会出现下载的面板，是因为我没权限拟拟拟拟吗。。', 86),
            _buildFeatureItem(
                'Feature-2', '猫哥，Avenir-BooemiBold.ttf 这两个字体文件是网站下载的', 40),
            _buildFeatureItem('Feature-3',
                '请问 windows系统也能够用 iOS模拟器 吗? (are 或 VirtualBox.. 这种虚拟拟拟拟机)', 40),
            const Spacer(),
            _buildStartButton()
          ],
        ),
      ),
    );
  }

  Container _buildStartButton() {
    return Container(
      width: 295.w,
      height: 44.h,
      margin: EdgeInsets.only(bottom: 20.h),
      child: TextButton(
        onPressed: () {
          Get.offAndToNamed(AppRoutes.signIn);
        },
        child: const Text('Get Start'),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primaryElement,
          primary: AppColors.primaryElementText,
        ),
      ),
    );
  }

  Container _buildFeatureItem(String title, String intro, double marginTop) {
    return Container(
      width: 295.w,
      height: 80.h,
      margin: EdgeInsets.only(top: marginTop.h),
      child: Row(
        children: [
          SizedBox(
            width: 80.r,
            height: 80.r,
            child: Image.network(
              'https://dummyimage.com/80',
              fit: BoxFit.none,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 200.w,
            child: Text(
              intro,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 15.sp,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPageHeadDetail() {
    return Container(
      width: 242.w,
      height: 70.h,
      margin: EdgeInsets.only(top: 14.h),
      child: Text(
        '不过在跟着写的时候, 不再需要手动减去状态栏的高度, 直接填入原始高度即可?',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          height: 1.3,
        ),
      ),
    );
  }

  Container _buildPageHeadTitle() {
    return Container(
      margin: EdgeInsets.only(top: 60.h),
      child: Text(
        'Features',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}
