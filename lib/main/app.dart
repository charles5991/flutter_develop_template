import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import '../../router/page_route_observer.dart';
import '../../router/routers.dart';
import 'package:flutter_develop_template/common/widget/global_notification_widget.dart';
import 'package:flutter_develop_template/module/message/view/message_v.dart';
import 'package:flutter_develop_template/router/navigator_util.dart';

import '../../res/style/color_styles.dart';
import '../../res/style/theme_styles.dart';
import '../module/home/view/home_v.dart';
import '../module/order/view/order_v.dart';
import '../module/personal/view/personal_v.dart';
import '../module/teams/view/teams_v.dart';
import '../module/auth/service/auth_service.dart';

/// App初始化的第一个页面可能是 其他页面，比如 广告、引导页、登陆页面
enum AppInitState {
  /// 是App主体页面
  isAppMainPage,

  /// 不是主体页面
  noAppMainPage
}

/// 全局key
/// 获取全局context方式：navigatorKey.currentContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 这个对象 可以获取当前设配信息
MediaQueryData? media;

/// 监听全局路由，比如获取 当前路由栈里 页面总数
PageRouteObserver? pageRouteObserver;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isFirstLaunch = await checkIfFirstLaunch();
      bool isLoggedIn = await AuthService.isLoggedIn();
      
      if (isFirstLaunch) {
        NavigatorUtil.push(navigatorKey.currentContext!, Routers.onboarding);
      } else if (!isLoggedIn) {
        NavigatorUtil.push(navigatorKey.currentContext!, Routers.login);
      } else {
        NavigatorUtil.push(navigatorKey.currentContext!, Routers.root);
      }
    });
  }
  
  // Helper method to check first launch
  Future<bool> checkIfFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
    return isFirstLaunch;
  }

  @override
  Widget build(BuildContext context) {

    /// 初始化 MediaQuery、PageRouteObserver
    media ??= MediaQuery.of(context);
    pageRouteObserver ??= PageRouteObserver();

    return GlobalOperateProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [pageRouteObserver!],
        // 全局key
        navigatorKey: navigatorKey,
        // 使用路由找不到页面时，就会执行 onGenerateRoute
        onGenerateRoute: Routers.router.generator,
        theme: ThemeStyles.defaultTheme,
        // PopScope：监听返回键
        home: PopScope(
            // WillPopScope 3.16中过时，使用PopScope替换
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }

              // 这里使用 Navigator.of(context).pop(); 是无效的
              // 使用SystemNavigator.pop() 或者 exit()

              // SystemNavigator.pop()：用于在导航堆栈中弹出最顶层的页面，并在导航堆栈为空时退出应用程序
              // 平台兼容性：如果你只用Flutter做Android应用，优先使用 SystemNavigator.pop() 来退出应用程序。

              // exit()：直接终止应用程序的运行。
              // 平台兼容性：适用于所有平台（Android、iOS等）

              // 写逻辑代码
              // ...

              exit(0); // 退出应用
            },
            child: AppTransfer(
              initState: AppInitState.isAppMainPage,
            )),
      ),
    );
  }
}

/// 这个是用来中转的，比如初始化第一个启动的页面 可能是 广告、引导页、登陆页面，之后再从这些页面进入 App主体页面
class AppTransfer extends StatelessWidget {
  const AppTransfer({super.key, required this.initState});

  final AppInitState initState;

  @override
  Widget build(BuildContext context) {
    Widget child; // MaterialApp
    switch (initState) {
      case AppInitState.isAppMainPage:
        {
          // 先判断是否登陆
          // ... ...
          child = AppMainPage();
        }
        break;
      default:
        // 进入 广告、引导页 等等，再从这些页面进入 App首页
        child = AppMainPage();
    }
    return child;
  }
}

/// 这是App主体页面，主要是 PageView + BottomNavigationBar
class AppMainPage extends BaseStatefulPage {
  AppMainPage({super.key});

  @override
  AppMainPageState createState() => AppMainPageState();
}

class AppMainPageState extends BaseStatefulPageState<AppMainPage,AppMainPageViewModel> {

  PageController? pageController;

  @override
  void initAttribute() {
    pageController ??= PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  void initObserver() {

  }

  @override
  AppMainPageViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return AppMainPageViewModel()..viewState = this;
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  void pageChanged(int index) {
    bottomSelectedIndex = index;
  }

  void bottomTap(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController?.jumpToPage(index);
    });
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline),
        activeIcon: Icon(Icons.chat_bubble),
        label: 'Deposit'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.build_outlined),
        activeIcon: Icon(Icons.build),
        label: 'Tools'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_outline),
        activeIcon: Icon(Icons.people),
        label: 'Teams'
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Assets'
      ),
    ];
  }

  Widget buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: pageChanged,
      children: <Widget>[
        HomeView(),       // Home
        MessageView(),    // Deposit
        OrderView(),      // Tools (you might want to create a dedicated ToolsView)
        TeamsView(),      // Teams
        PersonalView(),   // Assets
      ],
    );
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) => _buildNavItem(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final List<IconData> unselectedIcons = [
      Icons.home_outlined,                    // Home icon
      Icons.account_balance_wallet_outlined,  // Wallet/Money icon for Deposit
      Icons.build_circle_outlined,            // Tools icon
      Icons.groups_outlined,                  // Teams icon
      Icons.person_outlined,                  // Person icon for Assets
    ];

    final List<IconData> selectedIcons = [
      Icons.home,                         // Filled home icon
      Icons.account_balance_wallet,       // Filled wallet icon
      Icons.build_circle,                 // Filled tools icon
      Icons.groups,                       // Filled teams icon
      Icons.person,                       // Filled person icon
    ];

    final List<String> labels = ['Home', 'Deposit', 'Tools', 'Teams', 'Assets'];

    return GestureDetector(
      onTap: () => bottomTap(index),
      child: Container(
        width: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bottomSelectedIndex == index 
                    ? Colors.grey[200] 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  bottomSelectedIndex == index 
                      ? selectedIcons[index] 
                      : unselectedIcons[index],
                  key: ValueKey<bool>(bottomSelectedIndex == index),
                  color: bottomSelectedIndex == index 
                      ? Colors.black 
                      : Colors.grey,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 10,
                color: bottomSelectedIndex == index 
                    ? Colors.black 
                    : Colors.grey,
                fontWeight: bottomSelectedIndex == index 
                    ? FontWeight.w500 
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class AppMainPageViewModel extends PageViewModel<AppMainPageState> {

  @override
  onCreate() {

  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }

}
