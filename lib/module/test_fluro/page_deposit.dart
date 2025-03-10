import 'package:flutter/material.dart';

class PageDeposit extends StatefulWidget {
  const PageDeposit({super.key});

  @override
  State<PageDeposit> createState() => _PageDepositState();
}

class _PageDepositState extends State<PageDeposit> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
    // Dummy data for deposits
    List<Map<String, dynamic>> transactions = status == 'Success' ? [
      {
        'amount': '₹ 2000.00',
        'type': 'UPI Deposit',
        'date': '2024-03-15',
        'time': '15:45:30',
        'status': status,
        'id': 'DEP123456789'
      },
      {
        'amount': '₹ 5000.00',
        'type': 'Bank Deposit',
        'date': '2024-03-15',
        'time': '14:20:15',
        'status': status,
        'id': 'DEP123456788'
      },
      {
        'amount': '₹ 1000.00',
        'type': 'UPI Deposit',
        'date': '2024-03-15',
        'time': '12:10:45',
        'status': status,
        'id': 'DEP123456787'
      },
    ] : status == 'Paying' ? [
      {
        'amount': '₹ 3000.00',
        'type': 'UPI Deposit',
        'date': '2024-03-15',
        'time': '16:30:00',
        'status': status,
        'id': 'DEP123456786'
      }
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
                // Add payment method info if needed
                if (transaction['type'].contains('UPI'))
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Via: UPI ID xxxxxx@upi',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
