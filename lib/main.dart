import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:network_proxy/network/bin/configuration.dart';
import 'package:network_proxy/ui/component/chinese_font.dart';
import 'package:network_proxy/ui/component/multi_window.dart';
import 'package:network_proxy/ui/configuration.dart';
import 'package:network_proxy/ui/desktop/desktop.dart';
import 'package:network_proxy/ui/mobile/mobile.dart';
import 'package:network_proxy/utils/navigator.dart';
import 'package:network_proxy/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

import 'package:provider/provider.dart';
import 'package:network_proxy/utils/appInfo.dart';
import 'package:network_proxy/ui/mobile/tabs/tabs.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized(); // 当你在应用程序中需要使用Flutter框架的功能时，例如读取资源、执行网络请求等，你需要确保绑定已经被初始化。

  var appConfigurationInstance = AppConfiguration.instance;
  //多窗口
  if (args.firstOrNull == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty ? const {} : jsonDecode(args[2]) as Map<String, dynamic>;
    runApp(FluentApp(multiWindow(windowId, argument), (await appConfigurationInstance)));
    return;
  }

  var configurationInstance = Configuration.instance;

  var appConfiguration = await appConfigurationInstance;
  var configuration = await configurationInstance;



  //移动端
  if (Platforms.isMobile()) {
    runApp(FluentApp(MobileHomePage(configuration, appConfiguration), appConfiguration));

    // runApp(FluentApp(Tabs(configuration, appConfiguration), appConfiguration));
    return;
  }

  await windowManager.ensureInitialized();
  //设置窗口大小
  WindowOptions windowOptions = WindowOptions(
      minimumSize: const Size(1000, 600),
      size: Platform.isMacOS ? const Size(1230, 750) : const Size(1100, 650),
      center: true,
      titleBarStyle: Platform.isMacOS ? TitleBarStyle.hidden : TitleBarStyle.normal);

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // var appConfiguration = await appConfigurationInstance;
  registerMethodHandler();
  runApp(FluentApp(DesktopHomePage(configuration, appConfiguration), appConfiguration));
}

class FluentApp extends StatelessWidget {
  final Widget home;
  final AppConfiguration appConfiguration;

  const FluentApp(this.home, this.appConfiguration, {super.key});

  @override
  Widget build(BuildContext context) {
    var light = lightTheme();
    var darkTheme = config(ThemeData.dark(useMaterial3: false));

    var material3Light = config(ThemeData.light(useMaterial3: true));
    var material3Dark = config(ThemeData.dark(useMaterial3: true));

    if (Platform.isWindows) {
      material3Light = material3Light.useSystemChineseFont();
      material3Dark = material3Dark.useSystemChineseFont();
      light = light.useSystemChineseFont();
      darkTheme = darkTheme.useSystemChineseFont();
    }

    return ValueListenableBuilder<bool>(
        valueListenable: appConfiguration.globalChange,
        builder: (_, current, __) {
          return
            ChangeNotifierProvider(
              create: (context) => AppInfo(), // 创建AppInfo对象并提供给应用
              child: MaterialApp(
                title: 'Stream HTTP抓包工具',
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorHelper.navigatorKey,
                theme: appConfiguration.useMaterial3 ? material3Light : light,
                darkTheme: appConfiguration.useMaterial3 ? material3Dark : darkTheme,
                themeMode: appConfiguration.themeMode,
                locale: appConfiguration.language,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: home,
              )
            );
        });
  }

  ThemeData config(ThemeData themeData) {
    return themeData.copyWith(
        dialogTheme: themeData.dialogTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  /// -浅色主题
  ThemeData lightTheme() {
    var theme = ThemeData.light(useMaterial3: false);
    theme = theme.copyWith(
        dialogTheme: theme.dialogTheme.copyWith(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        expansionTileTheme: theme.expansionTileTheme.copyWith(
          textColor: theme.textTheme.titleMedium?.color,
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle: theme.textTheme.titleMedium,
          iconTheme: theme.iconTheme,
        ),
        tabBarTheme: theme.tabBarTheme.copyWith(
          labelColor: theme.indicatorColor,
          unselectedLabelColor: theme.textTheme.titleMedium?.color,
        ));

    return theme;
  }
}
