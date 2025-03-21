import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import '../../../../res/string/str_personal.dart';
import 'package:flutter_develop_template/common/widget/global_notification_widget.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/main/app.dart';
import 'package:flutter_develop_template/module/personal/model/user_info_m.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_develop_template/router/navigator_util.dart';
import 'package:flutter_develop_template/router/routers.dart';

import '../../../../res/style/color_styles.dart';
import '../../../../res/style/text_styles.dart';
import '../../../common/util/global.dart';
import '../view_model/personal_vm.dart';
import '../../auth/service/auth_service.dart';

class PersonalView extends BaseStatefulPage {
  PersonalView({super.key});

  @override
  PersonalViewState createState() => PersonalViewState();
}

class PersonalViewState extends BaseStatefulPageState<PersonalView, PersonalViewModel> {
  final RefreshController _refreshController = RefreshController();
  String quotaValue = '97147.86';
  String todayEarnings = '5.49';
  String? userPhone;

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  void initState() {
    super.initState();
    _loadUserPhone();
  }

  Future<void> _loadUserPhone() async {
    String? phone = await AuthService.getLoggedInPhone();
    setState(() {
      userPhone = phone;
    });
  }

  @override
  viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PersonalViewModel()..viewState = this;
  }

  bool executeSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert((){
      debugPrint('OrderView.didChangeDependencies --- $operate');
      return true;
    }());

    if (operate == GlobalOperate.switchLogin) {
      executeSwitchLogin = true;
      // 重新请求数据
      // viewModel.requestData();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget appBuild(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayBlackStyle,
      child: Material(
        color: Colors.grey[100], // Light background color
        child: Stack(
          children: [
            SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: kToolbarHeight + media!.padding.top + 16,
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 60,  // Square size
                            height: 60, // Square size
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: AssetImage('assets/avatar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // User Info
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      userPhone ?? 'Loading...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.copy, size: 16, color: Colors.indigo[700]),
                                      onPressed: () async {
                                        if (userPhone != null) {
                                          await Clipboard.setData(ClipboardData(text: userPhone!));
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Phone number copied to clipboard'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0),
                                Row(
                                  children: [
                                    Text(
                                      '880422300',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.copy, size: 16, color: Colors.indigo[700]),
                                      onPressed: () async {
                                        await Clipboard.setData(ClipboardData(text: '880422300'));
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('ID copied to clipboard'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // More options
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Quota Card with refreshable value
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
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
                                'Quota',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    NavigatorUtil.push(
                                      context,
                                      Routers.personalQuota,
                                    );
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  'Details',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₹ $quotaValue',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Today's earnings",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            todayEarnings,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Common Functions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Common Function',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Grid of functions
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildFunctionButton('Quota', Icons.bolt_outlined, () {
                          NavigatorUtil.push(context, Routers.personalQuota);
                        }),
                        _buildFunctionButton('Deposit', Icons.account_balance_wallet_outlined, () {
                          NavigatorUtil.push(context, Routers.personalDeposit);
                        }),
                        _buildFunctionButton('Withdrawal', Icons.credit_card_outlined, () {
                          NavigatorUtil.push(context, Routers.personalWithdrawal);
                        }),
                        _buildFunctionButton('Service', Icons.headset_mic_outlined, () {
                          NavigatorUtil.push(context, Routers.personalService);
                        }),
                        _buildFunctionButton('Inbox', Icons.mail_outline, () {
                          NavigatorUtil.push(context, Routers.personalInbox);
                        }),
                        _buildFunctionButton('Password', Icons.lock_outline, () {
                          NavigatorUtil.push(context, Routers.personalPassword);
                        }),
                        _buildFunctionButton('Pin', Icons.shield_outlined, () {
                          NavigatorUtil.push(context, Routers.personalPin);
                        }),
                        _buildFunctionButton('Logout', Icons.logout, () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.logout_rounded,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Confirm Logout',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Are you sure you want to logout?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  side: BorderSide(color: Colors.grey[300]!),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () async {
                                                await AuthService.logout();
                                                Navigator.of(context).pushNamedAndRemoveUntil(
                                                  Routers.login,
                                                  (route) => false,
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.symmetric(vertical: 12),
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Logout',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _myAppBar(),
            
            // Keep the original login functionality but commented out
            /*
            Original login buttons and functionality here
            */
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _myAppBar() {
    return Container(
      width: media!.size.width,
      height: kToolbarHeight + media!.padding.top,
      padding: EdgeInsets.only(top: media!.padding.top),
      color: AppBarTheme.of(context).backgroundColor,
      alignment: Alignment.center,
      child: Builder(
        builder: (context) {
          /// 初始化状态设置为 不检查，不然会 返回 loading 组件
          viewModel?.pageDataModel?.type = NotifierResultType.notCheck;
          return NotifierPageWidget<PageDataModel>(
              model: viewModel?.pageDataModel,
              builder: (context, dataModel) {
              final data = dataModel.data as UserInfoModel?;
              String title = (data?.isLogin ?? false) ? '${StrPersonal.loginSuccess}：${data?.username} ${StrPersonal.welcome}' : '${StrPersonal.registerSuccess}：${data?.username} ${StrPersonal.welcome}';
              return Text(
                (data?.username?.isEmpty ?? true) ? StrPersonal.personal : title,
                style: TextStyles.style_222222_20,
              );
            }
          );
        }
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate API call with delay
    await Future.delayed(Duration(seconds: 2));
    
    // In real app, you would fetch actual data from your API
    setState(() {
      // Update with random values for demonstration
      double newQuota = double.parse(quotaValue) + (Random().nextDouble() * 10 - 5);
      double newEarnings = double.parse(todayEarnings) + (Random().nextDouble() * 2 - 1);
      
      quotaValue = newQuota.toStringAsFixed(2);
      todayEarnings = newEarnings.toStringAsFixed(2);
    });

    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;

}
