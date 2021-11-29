import 'package:cat_news/common/values/values.dart';
import 'package:cat_news/common/widgets/widgets.dart';
import 'package:cat_news/pages/account/account.dart';
import 'package:cat_news/pages/book_marks/book_marks.dart';
import 'package:cat_news/pages/category/category.dart';
import 'package:cat_news/pages/main/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  int _page = 0;
  late PageController _pageController;

  final List<String> _tabTitle = [
    'Welcome',
    'Category',
    'BookMarks',
    'Account'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // tab栏动画
  void _handleNavBarTap(int index) {
    _pageController.jumpToPage(index);
  }

  // tab栏页码切换
  void _handlePageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  final List<BottomNavigationBarItem> _bottomTabs =
      const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_filled,
        color: AppColors.tabBarElement,
      ),
      activeIcon: Icon(
        Icons.home_filled,
        color: AppColors.secondaryElementText,
      ),
      label: 'main',
      backgroundColor: AppColors.primaryBackground,
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.grid_3x3_rounded,
        color: AppColors.tabBarElement,
      ),
      activeIcon: Icon(
        Icons.grid_3x3_rounded,
        color: AppColors.secondaryElementText,
      ),
      label: 'category',
      backgroundColor: AppColors.primaryBackground,
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.catching_pokemon_sharp,
        color: AppColors.tabBarElement,
      ),
      activeIcon: Icon(
        Icons.catching_pokemon_sharp,
        color: AppColors.secondaryElementText,
      ),
      label: 'tag',
      backgroundColor: AppColors.primaryBackground,
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.face_sharp,
        color: AppColors.tabBarElement,
      ),
      activeIcon: Icon(
        Icons.face_sharp,
        color: AppColors.secondaryElementText,
      ),
      label: 'my',
      backgroundColor: AppColors.primaryBackground,
    ),
  ];

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: _bottomTabs,
      currentIndex: _page,
      type: BottomNavigationBarType.fixed,
      onTap: _handleNavBarTap,
    );
  }

  PageView _buildPageView() {
    return PageView(
      controller: _pageController,
      children: const <Widget>[
        MainPage(),
        CategoryPage(),
        BookMarksPage(),
        AccountPage(),
      ],
      onPageChanged: _handlePageChanged,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return transparentAppBar(
      title: Text(
        _tabTitle[_page],
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
