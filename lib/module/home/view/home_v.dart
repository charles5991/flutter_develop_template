import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import '../../../../res/string/str_home.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/module/home/view_model/home_vm.dart';

import '../../../../res/string/str_common.dart';
import '../../../../res/style/color_styles.dart';
import '../../../../res/style/text_styles.dart';
import '../../../common/widget/global_notification_widget.dart';
import '../model/home_list_m.dart';

class HomeView extends BaseStatefulPage<HomeViewModel> {
  HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends BaseStatefulPageState<HomeView, HomeViewModel> {

  @override
  HomeViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return HomeViewModel()..viewState = this;
  }

  @override
  void initAttribute() {
    // Initialize with data immediately to prevent initial loading state
    Future.microtask(() {
      if (viewModel?.pageDataModel?.type == NotifierResultType.loading) {
        viewModel?.requestData(params: {'curPage': 1});
      }
    });
  }

  @override
  void initObserver() {}

  @override
  void dispose() {
    assert((){
      debugPrint('HomeView.onDispose()');
      return true;
    }());

    /// BaseStatefulPageState的子类，重写 dispose()
    /// 一定要执行父类 dispose()，防止内存泄漏
    super.dispose();
  }

  bool executeSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert((){
      debugPrint('HomeView.didChangeDependencies --- $operate');
      return true;
    }());

    // 切换用户
    // 正常业务流程是：从本地存储，拿到当前最新的用户ID，请求接口，我这里偷了个懒 😄
    // 直接使用随机数，模拟 不同用户ID
    if (operate == GlobalOperate.switchLogin) {
      executeSwitchLogin = true;

      // 重新请求数据
      // 如果你想刷新的时候，显示loading，加上这两行
      // viewModel?.pageDataModel?.type = NotifierResultType.loading;
      // viewModel?.pageDataModel?.refreshState();

      viewModel?.requestData(params: {'curPage': Random().nextInt(10)});
    } else if (!executeSwitchLogin && viewModel?.pageDataModel?.type == NotifierResultType.loading) {
      // Initialize with data if we're in loading state on first load
      viewModel?.requestData(params: {'curPage': 1});
    }
  }

  ValueNotifier<int> tapNum = ValueNotifier<int>(0);

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        centerTitle: true,
        /// 局部刷新
        title: ValueListenableBuilder<int>(
          valueListenable: tapNum,
          builder: (context, value, _) {
            return Image.asset(
              'assets/images/logo.png',
              height: 40,
              fit: BoxFit.contain,
            );
          },
        ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       tapNum.value += 1;
          //     },
          //     icon: const Icon(Icons.add)),
          // IconButton(
          //     onPressed: () {
          //       viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
          //     },
          //     icon: const Icon(Icons.refresh)),
          // IconButton(
          //     onPressed: () {
          //       // 如果你想刷新的时候，显示loading，加上这两行
          //       viewModel?.pageDataModel?.type = NotifierResultType.loading;
          //       viewModel?.pageDataModel?.refreshState();

          //       viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
          //     },
          //     icon: const Icon(Icons.refresh_sharp))
        ],
      ),
      body: NotifierPageWidget<PageDataModel>(
          model: viewModel?.pageDataModel,
          builder: (context, dataModel) {
            final data = dataModel.data as HomeListModel?;
            if(data != null) {
              /// 延迟一帧
              WidgetsBinding.instance.addPostFrameCallback((_){
                /// 赋值、并替换 HomeListModel 内的tapNum，建立联系
                tapNum.value = data.pageCount ?? 0;
                data.tapNum = tapNum;
              });
            }
            return RefreshIndicator(
              onRefresh: () async {
                // Force UI to rebuild with new random values
                setState(() {});
                // Optional: refresh data from viewModel if needed
                // await viewModel?.requestData(params: {'curPage': Random().nextInt(10)});
                return Future.delayed(Duration(milliseconds: 800));
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Carousel widget
                    CarouselSection(),
                    
                    // Card with chart
                    TransactionCard(),
                    
                    // Help section
                    HelpSection(),
                    
                    SizedBox(height: 80),
                    // Original content
                    // Container(
                    //   height: 200, // Fixed height to prevent overflow
                    //   child: Stack(
                    //     children: [
                    //       ListView.builder(
                    //           padding: EdgeInsets.zero,
                    //           itemCount: data?.datas?.length ?? 0,
                    //           itemBuilder: (context, index) {
                    //             return Container(
                    //               width: MediaQuery.of(context).size.width,
                    //               height: 50,
                    //               alignment: Alignment.center,
                    //               child: Text('${data?.datas?[index].title}'),
                    //             );
                    //           }),
                    //       Container(
                    //         color: ColorStyles.color_transparent,
                    //         child: executeSwitchLogin
                    //             ? Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(StrCommon.executeSwitchUser),
                    //             IconButton(
                    //                 onPressed: () {
                    //                   executeSwitchLogin = false;
                    //                   setState(() {});
                    //                 },
                    //                 icon: Icon(Icons.close))
                    //           ],
                    //         )
                    //             : SizedBox(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

    /// 是否保存页面状态
    @override
    bool get wantKeepAlive => true;

    // Carousel widget
    Widget CarouselSection() {
      return Column(
        children: [
          Container(
            height: 150,
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
              children: [
                _buildCarouselItem('Umoney', Colors.blue),
                _buildCarouselItem('Share & Earn', Colors.orange),
                _buildCarouselItem('Quick Transfer', Colors.green),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => 
              Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == index 
                      ? Colors.blue 
                      : Colors.grey.shade300,
                ),
              )
            ),
          ),
        ],
      );
    }
    
    Widget _buildCarouselItem(String text, Color color) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Transaction card with chart
    Widget TransactionCard() {
      // Generate random amounts between 100 and 5000
      final transactionAmount = Random().nextInt(4900) + 100;
      final withdrawAmount = Random().nextInt(transactionAmount);
      
      return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Withdraw (Opening)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.more_vert),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // Simple pie chart
                Container(
                  width: 100,
                  height: 100,
                  child: CustomPaint(
                    painter: PieChartPainter(
                      percentage: withdrawAmount / transactionAmount,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Transaction',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹ $transactionAmount',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Today Withdraw',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹ $withdrawAmount',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Help section
    Widget HelpSection() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            _buildHelpItem(
              icon: Icons.help_outline,
              title: 'How to use Umoney',
              subtitle: 'Detail',
              iconColor: Colors.blue,
            ),
            SizedBox(height: 15),
            _buildHelpItem(
              icon: Icons.account_balance_wallet,
              title: 'Earn money using Mobikwik wallet?',
              subtitle: 'Watch Video >',
              iconColor: Colors.blue,
            ),
          ],
        ),
      );
    }

    Widget _buildHelpItem({
      required IconData icon,
      required String title,
      required String subtitle,
      required Color iconColor,
    }) {
      return Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

      // Add this property to track current carousel page
      int _currentCarouselIndex = 0;
    }

    // Custom painter for pie chart
    class PieChartPainter extends CustomPainter {
      final double percentage;
      
      PieChartPainter({this.percentage = 0.25});
      
      @override
      void paint(Canvas canvas, Size size) {
        final center = Offset(size.width / 2, size.height / 2);
        final radius = min(size.width, size.height) / 2;
        
        // Background circle (light gray)
        final backgroundPaint = Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(center, radius, backgroundPaint);
        
        // Foreground segment (orange)
        final segmentPaint = Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.fill;
        
        // Draw a segment representing the percentage
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2,  // Start from top
          2 * pi * percentage,   // Arc based on percentage
          true,
          segmentPaint,
        );
      }

      @override
      bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
    }
