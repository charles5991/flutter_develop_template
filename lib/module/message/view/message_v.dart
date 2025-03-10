import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import '../../../../res/string/str_common.dart';
import '../../../../res/string/str_message.dart';
import 'package:flutter_develop_template/common/widget/refresh_load_widget.dart';
import 'package:flutter_develop_template/module/message/model/message_list_m.dart';
import 'package:flutter_develop_template/module/message/view_model/message_vm.dart';

import '../../../../res/style/color_styles.dart';
import '../../../../res/style/text_styles.dart';
import '../../../common/widget/global_notification_widget.dart';
import '../../../common/widget/notifier_widget.dart';
import 'package:flutter/services.dart';

class MessageView extends BaseStatefulPage {
  MessageView({super.key});

  @override
  MessageViewState createState() => MessageViewState();
}

class MessageViewState extends BaseStatefulPageState<MessageView, MessageViewModel> {
  // Add a state variable to track the selected tab
  int _selectedTabIndex = 1; // Default to the middle tab (INR) which is currently shown as selected
  
  // Add controllers for range input fields
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  
  // Add state for sorting option
  String _selectedSortOption = 'From low to high';
  final List<String> _sortOptions = ['From low to high', 'From high to low'];

  @override
  MessageViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return MessageViewModel()..viewState = this;
  }

  @override
  void initAttribute() {

  }

  @override
  void initObserver() {}

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    assert((){
      debugPrint('MessageView.onDispose()');
      return true;
    }());
    super.dispose();
  }

  bool executeSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert((){
      debugPrint('MessageView.didChangeDependencies --- $operate');
      return true;
    }());

    // 切换用户
    // 正常业务流程是：从本地存储，拿到当前最新的用户ID，请求接口，我这里偷了个懒 😄
    // 直接使用随机数，模拟 不同用户ID
    if (operate == GlobalOperate.switchLogin) {
      executeSwitchLogin = true;

      // 重新请求数据
      // 如果你想刷新的时候，显示loading，加上这两行
      viewModel?.pageDataModel?.type = NotifierResultType.loading;
      viewModel?.pageDataModel?.refreshState();

      viewModel?.pagingDataModel?.listData.clear();
      viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
    }
  }

  @override
  Widget appBuild(BuildContext context) {
    // State variable for visibility toggle
    final ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
    
    return DefaultTabController(
      length: 3,
      initialIndex: 1, // Start with INR tab selected
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppBarTheme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Deposit',
            style: TextStyles.style_222222_20,
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'INR'),
              Tab(text: 'USTD'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 2,
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(context, isVisible),
            _buildTabContent(context, isVisible),
            _buildUSTDContent(context, isVisible),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, ValueNotifier<bool> isVisible) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Quota section with visibility toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Quota',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 12),
                    ValueListenableBuilder<bool>(
                      valueListenable: isVisible,
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            isVisible.value = !isVisible.value;
                          },
                          child: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text('How Buy Quota', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          
          // Hidden/Visible balance
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isVisible,
                  builder: (context, value, child) {
                    return Text(
                      value ? '10,000.00' : '********',
                      style: TextStyle(fontSize: 24, color: Colors.blue),
                    );
                  },
                ),
                Text(
                  'INR',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          ),
          
          // Filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  initialValue: _selectedSortOption,
                  onSelected: (String value) {
                    setState(() {
                      _selectedSortOption = value;
                      // Here you would add logic to sort your data based on selection
                    });
                  },
                  itemBuilder: (BuildContext context) => _sortOptions
                      .map((option) => PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  child: Row(
                    children: [
                      Text(_selectedSortOption, style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                Icon(Icons.search, size: 28),
              ],
            ),
          ),
          
          // Range input with number keyboard - use the class-level controllers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController, // Use class-level controller
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Min', // Add hint text for clarity
                    ),
                    keyboardType: TextInputType.number, // This ensures number keyboard appears
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('-', style: TextStyle(fontSize: 24)),
                ),
                Expanded(
                  child: TextField(
                    controller: _maxController, // Use class-level controller
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Max', // Add hint text for clarity
                    ),
                    keyboardType: TextInputType.number, // This ensures number keyboard appears
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // List of buy items
          _buildBuyItem(context, '300.00', '6.00', '306.00'),
          _buildBuyItem(context, '600.00', '12.00', '612.00'),
          _buildBuyItem(context, '300.00', '6.00', '306.00'),
          _buildBuyItem(context, '778.00', '15.56', '793.56'),
          _buildBuyItem(context, '800.00', '16.00', '816.00'),
        ],
      ),
    );
  }

  Widget _buildUSTDContent(BuildContext context, ValueNotifier<bool> isVisible) {
    // Create a controller for the USDT amount input
    final TextEditingController usdtAmountController = TextEditingController();
    // Create a ValueNotifier for calculated values
    final ValueNotifier<double> calculatedINR = ValueNotifier<double>(0.0);
    final ValueNotifier<double> bonusINR = ValueNotifier<double>(0.0);
    final ValueNotifier<double> totalINR = ValueNotifier<double>(0.0);
    
    // Exchange rate
    const double exchangeRate = 92.50;
    const double bonusRate = 0.02; // 2% bonus
    
    // Function to update calculations
    void updateCalculations(String value) {
      double usdtAmount = double.tryParse(value) ?? 0.0;
      double inrValue = usdtAmount * exchangeRate;
      double bonus = inrValue * bonusRate;
      
      calculatedINR.value = inrValue;
      bonusINR.value = bonus;
      totalINR.value = inrValue + bonus;
    }
    
    // Add listener to the controller
    usdtAmountController.addListener(() {
      updateCalculations(usdtAmountController.text);
    });
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quota section with visibility toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Quota',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 12),
                    ValueListenableBuilder<bool>(
                      valueListenable: isVisible,
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            isVisible.value = !isVisible.value;
                          },
                          child: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text('How Buy Quota', style: TextStyle(color: Colors.grey)),
              ],
            ),
            
            // Hidden/Visible balance
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isVisible,
                    builder: (context, value, child) {
                      return Text(
                        value ? '10,000.00' : '********',
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                      );
                    },
                  ),
                  Text(
                    'INR',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
            
            // QR Code
            Center(
              child: Container(
                width: 150,
                height: 150,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/images/qr_code.png', // Make sure to add this asset
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.qr_code_2, size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            
            // Recharge Address
            Text(
              'Recharge Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      child: Text(
                        'TS63BUWrTrphD8HBdkTBXHAhPA6e76sCkY',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.indigo),
                    onPressed: () async {
                      // 使用 Clipboard 复制文本
                      await Clipboard.setData(
                        ClipboardData(text: 'TS63BUWrTrphD8HBdkTBXHAhPA6e76sCkY')
                      );
                      // 显示提示
                      if (mounted) {  // 确保 widget 还在树中
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Address copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Text(
              '* Only supports TRC20 network',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            
            SizedBox(height: 24),
            
            // Calculate section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ratio 1 USDT = $exchangeRate INR',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: usdtAmountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Enter USDT amount',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Calculation results - FIXED OVERFLOW ISSUE
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated bonus:',
                      style: TextStyle(fontSize: 14),
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: bonusINR,
                      builder: (context, value, child) {
                        return Text(
                          '${value.toStringAsFixed(2)} INR',
                          style: TextStyle(fontSize: 14),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You will receive:',
                      style: TextStyle(fontSize: 14),
                    ),
                    ValueListenableBuilder<double>(
                      valueListenable: totalINR,
                      builder: (context, value, child) {
                        return Text(
                          '${value.toStringAsFixed(2)} INR',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '* After the recharge is completed, please wait 3-5 minutes for the deposit to arrive',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyItem(BuildContext context, String amount, String interest, String total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Left section - Income and rupee symbol
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('₹', style: TextStyle(fontSize: 24)),
              SizedBox(height: 4),
              Text('Income', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(width: 16),
          
          // Middle section - Amount and interest
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$amount INR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('₹$interest (2.00%)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Bank', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Right section - Total and buy button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Quota', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('+ $total', style: TextStyle(color: Colors.orange, fontSize: 16)),
              SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(80, 36),
                ),
                child: Text('BUY'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
