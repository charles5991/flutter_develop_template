import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/paging/paging_data_model.dart';
import 'package:flutter_develop_template/common/res/string/strings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 封装 下拉刷新/上拉加载更多 组件
class RefreshLoadWidget extends StatefulWidget {
  const RefreshLoadWidget({
    super.key,
    required this.pagingDataModel,
    required this.scrollView,
    this.header,
    this.footer,
    this.enablePullDown = true,
    this.enablePullUp = true,
  });

  final PagingDataModel pagingDataModel;
  final ScrollView scrollView;
  final Widget? header;
  final Widget? footer;

  // 开启/关闭 下拉刷新
  final bool enablePullDown;

  // 开启/关闭 上拉加载
  final bool enablePullUp;

  @override
  State<RefreshLoadWidget> createState() => _RefreshLoadWidgetState();
}

class _RefreshLoadWidgetState extends State<RefreshLoadWidget> {
  late RefreshController refreshController;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  /// 下拉刷新
  onRefresh() async {
    // 正在刷新
    if (widget.pagingDataModel.pagingState == PagingState.curRefreshing) {
      return;
    }

    PagingState resultType = await widget.pagingDataModel.refreshListData();
    if (resultType == PagingState.refreshSuccess) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }

    // 重置空闲状态
    widget.pagingDataModel.pagingState = PagingState.idle;
    widget.pagingDataModel.pagingBehavior = PagingBehavior.idle;
  }

  /// 上拉加载
  onLoading() async {
    // 正在加载
    if (widget.pagingDataModel.pagingState == PagingState.curLoading) {
      return;
    }

    PagingState resultType = await widget.pagingDataModel.loadListData();
    if (resultType == PagingState.loadSuccess) {
      refreshController.loadComplete();
    } else if (resultType == PagingState.loadNoData) {
      refreshController.loadNoData();
    } else {
      refreshController.loadFailed();
    }

    // 重置空闲状态
    widget.pagingDataModel.pagingState = PagingState.idle;
    widget.pagingDataModel.pagingBehavior = PagingBehavior.idle;
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      // 下拉刷新
      enablePullDown: true,
      // 上拉加载
      enablePullUp: true,
      header: widget.header ??
          ClassicHeader(
            idleText: Strings.pullDownToRefresh,
            refreshingText: Strings.refreshing,
            completeText: Strings.loadedSuccess,
            releaseText: Strings.releaseToRefreshImmediately,
            failedText: Strings.refreshFailed,
          ),
      footer: widget.footer ??
          ClassicFooter(
            idleText: Strings.pullUpLoad,
            loadingText: Strings.loading,
            canLoadingText: Strings.letGoLoading,
            failedText: Strings.failedLoad,
            noDataText: Strings.noMoreData,
            // 没有内容的文字
            noMoreIcon: Icon(Icons.data_array), // 没有内容的图标
          ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: widget.scrollView,
    );
  }
}
