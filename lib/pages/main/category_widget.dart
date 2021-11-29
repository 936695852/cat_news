import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget newCategoryWidget({
  List<CategoryResponseEntity>? categories,
  String? selCategoryCode,
  required Function(CategoryResponseEntity) onTap,
}) {
  return categories == null
      ? const SizedBox()
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: categories
                  .map((item) => Container(
                        alignment: Alignment.center,
                        height: 52.h,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: selCategoryCode == item.code
                                  ? AppColors.secondaryElementText
                                  : AppColors.primaryText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () => onTap(item),
                        ),
                      ))
                  .toList()),
        );
}
