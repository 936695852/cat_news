import 'package:cat_news/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputTextEdit extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hintText;
  final bool isPassword;
  final double marginTop;

  const InputTextEdit({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.isPassword = false,
    this.marginTop = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(top: marginTop.h),
      decoration: const BoxDecoration(
        color: AppColors.secondaryElement,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 9),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 18.sp,
        ),
        autocorrect: false,
        obscureText: isPassword,
      ),
    );
  }
}
