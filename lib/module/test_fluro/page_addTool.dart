import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/main/app.dart';
import '../../../../res/string/str_common.dart';
import '../../../../router/navigator_util.dart';
import '../../../../router/routers.dart';
import '../order/view/order_v.dart';

class PageAddToolView extends BaseStatefulPage {
  PageAddToolView({super.key, this.paramsModel});

  final TestParamsModel? paramsModel;

  @override
  PageAddToolViewState createState() => PageAddToolViewState();
}

class PageAddToolViewState extends BaseStatefulPageState<PageAddToolView, PageAddToolViewModel> {
  final List<ToolItem> tools = [
    ToolItem(
      icon: Icons.account_balance_wallet,
      name: 'Mobikwik',
      isEnabled: true,
    ),
    ToolItem(
      icon: Icons.account_balance,
      name: 'New Wallet',
      isEnabled: false,
    ),
    ToolItem(
      icon: Icons.account_balance,
      name: 'New Wallet',
      isEnabled: false,
    ),
  ];

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  PageAddToolViewModel viewBindingViewModel() {
    return PageAddToolViewModel()..viewState = this;
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add Tool'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          return ToolCard(tool: tools[index]);
        },
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final ToolItem tool;

  const ToolCard({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: tool.isEnabled ? () {
          // Handle tool selection
          print('Selected: ${tool.name}');
        } : null,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tool.icon,
                size: 40,
                color: tool.isEnabled ? Colors.indigo : Colors.grey,
              ),
              SizedBox(height: 8),
              Text(
                tool.name,
                style: TextStyle(
                  color: tool.isEnabled ? Colors.black : Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolItem {
  final IconData icon;
  final String name;
  final bool isEnabled;

  ToolItem({
    required this.icon,
    required this.name,
    this.isEnabled = true,
  });
}

class PageAddToolViewModel extends PageViewModel<PageAddToolViewState> {
  @override
  onCreate() {}

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }
}
