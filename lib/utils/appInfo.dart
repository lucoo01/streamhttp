import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import 'package:network_proxy/network/bin/server.dart';
import 'package:provider/provider.dart';


class AppInfo with ChangeNotifier {
  bool _firstOpen = true;
  bool _isSslOpen = false;
  bool _serverLaunch = false;
  bool _serverInitRun = false;
  int _tabsIndex = 0;

  ProxyServer? _proxyServer;

  bool get firstOpen => _firstOpen;
  bool get isSslOpen => _isSslOpen;
  bool get serverLaunch => _serverLaunch;
  bool get serverInitRun => _serverInitRun;
  int get tabsIndex => _tabsIndex;

  ProxyServer? get proxyServer => _proxyServer;

  void appOpened() {
    _firstOpen = false;
    notifyListeners(); // 通知监听器状态已更新
  }

  void setSslStatus(bool status){
    _isSslOpen = status;
    notifyListeners();
  }

  void setServerStatus(bool status) {
    _serverLaunch = status;
    notifyListeners();
  }

  void setServerInitRunStatus(bool status) {
    _serverInitRun = status;
    notifyListeners();
  }

  void setProxyServer(ProxyServer proxyServer){
    _proxyServer = proxyServer;
    notifyListeners();
  }

  // 设置Tabs索引状态
  void setTabsIndex(int index){
    _tabsIndex = index;
    notifyListeners();
  }


}