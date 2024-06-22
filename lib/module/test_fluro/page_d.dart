import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

import '../../common/res/string/strings.dart';
import '../../common/router/navigator_util.dart';
import '../../main/app.dart';

class PageDView extends BaseStatefulPage {
  PageDView({super.key});

  @override
  PageDViewState createState() => PageDViewState();
}

class PageDViewState extends BaseStatefulPageState<PageDView,PageDViewModel> {

  @override
  void initAttribute() {

  }

  @override
  void initObserver() {

  }

  @override
  PageDViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PageDViewModel()..viewState = this;
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.pageD),
      ),
      body: SizedBox(
        width: media!.size.width,
        height: media!.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                /// 这种是，先销毁所有路由，再新建
                // NavigatorUtil.push(
                //   context,
                //   Routers.root,
                //   clearStack: true,
                //   transition: TransitionType.none,
                // );

                /// 这种是 按照 栈 先进后出的原则，回退到根页面
                NavigatorUtil.back(context,toRoot: true);
              },
              child: Text(Strings.toHomeDestroyAll),
            ),
          ],
        ),
      ),
    );
  }

}

class PageDViewModel extends PageViewModel<PageDViewState> {

  @override
  onCreate() {

  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }

}
