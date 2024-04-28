import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:network_proxy/ui/desktop/toolbar/setting/setting.dart';
// import 'package:network_proxy/ui/mobile/menu/left_menu.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:network_proxy/network/bin/configuration.dart';

import 'package:network_proxy/ui/mobile/tabs/mobile.dart';

import 'package:network_proxy/network/bin/server.dart';
import 'package:network_proxy/network/components/host_filter.dart';
import 'package:network_proxy/network/components/request_block_manager.dart';
import 'package:network_proxy/network/components/request_rewrite_manager.dart';
import 'package:network_proxy/network/http/http.dart';
import 'package:network_proxy/storage/histories.dart';
import 'package:network_proxy/ui/component/toolbox.dart';
import 'package:network_proxy/ui/component/utils.dart';
import 'package:network_proxy/ui/configuration.dart';
import 'package:network_proxy/ui/mobile/tabs/setting_menu.dart';
import 'package:network_proxy/ui/mobile/request/mobile_favorites.dart';
import 'package:network_proxy/ui/mobile/request/mobile_history.dart';
import 'package:network_proxy/ui/mobile/setting/app_while_list.dart';
import 'package:network_proxy/ui/mobile/setting/mobile_filter.dart';
import 'package:network_proxy/ui/mobile/setting/mobile_request_block.dart';
import 'package:network_proxy/ui/mobile/setting/mobile_request_rewrite.dart';
import 'package:network_proxy/ui/mobile/setting/mobile_script.dart';
import 'package:network_proxy/ui/mobile/setting/mobile_ssl.dart';
import 'package:network_proxy/ui/mobile/widgets/about.dart';
import 'package:network_proxy/utils/listenable_list.dart';
import 'package:network_proxy/utils/navigator.dart';

import 'package:network_proxy/ui/mobile/setting/proxy_setting.dart';


import 'package:flutter/services.dart';
import 'package:network_proxy/ui/mobile/encro/home_page.dart';
import 'package:sizer/sizer.dart';
import 'package:network_proxy/utilities/constants.dart';

import 'package:network_proxy/ui/component/json/theme.dart';

// import 'package:network_proxy/native/vpn.dart';

import 'package:provider/provider.dart';
import 'package:network_proxy/utils/appInfo.dart';

import 'package:network_proxy/ui/mobile/protocol/wsApp.dart';

import 'package:network_proxy/ui/component/utils.dart';

//

List<Map<String, dynamic>> tools = [
  {'icon': 'home_repair_service_outlined', 'name': '工具箱'},
  {'icon': 'filter_alt_outlined', 'name': '过滤'},
  {'icon': 'repeat', 'name': '请求重写'},
  {'icon': 'closed_caption_disabled_outlined', 'name': '请求屏蔽'},
  {'icon': 'code_outlined', 'name': '脚本'},
  {'icon': 'enhanced_encryption_outlined', 'name': 'AES加密'},
  {'icon': 'insert_link_outlined', 'name': 'Socket测试'},
];

List<Map<String, dynamic>> settings = [
  {'icon': 'https_outlined', 'name': '代理'},
  {'icon': 'language_outlined', 'name': '语言'},
  {'icon': 'palette_outlined', 'name': '主题'},
  {'icon': 'add_link_outlined', 'name': '自动抓包'},
  {'icon': 'web_stories_outlined', 'name': '窗口模式'},
  {'icon': 'troubleshoot_outlined', 'name': 'Headers'},
  {'icon': 'sensor_occupied_outlined', 'name': '关于'},
];

// 在使用时根据字符串查找对应的IconData
IconData getIcon(String iconName) {
  final Map<String, IconData> iconMap = {
    'home_repair_service_outlined': Icons.home_repair_service_outlined,
    'filter_alt_outlined': Icons.filter_alt_outlined,
    'repeat': Icons.repeat,
    'closed_caption_disabled_outlined': Icons.closed_caption_disabled_outlined,
    'code_outlined': Icons.code_outlined,
    'https_outlined': Icons.https_outlined,
    'language_outlined': Icons.language_outlined,
    'palette_outlined': Icons.palette_outlined,
    'sensor_occupied_outlined': Icons.sensor_occupied_outlined,
    'add_link_outlined': Icons.add_link_outlined,
    'web_stories_outlined': Icons.web_stories_outlined,
    'troubleshoot_outlined': Icons.troubleshoot_outlined,
    'enhanced_encryption_outlined': Icons.enhanced_encryption_outlined,
    'insert_link_outlined': Icons.insert_link_outlined
  };

  if (iconMap.containsKey(iconName)) {
    return iconMap[iconName]!;
  } else {
    throw Exception('Unknown icon name: $iconName');
  }
}

class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


/// - 主页
class Home extends StatefulWidget {

  final ProxyServer proxyServer;
  final ListenableList<HttpRequest> container;
  final HistoryTask historyTask;

  Home({super.key, required this.proxyServer, required this.container})
      :historyTask = HistoryTask.ensureInstance(proxyServer.configuration, container);

  @override
  State<Home> createState() => _homeState();

}

