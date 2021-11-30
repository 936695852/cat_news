import 'dart:async';

import 'package:cat_news/common/api/api.dart';
import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/utils/utils.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:cat_news/pages/main/ad_widget.dart';
import 'package:cat_news/pages/main/category_widget.dart';
import 'package:cat_news/pages/main/channels_widget.dart';
import 'package:cat_news/pages/main/news_item_widget.dart';
import 'package:cat_news/pages/main/recommend_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final GlobalKey<RefreshIndicatorState> _indicatorKey =
      GlobalKey<RefreshIndicatorState>();

  NewsPageListResponseEntity? _newsPageList; // 新闻翻页
  NewsItem? _newsRecommend; // 新闻推荐
  List<CategoryResponseEntity>? _categories; // 分类
  List<ChannelResponseEntity>? _channels; // 频道

  String? _selCategoryCode; // 选中的分类code

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _loadLatesWithDiskCache();
  }

  void _loadAllData() async {
    _categories = await NewsAPI.categories(cacheDisk: true);
    _channels = await NewsAPI.channels(cacheDisk: true);
    _newsRecommend = await NewsAPI.newsRecommend(cacheDisk: true);
    _newsPageList = await NewsAPI.newsPageList(cacheDisk: true);

    _selCategoryCode = _categories?.first.code;

    if (mounted) {
      setState(() {});
    }
  }

  void _loadLatesWithDiskCache() {
    if (cacheEnable) {
      var cacheData = StorageUtil().getJSON(storageIndexNewsCacheKey);
      if (cacheData != null) {
        Timer(const Duration(seconds: 2), () {
          _indicatorKey.currentState?.show();
        });
      }
    }
  }

  // 拉取推荐、新闻
  _loadNewsData(
    categoryCode, {
    bool refresh = false,
  }) async {
    _selCategoryCode = categoryCode;
    _newsRecommend = await NewsAPI.newsRecommend(
      params: NewsRecommendRequestEntity(categoryCode: categoryCode),
      refresh: refresh,
      cacheDisk: true,
    );
    _newsPageList = await NewsAPI.newsPageList(
      params: NewsPageListRequestEntity(categoryCode: categoryCode),
      refresh: refresh,
      cacheDisk: true,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _indicatorKey,
      onRefresh: () async {
        await _loadNewsData(
          _selCategoryCode,
          refresh: true,
        );
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildCategories(),
            _buildRecommend(),
            _buildChannels(),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  // 分类菜单
  Widget _buildCategories() {
    return newCategoryWidget(
      categories: _categories,
      selCategoryCode: _selCategoryCode,
      onTap: (CategoryResponseEntity item) => {
        setState(() {
          _selCategoryCode = item.code;
        })
      },
    );
  }

  // 推荐阅读
  Widget _buildRecommend() {
    return _newsRecommend == null // 数据没到位，可以用骨架图展示
        ? Container()
        : recommendWidget(_newsRecommend!);
  }

  // 频道
  Widget _buildChannels() {
    return _channels == null
        ? Container()
        : newsChannelsWidget(
            channels: _channels!,
            onTap: (ChannelResponseEntity item) {},
          );
  }

  // 新闻列表
  Widget _buildNewsList() {
    return _newsPageList == null
        ? Container(
            height: (161 * 5 + 100.0).h,
          )
        : Column(
            children: _newsPageList!.items!.map((item) {
              // 新闻行
              List<Widget> widgets = <Widget>[
                newsItem(item),
                const Divider(height: 1),
              ];

              // 每 5 条 显示广告
              int index = _newsPageList!.items!.indexOf(item);
              if (((index + 1) % 5) == 0) {
                widgets.addAll(<Widget>[
                  adWidget(),
                  const Divider(height: 1),
                ]);
              }

              // 返回
              return Column(
                children: widgets,
              );
            }).toList(),
          );
  }

  // // ad 广告条
  // // 邮件订阅
  // Widget _buildEmailSubscribe() {
  //   return newsletterWidget();
  // }
}
