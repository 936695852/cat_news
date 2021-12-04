import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/utils/utils.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:cat_news/common/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 新闻行 Item
Widget newsItem(NewsItem item) {
  return Container(
    height: 161.h,
    padding: EdgeInsets.all(20.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 图
        InkWell(
          onTap: () {},
          child: SizedBox(
            width: 121,
            height: 121,
            child: imageCached(
              'https://dummyimage.com/121',
              width: 121,
              height: 121,
            ),
          ),
        ),
        // 右侧
        SizedBox(
          width: 194.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 作者
              Container(
                margin: const EdgeInsets.all(0),
                child: Text(
                  item.author,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.normal,
                    color: AppColors.thirdElementText,
                    fontSize: 14.sp,
                    height: 1,
                  ),
                ),
              ),
              // 标题
              InkWell(
                onTap: () {
                  Get.toNamed("/detail/1", arguments: item);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                      fontSize: 16.sp,
                      height: 1,
                    ),
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                  ),
                ),
              ),
              // Spacer
              const Spacer(),
              // 一行 3 列
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 分类
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 60.w,
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
                  SizedBox(
                    width: 15.w,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 100.w,
                    ),
                    child: Text(
                      '• ${duTimeLineFormat(item.addtime)}',
                      style: TextStyle(
                        fontFamily: 'Avenir',
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
            ],
          ),
        ),
      ],
    ),
  );
}
