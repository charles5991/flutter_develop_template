import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageInbox extends StatefulWidget {
  const PageInbox({super.key});

  @override
  State<PageInbox> createState() => _PageInboxState();
}

class _PageInboxState extends State<PageInbox> {
  final RefreshController _refreshController = RefreshController();
  bool _hasMore = true;
  int _currentPage = 1;
  
  // Dummy data for inbox messages
  List<Map<String, dynamic>> messages = [
    {
      'title': 'Withdrawal Successful',
      'message': 'Your withdrawal of ₹2000.00 has been processed successfully.',
      'date': '15 Mar 2024',
      'time': '14:30',
      'type': 'transaction',
      'isRead': false,
    },
    {
      'title': 'Security Alert',
      'message': 'A new device was used to access your account. If this wasn\'t you, please contact support immediately.',
      'date': '15 Mar 2024',
      'time': '13:15',
      'type': 'security',
      'isRead': false,
    },
    {
      'title': 'Deposit Confirmed',
      'message': 'Your deposit of ₹5000.00 has been credited to your account.',
      'date': '15 Mar 2024',
      'time': '11:45',
      'type': 'transaction',
      'isRead': true,
    },
    {
      'title': 'Welcome Bonus Credited',
      'message': 'Congratulations! You\'ve received a welcome bonus of ₹100.00.',
      'date': '14 Mar 2024',
      'time': '16:20',
      'type': 'promotion',
      'isRead': true,
    },
    {
      'title': 'Profile Update',
      'message': 'Your profile information has been updated successfully.',
      'date': '14 Mar 2024',
      'time': '15:10',
      'type': 'account',
      'isRead': true,
    },
  ];

  // Simulate loading more messages
  Future<List<Map<String, dynamic>>> _getMoreMessages() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    
    if (_currentPage >= 3) { // Simulate end of data after 3 pages
      return [];
    }

    return [
      {
        'title': 'System Maintenance Notice',
        'message': 'System will undergo maintenance on ${DateTime.now().add(Duration(days: 1)).day} Mar 2024.',
        'date': '13 Mar 2024',
        'time': '10:30',
        'type': 'account',
        'isRead': true,
      },
      {
        'title': 'New Offer Available',
        'message': 'Special cashback offer on your next transaction!',
        'date': '13 Mar 2024',
        'time': '09:15',
        'type': 'promotion',
        'isRead': true,
      },
    ];
  }

  void _onRefresh() async {
    // Simulate refresh
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      messages = [
        {
          'title': 'New Message',
          'message': 'This is a new message after refresh.',
          'date': '${DateTime.now().day} Mar 2024',
          'time': '${DateTime.now().hour}:${DateTime.now().minute}',
          'type': 'transaction',
          'isRead': false,
        },
        ...messages,
      ];
    });
    
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (!_hasMore) {
      _refreshController.loadNoData();
      return;
    }

    final newMessages = await _getMoreMessages();
    
    if (newMessages.isEmpty) {
      setState(() {
        _hasMore = false;
      });
      _refreshController.loadNoData();
    } else {
      setState(() {
        messages.addAll(newMessages);
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

  IconData _getIcon(String type) {
    switch (type) {
      case 'transaction':
        return Icons.payment;
      case 'security':
        return Icons.security;
      case 'promotion':
        return Icons.card_giftcard;
      case 'account':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'transaction':
        return Colors.green;
      case 'security':
        return Colors.red;
      case 'promotion':
        return Colors.orange;
      case 'account':
        return Colors.blue;
      default:
        return Colors.grey;
    }
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
          'Inbox',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var message in messages) {
                  message['isRead'] = true;
                }
              });
            },
            child: Text(
              'Mark all as read',
              style: TextStyle(
                color: Colors.indigo[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: messages.isEmpty
          ? _buildEmptyState()
          : SmartRefresher(
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
                    body = Text("No more messages");
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
                itemCount: messages.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    color: message['isRead'] ? Colors.white : Colors.indigo[50],
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          message['isRead'] = true;
                        });
                        // Show message detail dialog
                        _showMessageDetail(message);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getIconColor(message['type']).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getIcon(message['type']),
                                color: _getIconColor(message['type']),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          message['title'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: message['isRead'] 
                                                ? FontWeight.normal 
                                                : FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (!message['isRead'])
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.indigo[700],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    message['message'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${message['date']} ${message['time']}',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showMessageDetail(Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getIconColor(message['type']).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(message['type']),
                  color: _getIconColor(message['type']),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['message'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${message['date']} ${message['time']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.indigo[700],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
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
                Icons.mail_outline,
                size: 80,
                color: Colors.indigo[700],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Messages',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You have no messages in your inbox',
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
