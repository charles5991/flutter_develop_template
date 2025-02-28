import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/main/app.dart';
import '../../../../res/string/str_common.dart';
import '../../../../router/navigator_util.dart';
import '../../../../router/routers.dart';
import '../order/view/order_v.dart';

class PageBView extends BaseStatefulPage {
  PageBView({super.key, this.paramsModel});

  final TestParamsModel? paramsModel;

  @override
  PageBViewState createState() => PageBViewState();
}

class PageBViewState extends BaseStatefulPageState<PageBView, PageBViewModel> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<TeamMember> teamAMembers = [
    TeamMember(
      avatar: 'assets/avatar1.png',
      phone: '+91 7999139259',
      lastOnline: '1 hour ago',
      yesterdayCommission: '0',
      totalCommission: '0',
      yesterdayCommissionToMe: '2.33',
      totalCommissionToMe: '2.33',
    ),
    TeamMember(
      avatar: 'assets/avatar2.png',
      phone: '+91 7999139259',
      lastOnline: '1 hour ago',
      yesterdayCommission: '0',
      totalCommission: '0',
      yesterdayCommissionToMe: '2.33',
      totalCommissionToMe: '2.33',
    ),
    TeamMember(
      avatar: 'assets/avatar3.png',
      phone: '+91 7999139259',
      lastOnline: '1 hour ago',
      yesterdayCommission: '0',
      totalCommission: '0',
      yesterdayCommissionToMe: '2.33',
      totalCommissionToMe: '2.33',
    ),
    TeamMember(
      avatar: 'assets/avatar4.png',
      phone: '+91 7999139259',
      lastOnline: '1 hour ago',
      yesterdayCommission: '0',
      totalCommission: '0',
      yesterdayCommissionToMe: '2.33',
      totalCommissionToMe: '2.33',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Team Detail'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Level A',
                style: TextStyle(
                  color: Colors.indigo[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Level B',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          indicatorColor: Colors.indigo[700],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Team A Tab
          ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: teamAMembers.length,
            itemBuilder: (context, index) {
              final member = teamAMembers[index];
              return _buildMemberCard(member);
            },
          ),
          // Team B Tab (Empty state with illustration)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Empty state illustration
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.folder_open_rounded,
                      size: 80,
                      color: Colors.indigo[700],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Empty File',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'No members in Level B yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(TeamMember member) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
            ),
            SizedBox(width: 12),
            // Member Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        member.phone,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle call action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'CALL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  _buildDetailRow('Final time online', member.lastOnline),
                  _buildDetailRow('Yesterday\'s commission', '₹ ${member.yesterdayCommission}'),
                  _buildDetailRow('Total commission', '₹ ${member.totalCommission}'),
                  _buildDetailRow('Yesterday\'s commission to me', '₹ ${member.yesterdayCommissionToMe}'),
                  _buildDetailRow('Total commission to me', '₹ ${member.totalCommissionToMe}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  PageBViewModel viewBindingViewModel() {
    return PageBViewModel()..viewState = this;
  }
}

// Model class for team member data
class TeamMember {
  final String avatar;
  final String phone;
  final String lastOnline;
  final String yesterdayCommission;
  final String totalCommission;
  final String yesterdayCommissionToMe;
  final String totalCommissionToMe;

  TeamMember({
    required this.avatar,
    required this.phone,
    required this.lastOnline,
    required this.yesterdayCommission,
    required this.totalCommission,
    required this.yesterdayCommissionToMe,
    required this.totalCommissionToMe,
  });
}

class PageBViewModel extends PageViewModel<PageBViewState> {
  @override
  onCreate() {}

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }
}
