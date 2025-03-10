import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';

class PagePersonalQuota extends StatefulWidget {
  const PagePersonalQuota({super.key});

  @override
  State<PagePersonalQuota> createState() => _PagePersonalQuotaState();
}

class _PagePersonalQuotaState extends State<PagePersonalQuota> {
  final RefreshController _refreshController = RefreshController();
  bool _hasMore = true;
  int _currentPage = 1;

  // Dummy data list
  List<Map<String, dynamic>> transactions = List.generate(10, (index) => {
    'amount': '₹ 1.50',
    'description': 'Team INR CR Commission',
    'timestamp': '13:28:55 12/10/24',
    'balance': '₹ 97157.86',
    'type': index % 2 == 0 ? 'Credit' : 'Debit',
  });

  // Simulate loading more transactions
  Future<List<Map<String, dynamic>>> _getMoreTransactions() async {
    await Future.delayed(Duration(seconds: 1));
    
    if (_currentPage >= 3) { // Simulate end of data after 3 pages
      return [];
    }

    return List.generate(5, (index) => {
      'amount': '₹ ${(1.50 + index).toStringAsFixed(2)}',
      'description': 'Team INR CR Commission',
      'timestamp': '13:28:55 12/10/24',
      'balance': '₹ ${(97157.86 - index * 1.5).toStringAsFixed(2)}',
      'type': index % 2 == 0 ? 'Credit' : 'Debit',
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      transactions = [
        {
          'amount': '₹ ${(1.50 + Random().nextDouble()).toStringAsFixed(2)}',
          'description': 'Team INR CR Commission',
          'timestamp': '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} ${DateTime.now().day}/10/24',
          'balance': '₹ ${(97157.86 + Random().nextDouble() * 10).toStringAsFixed(2)}',
          'type': 'Credit',
        },
        ...transactions,
      ];
    });
    
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (!_hasMore) {
      _refreshController.loadNoData();
      return;
    }

    final newTransactions = await _getMoreTransactions();
    
    if (newTransactions.isEmpty) {
      setState(() {
        _hasMore = false;
      });
      _refreshController.loadNoData();
    } else {
      setState(() {
        transactions.addAll(newTransactions);
        _currentPage++;
      });
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Quota History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          complete: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.done, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Refresh completed',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Pull up to load more");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.indigo[700]),
              );
            } else if (mode == LoadStatus.failed) {
              body = Text("Load failed! Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Release to load more");
            } else {
              body = Text("No more data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionItem(
              amount: transaction['amount'],
              description: transaction['description'],
              timestamp: transaction['timestamp'],
              balance: transaction['balance'],
              type: transaction['type'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuotaInfo(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String amount,
    required String description,
    required String timestamp,
    required String balance,
    required String type,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                type,
                style: TextStyle(
                  color: type == 'Credit' ? Colors.blue : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            timestamp,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                balance,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