class _homeState extends State<Home> {

  late ProxyServer proxyServer;
  late ListenableList<HttpRequest> container;
  late HistoryTask historyTask;

  late AppInfo appInfo; // 获取Counter对象

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    proxyServer = widget.proxyServer;
    container = widget.container;
    historyTask = widget.historyTask;

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    appInfo = Provider.of<AppInfo>(context); // 获取Counter对象

    // 延迟到下一帧执行状态更新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 设置Ssl开启状态
      appInfo.setSslStatus(proxyServer.configuration.enableSsl);
    });




  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    bool isCN = Localizations.localeOf(context) == const Locale.fromSubtags(languageCode: 'zh');

    // 获取当前主题
    final brightness = Theme.of(context).brightness;
    final currentTheme = ColorTheme.of(brightness);

    // print(currentTheme.fontColor);

    // 构建工具列表组件
    List<ToolCard> toolcards = [];
    for(var el in tools){
      String iconName = el['icon'];
      String name = el['name'];
      
      toolcards.add(ToolCard(
        icon: getIcon(iconName),
        title: name,
        proxyServer: proxyServer,
      ));
    }
    
    // 构建设置列表组件
    List<SettingCard> settingCards = [];
    for (var el in settings) {
      String iconName = el['icon'];
      String name = el['name'];

      settingCards.add(SettingCard(
        icon: getIcon(iconName),
        title: name,
        proxyServer: proxyServer,
        container: container
      ));

    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Stream HTTP抓包工具',style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
          )),
          foregroundColor: currentTheme.fontColor,
          centerTitle: true,
          backgroundColor: currentTheme.background,
          // backgroundColor: const Color.fromRGBO(207, 213, 255, 1),
          automaticallyImplyLeading: false, // 禁用默认的返回按钮
          actions: <Widget>[
          IconButton(
          icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // 在这里放置搜索图标的点击逻辑
              navigatorHelper.navigator1(context, MobileFavorites(proxyServer: proxyServer));
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
              onPressed: () {
                // 在这里放置更多选项图标的点击逻辑
                navigatorHelper.navigator1(
                    context, MobileHistory(proxyServer: proxyServer, container: container, historyTask: historyTask));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: currentTheme.background,
              ),
              child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF3A53ED)),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async{

                            // 设置初始化组件就启动
                            // appInfo.setServerInitRunStatus(true);
                            //
                            // appInfo.setTabsIndex(1);

                            Navigator.pop(context, "打开抓包");


                          },
                          child: const Text(
                            '开始抓包',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: GestureDetector(
                          onTap: () {
                          // 在这里添加你的点击事件处理逻辑
                          // 例如，你可以打开一个对话框或执行其他操作
                            navigatorHelper.navigator1(context, MobileSslWidget(proxyServer: proxyServer));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(appInfo.isSslOpen! ? Icons.lock_open : Icons.lock),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(appInfo.isSslOpen ? '已启用HTTPS代理': '未启用HTTPS代理'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
            SizedBox(
              height: 250, // 为Column指定一个固定的高度
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // 将子项水平对齐到左侧
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16, left: 2, right: 2),
                      child: Text(
                        '工具',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(

                      child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8, // 设置水平间距
                        mainAxisSpacing: 8, // 设置垂直间距
                        children: toolcards,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 250, // 为Column指定一个固定的高度
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // 将子项水平对齐到左侧
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16, left: 2, right: 2),
                      child: Text(
                        '设置',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(

                      child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8, // 设置水平间距
                        mainAxisSpacing: 8, // 设置垂直间距
                        children: settingCards,
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
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
              icon: Icon(Icons.construction),
              label: '工具箱',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.blue,
          onTap: (index){
            if(index == 0){

              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (BuildContext context) {
              //     return Home(proxyServer: proxyServer, container: container,);
              //   })
              // );

              // navigator(context, Home(proxyServer: proxyServer, container: container,));
            }
            if(index == 1){
              Navigator.of(context).pop();
            }

            if(index == 2){ // 工具箱
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return futureWidget(AppConfiguration.instance,
                            (appConfiguration) => SettingMenu(proxyServer: proxyServer, appConfiguration: appConfiguration, container: container));
                  })

              );
            }

            // setState((){
            //
            //   print("===点击了index的===");
            //   print(index);
            //
            // });
          },
        ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final ProxyServer proxyServer;

  const ToolCard({super.key, this.icon = Icons.history, this.title = '工具名称',required this.proxyServer});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    final brightness = Theme.of(context).brightness;
    final currentTheme = ColorTheme.of(brightness);

    return GestureDetector(
      onTap: () async {
        // 在此处添加点击事件的处理逻辑
        if(title == '工具箱') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(title: Text(localizations.toolbox), centerTitle: true),
                  body: Toolbox(proxyServer: proxyServer));
            }),
          );
        }
        if(title == '过滤') {
          navigatorHelper.navigator1(context, FilterMenu(proxyServer: proxyServer));
        }
        if(title == '请求重写') {
          var requestRewrites = await RequestRewrites.instance;
          if (context.mounted) {
            navigatorHelper.navigator1(context, MobileRequestRewrite(requestRewrites: requestRewrites));
          }
        }
        if(title == '请求屏蔽') {
          var requestBlockManager = await RequestBlockManager.instance;
          if (context.mounted) {
            navigatorHelper.navigator1(context, MobileRequestBlock(requestBlockManager: requestBlockManager));
          }
        }
        if(title == '脚本') {
          navigatorHelper.navigator1(context, const MobileScript());
        }

        if(title == 'AES加密') {
          navigatorHelper.navigator1(context,  RSAEncrypter());
        }

        if(title == 'Socket测试') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>const WsApp())
          );
          // navigatorHelper.navigator1(context,  RSAEncrypter());
        }
      },
      child: Card(
        // color: Colors.white,
        color: currentTheme.cardItem,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              // color: const Color.fromRGBO(26, 163, 232, 1),
              color: currentTheme.fontColor,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: currentTheme.fontColor),
            ),
          ],
        ),
      ),
    );
  }

}


class SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final ProxyServer proxyServer;
  final ListenableList<HttpRequest> container;

  const SettingCard({super.key, this.icon = Icons.history, this.title = '设置名称', required this.proxyServer, required this.container});

  @override
  Widget build(BuildContext context) {

    final brightness = Theme.of(context).brightness;
    final currentTheme = ColorTheme.of(brightness);

    return
      GestureDetector(
        onTap: () async {
          // 在此处添加点击事件的处理逻辑
          if(title == '代理') {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ProxySetting(proxyServer: proxyServer)));
          }
          if(title == '语言') {
            _language(context);
          }
          if(title == '主题' ||  title == '自动抓包' || title == '窗口模式' || title == 'Headers') {
            navigatorHelper.navigator1(
                context,
                futureWidget(AppConfiguration.instance,
                        (appConfiguration) => SettingMenu(proxyServer: proxyServer, appConfiguration: appConfiguration,container: container)));
          }

          if(title == '关于') {
            navigatorHelper.navigator1(context, const About());
          }


        },
        child:
          Card(
            // color: Colors.white,
            color: currentTheme.cardItem,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  // color: const Color.fromRGBO(26, 163, 232, 1),
                  color: currentTheme.fontColor,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  // style: const TextStyle(fontSize: 14),
                  style: TextStyle(fontSize: 14, color: currentTheme.fontColor),
                ),
              ],
            ),
          )
      )
    ;
  }

  //选择语言
  void _language(BuildContext context) async {

    var instance = AppConfiguration.instance;
    var configuration = Configuration.instance;

    var appConfiguration = await instance;

    AppLocalizations localizations = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(left: 5, top: 5),
            actionsPadding: const EdgeInsets.only(bottom: 5, right: 5),
            title: Text(localizations.language, style: const TextStyle(fontSize: 16)),
            content: Wrap(
              children: [
                TextButton(
                    onPressed: () {
                      appConfiguration.language = null;
                      Navigator.of(context).pop();
                    },
                    child: Text(localizations.followSystem)),
                const Divider(thickness: 0.5, height: 0),
                TextButton(
                    onPressed: () {
                      appConfiguration.language = const Locale.fromSubtags(languageCode: 'zh');
                      Navigator.of(context).pop();
                    },
                    child: const Text("简体中文")),
                const Divider(thickness: 0.5, height: 0),
                TextButton(
                    child: const Text("English"),
                    onPressed: () {
                      appConfiguration.language = const Locale.fromSubtags(languageCode: 'en');
                      Navigator.of(context).pop();
                    }),
                const Divider(thickness: 0.5),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(localizations.cancel)),
            ],
          );
        });
  }
}

/// -抓包过滤菜单
class FilterMenu extends StatelessWidget {
  final ProxyServer proxyServer;

  const FilterMenu({super.key, required this.proxyServer});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(title: Text(localizations.filter, style: const TextStyle(fontSize: 16)), centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView(children: [
              ListTile(
                  title: Text(localizations.domainWhitelist),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () => navigatorHelper.navigator1(context,
                      MobileFilterWidget(configuration: proxyServer.configuration, hostList: HostFilter.whitelist))),
              ListTile(
                  title: Text(localizations.domainBlacklist),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () => navigatorHelper.navigator1(context,
                      MobileFilterWidget(configuration: proxyServer.configuration, hostList: HostFilter.blacklist))),
              Platform.isIOS
                  ? const SizedBox()
                  : ListTile(
                  title: Text(localizations.appWhitelist),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () => navigatorHelper.navigator1(context, AppWhitelist(proxyServer: proxyServer))),
              Platform.isIOS
                  ? const SizedBox()
                  : ListTile(
                  title: Text(localizations.appBlacklist),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () => navigatorHelper.navigator1(context, AppBlacklist(proxyServer: proxyServer))),
            ])));
  }
}


class RSAEncrypter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: kMainColor,
    ));
    return Sizer(builder: (context, orientation, deviceType) {
      return HomePage();
    });
  }
}




