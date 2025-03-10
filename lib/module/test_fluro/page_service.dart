import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';

class PageService extends StatefulWidget {
  const PageService({super.key});

  @override
  State<PageService> createState() => _PageServiceState();
}

class _PageServiceState extends State<PageService> {
  final RefreshController _refreshController = RefreshController();
  bool _hasMore = true;
  int _currentPage = 1;
  
  List<Map<String, dynamic>> _serviceUsers = [
    {
      'id': 'U0001',
      'workTime': '09:00 - 21:00',
      'status': 'Online',
    },
    {
      'id': 'U0002',
      'workTime': '09:00 - 21:00',
      'status': 'Online',
    },
    {
      'id': 'U0003',
      'workTime': '06:00 - 18:00',
      'status': 'Offline',
    },
    {
      'id': 'U0004',
      'workTime': '06:00 - 18:00',
      'status': 'Offline',
    },
  ];

  Future<List<Map<String, dynamic>>> _getMoreUsers() async {
    await Future.delayed(Duration(seconds: 1));
    
    if (_currentPage >= 3) return [];

    return List.generate(2, (index) {
      final id = _serviceUsers.length + index + 1;
      final isOnline = Random().nextBool();
      return {
        'id': 'U${id.toString().padLeft(4, '0')}',
        'workTime': isOnline ? '09:00 - 21:00' : '06:00 - 18:00',
        'status': isOnline ? 'Online' : 'Offline',
      };
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      // Randomly change some users' status
      _serviceUsers = _serviceUsers.map((user) {
        if (Random().nextBool()) {
          final isOnline = Random().nextBool();
          return {
            ...user,
            'workTime': isOnline ? '09:00 - 21:00' : '06:00 - 18:00',
            'status': isOnline ? 'Online' : 'Offline',
          };
        }
        return user;
      }).toList();
    });
    
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (!_hasMore) {
      _refreshController.loadNoData();
      return;
    }

    final newUsers = await _getMoreUsers();
    
    if (newUsers.isEmpty) {
      setState(() {
        _hasMore = false;
      });
      _refreshController.loadNoData();
    } else {
      setState(() {
        _serviceUsers.addAll(newUsers);
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
          'Service',
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
          itemCount: _serviceUsers.length,
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final user = _serviceUsers[index];
            final isOnline = user['status'] == 'Online';
            
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(width: 16),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['id'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Work time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Status',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Time and Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: isOnline ? () {
                          // Handle call action
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOnline ? Colors.orange : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(80, 32),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        ),
                        child: Text(
                          'CALL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user['workTime'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        user['status'],
                        style: TextStyle(
                          color: isOnline ? Colors.orange : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
