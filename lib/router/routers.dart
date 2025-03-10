import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_develop_template/main/app.dart';
// import 'package:flutter_develop_template/module/test_fluro/page_a.dart';
import 'package:flutter_develop_template/module/test_fluro/page_a2.dart';
import 'package:flutter_develop_template/module/test_fluro/page_b.dart';
import 'package:flutter_develop_template/module/test_fluro/page_c.dart';
import 'package:flutter_develop_template/module/test_fluro/page_personal_quota.dart';
import 'package:flutter_develop_template/module/test_fluro/page_addTool.dart';
import 'package:flutter_develop_template/module/onboarding/view/onboarding_v.dart';
import 'package:flutter/cupertino.dart';

import '../../module/order/view/order_v.dart';
import '../../module/test_fluro/page_d.dart';
import 'package:flutter_develop_template/module/test_fluro/page_change_password.dart';
import 'package:flutter_develop_template/module/test_fluro/page_change_pin.dart';
import 'package:flutter_develop_template/module/test_fluro/page_deposit.dart';
import 'package:flutter_develop_template/module/test_fluro/page_withdrawal.dart';
import 'package:flutter_develop_template/module/test_fluro/page_inbox.dart';
import 'package:flutter_develop_template/module/test_fluro/page_service.dart';
import 'package:flutter_develop_template/module/auth/view/login_page.dart';

class Routers {
  static FluroRouter router = FluroRouter();

  // Add this transition configuration
  static final TransitionType _transitionType = TransitionType.fadeIn;
  static final Duration _transitionDuration = Duration(milliseconds: 300);

  // 配置路由
  static void configureRouters() {
    router.notFoundHandler = Handler(handlerFunc: (_, __) {
      // 找不到路由时，返回指定提示页面
      return Scaffold(
        body: const Center(
          child: Text('404'),
        ),
      );
    });

    // 初始化路由
    _initRouter();
  }

  // 设置页面

  // 页面标识
  static String root = '/';

  // 页面A
  static String pageA = '/pageA';

  // 页面A2
  static String pageA2 = '/pageA2';

  // 页面B
  static String pageB = '/pageB';

  // 页面C
  static String pageC = '/pageC';

  // 页面D
  static String pageD = '/pageD';

  // 页面AddTool
  static String pageAddTool = '/pageAddTool';

  // 引导页
  static String onboarding = "/onboarding";

  // Quota明细
  static String personalQuota = "/personalQuota";

  // Add these new routes
  static String personalPassword = "/personal/password";
  static String personalPin = "/personal/pin";
  static String personalInbox = "/personal/inbox";
  static String personalDeposit = "/personal/deposit";
  static String personalWithdrawal = "/personal/withdrawal";
  static String personalService = "/personal/service";

  // Add login route
  static String login = '/login';

  // 注册路由
  static _initRouter() {
    // Root page with fade transition
    router.define(
      root,
      handler: Handler(
        handlerFunc: (_, __) => AppMainPage(),
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // 页面A 需要 非对象类型 参数（通过 拼接 传参数）
    // router.define(
    //   pageA,
    //   handler: Handler(
    //     handlerFunc: (_, Map<String, List<String>> params) {

    //       // 获取路由参数
    //       String? name = arguments['name'] as String?;
    //       String? upi = arguments['upi'] as String?;
    //       int? acc = arguments['acc'] as int?;

    //       return PageAView(
    //         name: name,
    //         upi: upi,
    //         acc: acc,
    //       );

    //     },
    //   ),
    // );

    // 页面A2 需要 非对象类型 参数（通过 arguments 传参数）
    router.define(
      pageA2,
      handler: Handler(
        handlerFunc: (context, _) {
          // Fix 1: Get arguments from context.settings
          final arguments = context?.settings?.arguments as Map<String, dynamic>?;
          
          // Fix 2: Handle null arguments case
          if (arguments == null) {
            return PageA2View();
          }

          // Fix 3: Convert acc to String since it's coming as String from the UI
          String? name = arguments['name'] as String?;
          String? upi = arguments['upi'] as String?;
          String? acc = arguments['acc'] as String?;  // Changed from int? to String?

          return PageA2View(
            name: name,
            upi: upi,
            acc: acc,
          );
        },
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // 页面B 需要 对象类型 参数
    router.define(
      pageB,
      handler: Handler(
        handlerFunc: (context, Map<String, List<String>> params) {
          // 获取路由参数
          TestParamsModel? paramsModel = context?.settings?.arguments as TestParamsModel?;
          return PageBView(paramsModel: paramsModel);
        },
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // 页面C 无参数
    router.define(
      pageC,
      handler: Handler(
        handlerFunc: (_, __) => PageCView(),
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // 页面D 无参数
    router.define(
      pageD,
      handler: Handler(
        handlerFunc: (_, __) => PageDView(),
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // 页面AddTool 无参数
    router.define(
      pageAddTool,
      handler: Handler(
        handlerFunc: (_, __) => PageAddToolView(),
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // 引导页
    router.define(
      onboarding,
      handler: Handler(
        handlerFunc: (_, __) => OnboardingView(),
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );

    // Quota明细
    router.define(
      personalQuota,
      handler: Handler(handlerFunc: (_, __) => PagePersonalQuota()),
    );

    // Add these new route handlers
    router.define(personalPassword, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PageChangePassword();
      }
    ));
    
    router.define(personalPin, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PageChangePin();
      }
    ));

    // Add these new route handlers
    router.define(personalDeposit, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PageDeposit();
      }
    ));
    
    router.define(personalWithdrawal, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PageWithdrawal();
      }
    ));

    router.define(personalInbox, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PageInbox();
      }
    ));

    router.define(personalService, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PageService();
      }
    ));

    // Add login route definition
    router.define(
      login,
      handler: Handler(
        handlerFunc: (_, __) => LoginPage(),
      ),
      transitionType: _transitionType,
      transitionDuration: _transitionDuration,
    );
  }
}
