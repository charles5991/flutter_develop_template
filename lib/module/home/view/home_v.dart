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
    // 进入页面初始化 请求数据 的加载中 状态
    // Initialize with data immediately to prevent initial loading state
    // Future.microtask(() {
    //   if (viewModel?.pageDataModel?.type == NotifierResultType.loading) {
    //     viewModel?.requestData(params: {'curPage': 1});
    //   }
    // });
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
    // if (operate == GlobalOperate.switchLogin) {
    //   executeSwitchLogin = true;

    //   // 重新请求数据
    //   // 如果你想刷新的时候，显示loading，加上这两行
    //   // viewModel?.pageDataModel?.type = NotifierResultType.loading;
    //   // viewModel?.pageDataModel?.refreshState();

    //   viewModel?.requestData(params: {'curPage': Random().nextInt(10)});
    // } else if (!executeSwitchLogin && viewModel?.pageDataModel?.type == NotifierResultType.loading) {
    //   // Initialize with data if we're in loading state on first load
    //   viewModel?.requestData(params: {'curPage': 1});
    // }
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
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (String choice) {
                    // Handle menu item selection
                    switch (choice) {
                      case 'Details':
                        // Add your action for Details
                        break;
                      case 'Share':
                        // Add your action for Share
                        break;
                      case 'Download':
                        // Add your action for Download
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Details',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Details'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Share',
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Share'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Download',
                        child: Row(
                          children: [
                            Icon(Icons.download, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Download'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
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
              title: 'How to use Mobikwik wallet',
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
      return GestureDetector(
        onTap: () {
          if (subtitle == 'Detail') {
            _showDetailModal(context, title);
          } else if (subtitle.contains('Watch Video')) {
            _showVideoModal(context, title);
          }
        },
        child: Row(
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
        ),
      );
    }

    // Show detail modal
    void _showDetailModal(BuildContext context, String title) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 15),
              Text(
                'Getting Started with Umoney',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailStep(
                        number: '1',
                        title: 'Create an Account',
                        description: 'Sign up with your phone number and verify your identity with a valid ID.',
                      ),
                      _buildDetailStep(
                        number: '2',
                        title: 'Add Money to Wallet',
                        description: 'Link your bank account or use UPI to add funds to your Umoney wallet.',
                      ),
                      _buildDetailStep(
                        number: '3',
                        title: 'Make Payments',
                        description: 'Use Umoney for bill payments, shopping, and sending money to friends and family.',
                      ),
                      _buildDetailStep(
                        number: '4',
                        title: 'Earn Rewards',
                        description: 'Get cashback and rewards on transactions made through Umoney.',
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Umoney is a secure digital wallet that allows you to make payments, transfer money, and earn rewards. With Umoney, you can manage your finances on the go and enjoy a seamless payment experience.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Build detail step widget
    Widget _buildDetailStep({
      required String number,
      required String title,
      required String description,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Show video modal
    void _showVideoModal(BuildContext context, String title) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 15),
              // Video player placeholder - increased height from 200 to 250
              Container(
                height: 200, // Increased height
                width: double.infinity, // Ensure it takes full width
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      color: Colors.white.withOpacity(0.7),
                      size: 80, // Increased icon size from 60 to 80
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Text(
                        'Earn with Umoney - Tutorial',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Increased font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Ways to Earn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEarningMethod(
                        icon: Icons.card_giftcard,
                        title: 'Referral Program',
                        description: 'Invite friends and earn ₹50 for each successful referral.',
                      ),
                      _buildEarningMethod(
                        icon: Icons.shopping_bag,
                        title: 'Cashback on Shopping',
                        description: 'Get up to 10% cashback when you shop with partner merchants.',
                      ),
                      _buildEarningMethod(
                        icon: Icons.account_balance,
                        title: 'Bill Payments',
                        description: 'Earn rewards on utility bill payments and recharges.',
                      ),
                      _buildEarningMethod(
                        icon: Icons.savings,
                        title: 'Savings Challenge',
                        description: 'Join monthly savings challenges and win exciting prizes.',
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Start Earning Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Build earning method widget
    Widget _buildEarningMethod({
      required IconData icon,
      required String title,
      required String description,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.orange,
                size: 24,
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
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
