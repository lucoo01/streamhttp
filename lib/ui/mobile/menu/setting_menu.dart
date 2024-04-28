import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:network_proxy/network/bin/server.dart';
import 'package:network_proxy/network/http/http.dart';
// import 'package:network_proxy/storage/histories.dart';
import 'package:network_proxy/ui/component/widgets.dart';
import 'package:network_proxy/ui/configuration.dart';
import 'package:network_proxy/ui/mobile/setting/proxy_setting.dart';
import 'package:network_proxy/ui/mobile/setting/mobile_theme.dart';

//import 'package:network_proxy/ui/component/utils.dart';
// import 'package:network_proxy/utils/navigator.dart';
// import 'package:network_proxy/ui/mobile/widgets/home.dart';

// import 'package:network_proxy/network/bin/configuration.dart';
import 'package:network_proxy/utils/listenable_list.dart';

// import 'package:network_proxy/ui/mobile/mobile.dart';

/// -设置
class SettingMenu extends StatelessWidget {
  final ProxyServer proxyServer;
  final AppConfiguration appConfiguration;
  final ListenableList<HttpRequest> container;

  const SettingMenu({super.key, required this.proxyServer, required this.appConfiguration, required this.container});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;



    return Scaffold(
        appBar: AppBar(
            title: Text(localizations.setting,
            style: const TextStyle(fontSize: 16)),
            centerTitle: true,
            automaticallyImplyLeading: false, // 禁用默认的返回按钮
        ),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView(children: [
              ListTile(
                  title: Text(localizations.proxy),
                  trailing: const Icon(Icons.arrow_right),
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ProxySetting(proxyServer: proxyServer)))),
              ListTile(
                title: Text(localizations.language),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => _language(context),
              ),
              MobileThemeSetting(appConfiguration: appConfiguration),
              ListTile(
                  title: Text(localizations.autoStartup), //默认是否启动
                  subtitle: Text(localizations.autoStartupDescribe, style: const TextStyle(fontSize: 12)),
                  trailing: SwitchWidget(
                      value: proxyServer.configuration.startup,
                      scale: 0.8,
                      onChanged: (value) {
                        proxyServer.configuration.startup = value;
                        proxyServer.configuration.flushConfig();
                      })),
              ListTile(
                  title: Text(localizations.windowMode),
                  subtitle: Text(localizations.windowModeSubTitle, style: const TextStyle(fontSize: 12)),
                  trailing: SwitchWidget(
                      value: appConfiguration.pipEnabled.value,
                      scale: 0.8,
                      onChanged: (value) {
                        appConfiguration.pipEnabled.value = value;
                        appConfiguration.flushConfig();
                      })),
              if (Platform.isAndroid)
                ListTile(
                    title: Text(localizations.windowIcon),
                    subtitle: Text(localizations.windowIconDescribe, style: const TextStyle(fontSize: 12)),
                    trailing: SwitchWidget(
                        value: appConfiguration.pipIcon.value,
                        scale: 0.8,
                        onChanged: (value) {
                          appConfiguration.pipIcon.value = value;
                          appConfiguration.flushConfig();
                        })),
              ListTile(
                  title: Text(localizations.headerExpanded),
                  subtitle: Text(localizations.headerExpandedSubtitle, style: const TextStyle(fontSize: 12)),
                  trailing: SwitchWidget(
                      value: appConfiguration.headerExpanded,
                      scale: 0.8,
                      onChanged: (value) {
                        appConfiguration.headerExpanded = value;
                        appConfiguration.flushConfig();
                      }))
            ])
        ),

    );
  }

  //选择语言
  void _language(BuildContext context) {
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
