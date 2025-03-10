import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';

class PageDeposit extends StatefulWidget {
  const PageDeposit({super.key});

  @override
  State<PageDeposit> createState() => _PageDepositState();
}

class _PageDepositState extends State<PageDeposit> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, RefreshController> _refreshControllers = {
    'Paying': RefreshController(),
    'Success': RefreshController(),
    'Timeout': RefreshController(),
    'Offline': RefreshController(),
  };
  final Map<String, bool> _hasMore = {
    'Paying': true,
    'Success': true,
    'Timeout': true,
    'Offline': true,
  };
  final Map<String, int> _currentPage = {
    'Paying': 1,
    'Success': 1,
    'Timeout': 1,
    'Offline': 1,
  };
  
  final Map<String, List<Map<String, dynamic>>> _tabTransactions = {
    'Paying': [],
    'Success': [],
    'Timeout': [],
    'Offline': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
  }

  void _initializeData() {
    _tabTransactions['Success'] = [
      {
        'amount': '₹ 2000.00',
        'type': 'UPI Deposit',
        'date': '2024-03-15',
        'time': '15:45:30',
        'status': 'Success',
        'id': 'DEP123456789'
      },
      {
        'amount': '₹ 5000.00',
        'type': 'Bank Deposit',
        'date': '2024-03-15',
        'time': '14:20:15',
        'status': 'Success',
        'id': 'DEP123456788'
      },
    ];
    
    _tabTransactions['Paying'] = [
      {
        'amount': '₹ 3000.00',
        'type': 'UPI Deposit',
        'date': '2024-03-15',
        'time': '16:30:00',
        'status': 'Paying',
        'id': 'DEP123456787'
      }
    ];
  }

  Future<List<Map<String, dynamic>>> _getMoreTransactions(String status) async {
    await Future.delayed(Duration(seconds: 1));
    
    if (_currentPage[status]! >= 3) {
      return [];
    }

    return List.generate(2, (index) => {
      'amount': '₹ ${(1000 + Random().nextInt(5000)).toStringAsFixed(2)}',
      'type': Random().nextBool() ? 'UPI Deposit' : 'Bank Deposit',
      'date': '2024-03-15',
      'time': '${Random().nextInt(24)}:${Random().nextInt(60)}:${Random().nextInt(60)}',
      'status': status,
      'id': 'DEP${DateTime.now().millisecondsSinceEpoch}$index',
    });
  }

  void _onRefresh(String status) async {
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      if (_tabTransactions[status]!.isEmpty) {
        _tabTransactions[status] = List.generate(3, (index) => {
          'amount': '₹ ${(1000 + Random().nextInt(5000)).toStringAsFixed(2)}',
          'type': Random().nextBool() ? 'UPI Deposit' : 'Bank Deposit',
          'date': '2024-03-15',
          'time': '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
          'status': status,
          'id': 'DEP${DateTime.now().millisecondsSinceEpoch}$index',
        });
      } else {
        _tabTransactions[status]!.insert(0, {
          'amount': '₹ ${(1000 + Random().nextInt(5000)).toStringAsFixed(2)}',
          'type': Random().nextBool() ? 'UPI Deposit' : 'Bank Deposit',
          'date': '2024-03-15',
          'time': '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
          'status': status,
          'id': 'DEP${DateTime.now().millisecondsSinceEpoch}',
        });
      }
    });
    
    _refreshControllers[status]!.refreshCompleted();
  }

  void _onLoading(String status) async {
    if (!_hasMore[status]!) {
      _refreshControllers[status]!.loadNoData();
      return;
    }

    final newTransactions = await _getMoreTransactions(status);
    
    if (newTransactions.isEmpty) {
      setState(() {
        _hasMore[status] = false;
      });
      _refreshControllers[status]!.loadNoData();
    } else {
      setState(() {
        _tabTransactions[status]!.addAll(newTransactions);
        _currentPage[status] = _currentPage[status]! + 1;
      });
      _refreshControllers[status]!.loadComplete();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshControllers.values.forEach((controller) => controller.dispose());
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
          'Deposit History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.indigo[700],
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.indigo[700],
          tabs: [
            Tab(text: 'Paying'),
            Tab(text: 'Success'),
            Tab(text: 'Timeout'),
            Tab(text: 'Offline'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList('Paying'),
          _buildTransactionList('Success'),
          _buildTransactionList('Timeout'),
          _buildTransactionList('Offline'),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paying':
        return Colors.orange;
      case 'Success':
        return Colors.blue;
      case 'Timeout':
        return Colors.red;
      case 'Offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTransactionList(String status) {
    final transactions = _tabTransactions[status] ?? [];

    if (transactions.isEmpty) {
      return _buildEmptyState('No $status transactions');
    }

    return SmartRefresher(
      controller: _refreshControllers[status]!,
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
      onRefresh: () => _onRefresh(status),
      onLoading: () => _onLoading(status),
      child: ListView.builder(
        itemCount: transactions.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            elevation: 0,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction['amount'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(transaction['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          transaction['status'],
                          style: TextStyle(
                            color: _getStatusColor(transaction['status']),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    transaction['type'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${transaction['date']} ${transaction['time']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        transaction['id'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
