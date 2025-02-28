import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import '../../../../res/string/str_order.dart';
import '../../../../router/routers.dart';
import '../../../../router/navigator_util.dart';
import '../../../../res/string/str_common.dart';
import '../../../../res/style/color_styles.dart';
import '../../../../res/style/text_styles.dart';
import '../../../common/widget/global_notification_widget.dart';
import '../view_model/order_vm.dart';

class OrderView extends BaseStatefulPage {
  OrderView({super.key});

  @override
  OrderViewState createState() => OrderViewState();
}

class OrderViewState extends BaseStatefulPageState<OrderView, OrderViewModel> {
  late TestParamsModel paramsModel;

  @override
  void initAttribute() {
    paramsModel = TestParamsModel(
      name: 'jk',
      title: '张三',
      url: 'https://www.baidu.com',
      age: 99,
      price: 9.9,
      flag: true,
    );
  }

  @override
  void initObserver() {}

  @override
  OrderViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return OrderViewModel()..viewState = this;
  }

  bool executeSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert(() {
      debugPrint('PersonalView.didChangeDependencies --- $operate');
      return true;
    }());

    if (operate == GlobalOperate.switchLogin) {
      executeSwitchLogin = true;
      // 重新请求数据
      // viewModel.requestData();
    }
  }

  @override
  Widget appBuild(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppBarTheme.of(context).backgroundColor,
          title: Text(
            StrOrder.order,
            style: TextStyles.style_222222_20,
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'UPI'),
              Tab(text: 'BANK'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // UPI Tab
            Stack(
              children: [
                Column(
                  children: [
                    // UPI Card
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '880423000@ikwik',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '880423000',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Icon(Icons.person, color: Colors.indigo),
                                radius: 25,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Please relink the tool or modify the upi and relink',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              NavigatorUtil.push(
                                context,
                                Routers.pageA2,
                                arguments: {
                                  'name': 'jk',
                                  'title': '张三',
                                  'url': 'https://www.baidu.com',
                                  'age': 99,
                                  'price': 9.9,
                                  'flag': true,
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Authorize',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Add Tool Button
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[700],
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            NavigatorUtil.push(
                              context,
                              Routers.pageAddTool,
                            );
                          },
                          child: Text(
                            'Add Tool',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // BANK Tab (Empty for now)
            Center(child: Text('Bank tab content coming soon')),
          ],
        ),
      ),
    );
  }

  /// 上报 同步异常
  pushSyncError() {
    DateTime today = new DateTime.now();
    String dateSlug = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} ${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}:${today.second.toString().padLeft(2, '0')}";
    throw Exception("$dateSlug:发生 同步异常");
  }

  /// 上报 异步异常
  pushAsyncError() async {
    DateTime today = new DateTime.now();
    String dateSlug = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} ${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}:${today.second.toString().padLeft(2, '0')}";
    await Future.delayed(Duration(seconds: 1));
    throw Exception("$dateSlug:发生 异步异常");
  }

  @override
  bool get wantKeepAlive => true;

}

class TestParamsModel {
  String? name;
  String? title;
  String? url;
  int? age;
  double? price;
  bool? flag;

  TestParamsModel({
    this.name,
    this.title,
    this.url,
    this.age,
    this.price,
    this.flag,
  });

  @override
  String toString() {
    return 'TestParamsModel{name: $name, title: $title, url: $url, age: $age, price: $price, flag: $flag}';
  }
}
