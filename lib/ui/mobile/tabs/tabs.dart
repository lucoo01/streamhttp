import 'package:flutter/material.dart';
import 'package:network_proxy/network/channel.dart';
import 'package:network_proxy/network/handler.dart';
import 'package:network_proxy/network/http/websocket.dart';
import 'package:network_proxy/ui/mobile/tabs/mobile.dart';
import 'package:network_proxy/ui/mobile/tabs/home.dart';
import 'package:network_proxy/ui/mobile/tabs/setting_menu.dart';

import 'package:network_proxy/network/bin/configuration.dart';
import 'package:network_proxy/ui/configuration.dart';

import 'package:network_proxy/network/bin/server.dart';


import 'package:network_proxy/utils/listenable_list.dart';
import 'package:network_proxy/network/http/http.dart';

import 'package:network_proxy/ui/mobile/request/list.dart';
import 'package:network_proxy/native/pip.dart';
import 'package:network_proxy/ui/content/panel.dart';

import 'package:provider/provider.dart';
import 'package:network_proxy/utils/appInfo.dart';

class Tabs extends StatefulWidget {
  final Configuration configuration;
  final AppConfiguration appConfiguration;


  const Tabs(this.configuration, this.appConfiguration, {super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs>  implements EventListener{

  static final GlobalKey<RequestListState> requestStateKey = GlobalKey<RequestListState>();

  int _currentIndex = 0;

  final List<Widget> _pages = [];

  static final ListenableList<HttpRequest> container = ListenableList<HttpRequest>();

  late ProxyServer proxyServer;
  late AppConfiguration appConfiguration;
  late Configuration configuration;

  late AppInfo appInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    appConfiguration = widget.appConfiguration;
    configuration = widget.configuration;

    proxyServer = ProxyServer(configuration);

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    appInfo = Provider.of<AppInfo>(context);

  }


  @override
  Widget build(BuildContext context) {

    _currentIndex = appInfo.tabsIndex;

    _pages.add(Home(proxyServer: proxyServer, container: container));
    _pages.add(MobileHomePage(configuration, appConfiguration, container, proxyServer: proxyServer,));
    _pages.add(SettingMenu(proxyServer: proxyServer, appConfiguration: appConfiguration, container: container,));

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_lock),
            label: '抓包',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (index){
          setState((){

            _currentIndex = index;

            appInfo.setTabsIndex(_currentIndex);

          });
        },
      ),
    );
  }

  @override
  void onRequest(Channel channel, HttpRequest request) {
    requestStateKey.currentState!.add(channel, request);
    PictureInPicture.addData(request.requestUrl);
  }

  @override
  void onResponse(ChannelContext channelContext, HttpResponse response) {
    requestStateKey.currentState!.addResponse(channelContext, response);
  }

  @override
  void onMessage(Channel channel, HttpMessage message, WebSocketFrame frame) {
    var panel = NetworkTabController.current;
    if (panel?.request.get() == message || panel?.response.get() == message) {
      panel?.changeState();
    }
  }
}
