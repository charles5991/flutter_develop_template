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

import '../../module/order/view/order_v.dart';
import '../../module/test_fluro/page_d.dart';

class Routers {
  static FluroRouter router = FluroRouter();

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

  // 注册路由
  static _initRouter() {

    // 根页面
    router.define(
      root,
      handler: Handler(
        handlerFunc: (_, __) => AppMainPage(),
      ),
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
    );

    // 页面C 无参数
    router.define(
      pageC,
      handler: Handler(
        handlerFunc: (_, __) => PageCView(),
      ),
    );

    // 页面D 无参数
    router.define(
      pageD,
      handler: Handler(
        handlerFunc: (_, __) => PageDView(),
      ),
    );

    // 页面AddTool 无参数
    router.define(
      pageAddTool,
      handler: Handler(handlerFunc: (_, __) => PageAddToolView()),
    );

    // 引导页
    router.define(
      onboarding,
      handler: Handler(
        handlerFunc: (_, __) => OnboardingView(),
      ),
    );

    // Quota明细
    router.define(
      personalQuota,
      handler: Handler(handlerFunc: (_, __) => PersonalQuotaView()),
    );
  }

}
