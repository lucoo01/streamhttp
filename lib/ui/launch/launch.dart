import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:network_proxy/network/bin/server.dart';
import 'package:network_proxy/utils/lang.dart';
import 'package:network_proxy/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

import 'package:provider/provider.dart';
import 'package:network_proxy/utils/appInfo.dart';

class SocketLaunch extends StatefulWidget {
  static ValueNotifier<ValueWrap<bool>> startStatus = ValueNotifier(ValueWrap());

  final ProxyServer proxyServer;
  final int size;
  final bool startup; //默认是否启动
  final bool serverInitRun; // 是否初始化组件就立即启动
  final Function? onStart;
  final Function? onStop;

  final bool serverLaunch; //是否启动代理服务器

  const SocketLaunch(
      {super.key,
      required this.proxyServer,
      this.size = 25,
      this.onStart,
      this.onStop,
      this.startup = true,
      this.serverInitRun = false,
      this.serverLaunch = true,
      });

  @override
  State<StatefulWidget> createState() => _SocketLaunchState();
}

class _SocketLaunchState extends State<SocketLaunch> with WindowListener, WidgetsBindingObserver {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  bool started = false;

  late AppInfo appInfo; // 获取Counter对象

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appInfo = Provider.of<AppInfo>(context); // 获取Counter对象
  }


  @override
  void initState() {
    super.initState();

    started = widget.serverLaunch;

    windowManager.addListener(this);
    WidgetsBinding.instance.addObserver(this);
    //启动代理服务器
    if (started == false && (widget.startup || widget.serverInitRun)) {
      start();
    }

    if (Platforms.isDesktop()) {
      windowManager.setPreventClose(true);
    }
    SocketLaunch.startStatus.addListener(() {
      if (SocketLaunch.startStatus.value.get() == started) {
        return;
      }
      setState(() {
        started = SocketLaunch.startStatus.value.get() ?? started;
        appInfo.setServerStatus(started);
      });
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    print("onWindowClose");
    await appExit();
  }

  Future<void> appExit() async {
    await widget.proxyServer.stop();
    started = false;
    appInfo.setServerStatus(started);
    await windowManager.destroy();
    exit(0);
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await appExit();
    return super.didRequestAppExit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      print('AppLifecycleState.detached');
      widget.onStop?.call();
      widget.proxyServer.stop();
      started = false;
      appInfo.setServerStatus(started);
    }
  }

  @override
  Widget build(BuildContext context) {

    // super.build(context); // 必须调用 super.build

    return IconButton(
        tooltip: started ? localizations.stop : localizations.start,
        icon: Icon(started ? Icons.stop : Icons.play_arrow_sharp,
            color: started ? Colors.red : Colors.green, size: widget.size.toDouble()),
        onPressed: () async {
          if (started) {
            if (!widget.serverLaunch) {
              setState(() {
                widget.onStop?.call();
                started = !started;
                appInfo.setServerStatus(started);
              });
              return;
            }

            widget.proxyServer.stop().then((value) {
              widget.onStop?.call();
              setState(() {
                started = !started;
                appInfo.setServerStatus(started);
              });
            });
          } else {
            start();
          }
        });
  }

  /// -启动代理服务器
  start() async {

    if (!widget.serverLaunch) {
      await widget.onStart?.call();
      setState(() {
        started = true;
        appInfo.setServerStatus(started);
        appInfo.setServerInitRunStatus(false);

      });
      return;
    }

    widget.proxyServer.start().then((value) {
      setState(() {
        started = true;

        appInfo.setServerStatus(started);
      });
      widget.onStart?.call();
    }).catchError((e) {
      appInfo.setServerStatus(false);
      String message = localizations.proxyPortRepeat(widget.proxyServer.port);
      FlutterToastr.show(message, context, duration: 3);
    });
  }
}
