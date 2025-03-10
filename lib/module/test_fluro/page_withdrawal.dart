import 'package:flutter/material.dart';

class PageWithdrawal extends StatefulWidget {
  const PageWithdrawal({super.key});

  @override
  State<PageWithdrawal> createState() => _PageWithdrawalState();
}

class _PageWithdrawalState extends State<PageWithdrawal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Withdrawal History',
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
    // Dummy data - you can replace this with real data
    List<Map<String, dynamic>> transactions = status == 'Success' ? [
      {
        'amount': '₹ 1500.00',
        'type': 'UPI Withdrawal',
        'date': '2024-03-15',
        'time': '14:30:25',
        'status': status,
        'id': 'TXN123456789'
      },
      {
        'amount': '₹ 2500.00',
        'type': 'Bank Withdrawal',
        'date': '2024-03-15',
        'time': '13:45:12',
        'status': status,
        'id': 'TXN123456788'
      },
      // Add more transactions as needed
    ] : [];

    if (transactions.isEmpty) {
      return _buildEmptyState('No $status transactions');
    }

    return ListView.builder(
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
