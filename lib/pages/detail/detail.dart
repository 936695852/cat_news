import 'dart:io';
import 'dart:async';

import 'package:cat_news/common/entities/entities.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:cat_news/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final NewsItem item = Get.arguments;
  bool _isPageFinished = false;

  @override
  void initState() {
    super.initState();
    print(Get.parameters['id']);
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  double _webViewHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildPageTitle(),
                  const Divider(height: 1),
                  _buildPageHeader(),
                  _buildWebView(),
                ],
              ),
            ),
            _isPageFinished == true
                ? const SizedBox()
                : const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
          ],
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return transparentAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark_border,
              color: AppColors.primaryText,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
              color: AppColors.primaryText,
            ),
            onPressed: () {
              Share.share('${item.title} ${item.url}');
            },
          ),
        ]);
  }

  // 页标题
  Widget _buildPageTitle() {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // 标题
              Text(
                item.category,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.normal,
                  fontSize: 30.sp,
                  color: AppColors.thirdElement,
                ),
              ),
              // 作者
              Text(
                item.author,
                style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.normal,
                  fontSize: 14.sp,
                  color: AppColors.thirdElementText,
                ),
              ),
            ],
          ),
          const Spacer(),
          // 标志
          CircleAvatar(
            //头像半径
            radius: 22.w,
            backgroundImage: const NetworkImage(
              'https://dummyimage.com/22x22',
            ),
          ),
        ],
      ),
    );
  }

  // 页头部
  Widget _buildPageHeader() {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 图
          imageCached(
            item.thumbnail,
            width: 335,
            height: 290,
          ),
          // 标题
          Container(
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
                    '• ${item.addtime}',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildWebView() {
    return SizedBox(
      height: _webViewHeight,
      child: WebView(
        initialUrl: '$serveApiUrl/news/content/${item.id}',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>{
          JavascriptChannel(
              name: 'Invoke',
              onMessageReceived: (JavascriptMessage message) {
                print(message.message);
                var webHeight = double.parse(message.message);
                setState(() {
                  _webViewHeight = webHeight;
                });
              })
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url != '$serveApiUrl/news/content/${item.id}') {
            toastInfo(msg: request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: _getWebViewHeight,
        gestureNavigationEnabled: true,
      ),
    );
  }

  void _getWebViewHeight(String url) async {
    await (await _controller.future).runJavascript('''
              try {
                // Invoke.postMessage([document.body.clientHeight,document.documentElement.clientHeight,document.documentElement.scrollHeight]);
                let scrollHeight = document.documentElement.scrollHeight;
                if (scrollHeight) {
                  Invoke.postMessage(scrollHeight);
                }
              } catch {}
          ''');
    setState(() {
      _isPageFinished = true;
      print(_isPageFinished);
    });
  }
}
