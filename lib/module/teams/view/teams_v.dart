import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/module/test_fluro/page_b.dart';

class TeamsView extends BaseStatefulPage {
  TeamsView({super.key});

  @override
  TeamsViewState createState() => TeamsViewState();
}

class TeamsViewState extends BaseStatefulPageState<TeamsView, TeamsViewModel> {
  DateTime startDate = DateTime(2024, 10, 1);
  DateTime endDate = DateTime(2024, 10, 31);
  
  String get dateRange => '${DateFormat('dd MMM yyyy').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}';

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: Text('Done'),
                      onPressed: () {
                        setState(() {
                          // Update will happen in the onDateTimeChanged
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: startDate,
                  minimumDate: DateTime(2024),
                  maximumDate: DateTime(2025),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      // Calculate the end date as 30 days from selected date
                      startDate = newDate;
                      endDate = newDate.add(Duration(days: 30));
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Team'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Selector
            GestureDetector(
              onTap: () => _showDatePicker(context),
              child: Row(
                children: [
                  Text(
                    dateRange,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _showDatePicker(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Today and Total Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Today',
                    'Team Deposit',
                    '0',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    'Team Deposit',
                    '₹ 97150.04',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Commission Card
            Container(
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
                  Text(
                    'My Total Commission',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹ 4091.84',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildCommissionRow('Commission Yesterday', '4.43'),
                  _buildCommissionRow('Team Count', '48'),
                  _buildCommissionRow('Commission Today', '+0'),
                  _buildCommissionRow('Today New Team', '+0'),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Invitation Link
            Text(
              'Invitation Link',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: 'http://t.ly/DTH3C',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.indigo),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: 'http://t.ly/DTH3C'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Share Options
            Text(
              'More Ways To Invite',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareButton(Icons.facebook, Colors.blue),
                // _buildShareButton(Icons.whatsapp, Colors.green),
                _buildShareButton(Icons.telegram, Colors.blue[300]!),
                _buildShareButton(Icons.qr_code_scanner, Colors.purple[900]!),
                _buildShareButton(Icons.share, Colors.red),
              ],
            ),
            SizedBox(height: 24),

            // Team Details
            Container(
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
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Team Detail',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageBView(),
                              ),
                            );
                          },
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  // Table Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Level',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Count',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Rate',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Amount',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Replace the existing team detail rows with this new method
                  _buildTeamDetailRow('Level A', '0', '0.3%', '4095.83'),
                  _buildTeamDetailRow('Level B', '0', '0.1%', '0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String subtitle, String value) {
    return Container(
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: value.startsWith('+') ? Colors.orange : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTeamDetailRow(String level, String count, String percentage, String amount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              level,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              count,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              percentage,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: double.parse(amount.replaceAll(',', '')) > 0 
                    ? Colors.black 
                    : Colors.grey[600],
              ),
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
  TeamsViewModel viewBindingViewModel() {
    return TeamsViewModel()..viewState = this;
  }
}

class TeamsViewModel extends PageViewModel<TeamsViewState> {
  @override
  onCreate() {}

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }
}