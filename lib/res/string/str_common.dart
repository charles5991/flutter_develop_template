/// 这里统一写全局，非动态、固定的 字符串文本
/// 如果哪一天 项目突然要求 使用 国际化
/// 直接将这里的内容，拷贝到 国际化插件生成的 映射文件中，再 对照中文 翻译成 指定语言
///
/// 通用
class StrCommon {

  static const String pleaseService = 'Please contact customer service';
  static const String platformNotAdapted = 'The current platform is not adapted';
  static const String executeSwitchUser = 'Executed the switch user operation';

  static const String loading = 'Loading...';
  static const String dataIsEmpty = 'Data is empty';
  static const String listDataIsEmpty = 'List data is empty';
  static const String businessDoesNotPass = 'Business does not pass';
  static const String dioErrorAnomaly = 'dioError anomaly';
  static const String unknownAnomaly = 'Unknown anomaly';

  static const String pullDownToRefresh = 'Pull down to refresh';
  static const String refreshing = 'Refreshing...';
  static const String loadedSuccess = 'Loaded successfully';
  static const String releaseToRefreshImmediately = 'Release to refresh immediately';
  static const String refreshFailed = 'Refresh failed';
  static const String pullUpLoad = 'Pull up load';
  static const String letGoLoading = 'Let go to start loading data';
  static const String failedLoad = 'Failed to load';
  static const String noMoreData = 'No more data';

  static const String connectionTimeout = 'Connection timeout';
  static const String sendTimeout = 'Send timeout';
  static const String receiveTimeout = 'Receive timeout';
  static const String accessCertificateError = 'Access certificate error';
  static const String validationFailed = 'Validation failed';
  static const String connectionIsAbnormal = 'Connection anomaly';
  static const String unknownError = 'Unknown error';

  static const String parameterIsIncorrect = 'Parameter is incorrect';
  static const String illegalRequests = 'Illegal requests';
  static const String serverRejectsRequest = 'Server rejects request';
  static const String accessAddressDoesNotExist = 'Access address does not exist';
  static const String requestIsMadeWrongWay = 'Request is made wrong way';
  static const String wasAnErrorInsideServer = 'Server internal error';
  static const String invalidRequest = 'Invalid request';
  static const String serverIsBusy = 'Server is busy';
  static const String unsupportedHttpProtocol = 'Unsupported HTTP protocol';


  ///--------------------------- 测试路由 -------------------------------
  static const String pageA = 'PageA';
  static const String pageA2 = 'Add Tool';
  static const String pageB = 'Team Detail';
  static const String pageC = 'PageC';
  static const String pageD = 'PageD';

  static const String toPageCDestroyCurrent = 'Go to PageC, and destroy the current page';
  static const String routeInterceptFromPageAtoPageD = 'Route intercept from PageA to PageD';
  static const String backPreviousPage = 'Back to the previous page';
  static const String toPageD = 'Go to PageD';
  static const String toHomeDestroyAll = 'Go to the home page, and destroy all pages';

}