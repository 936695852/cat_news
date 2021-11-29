import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/utils/utils.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:cat_news/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget recommendWidget(NewsItem item) {
  return Container(
    margin: EdgeInsets.all(20.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          child: imageCached(
            'https://dummyimage.com/335x290',
            width: 335,
            height: 290,
          ),
        ),
        // 作者
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: Text(
            item.author,
            style: TextStyle(
              fontFamily: 'Avenir',
              fontWeight: FontWeight.normal,
              color: AppColors.thirdElementText,
              fontSize: 14.sp,
            ),
          ),
        ),
        // 标题
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(top: 10.h),
            child: Text(
              item.title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
                fontSize: 24.sp,
                height: 1,
              ),
            ),
          ),
        ),
        // 一行 3 列
        Container(
          margin: EdgeInsets.only(top: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 分类
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 120,
                ),
                child: Text(
                  item.category,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.normal,
                    color: AppColors.secondaryElementText,
                    fontSize: 14.sp,
                    height: 1,
                  ),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
              ),
              // 添加时间
              Container(
                width: 15.w,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 120,
                ),
                child: Text(
                  '• ${duTimeLineFormat(item.addtime)}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppColors.thirdElementText,
                    fontSize: 14.sp,
                    height: 1,
                  ),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
              ),
              // 更多
              const Spacer(),
              InkWell(
                child: const Icon(
                  Icons.more_horiz,
                  color: AppColors.primaryText,
                  size: 24,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
