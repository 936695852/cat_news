import 'package:cat_news/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ad广告
Widget adWidget() {
  return Container(
    alignment: Alignment.center,
    height: 100.h,
    padding: EdgeInsets.all(20.w),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        border: const Border.fromBorderSide(
          BorderSide(
            color: Color.fromARGB(255, 230, 230, 231),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tired of Ads? Get Premium - \$9.99",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontFamily: "Avenir",
              fontWeight: FontWeight.w400,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    ),
  );
}
