import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:network_proxy/ui/mobile/protocol/connectButton.dart';
import 'package:network_proxy/ui/mobile/protocol/websocket.dart';
import 'package:network_proxy/ui/mobile/protocol/messageBox.dart';

const appName = 'Socket测试助手';
String protocol = 'websocket';
Websocket ws = Websocket();
MessageBox receiveBox = MessageBox();

class WsApp extends StatelessWidget {
  const WsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.quiz_outlined),
        //     onPressed: () {},
        //   ),
        // ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        title: const Text('Socket测试工具'),
        toolbarHeight: 50,
        // iconTheme: const IconThemeData(
        //   color: Colors.blueAccent,
        //   opacity: 0.5,
        // ),
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Colors.blueAccent,
      //   items: const <Widget>[
      //     Icon(Icons.connected_tv, size: 30),
      //     Icon(Icons.list, size: 30),
      //     Icon(Icons.settings, size: 30),
      //   ],
      //   onTap: (index) {
      //     //Handle button tap
      //   },
      // ),
      body: const Index(),
    );
  }
}

class Index extends StatelessWidget {
  const Index({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white70,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.network_cell),
                    iconColor: Colors.black87,
                    label: Text('请选择网络协议'),
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: const TextStyle(color: Colors.black87),
                  dropdownColor: const Color.fromARGB(255, 187, 215, 229),
                  iconEnabledColor: Colors.black87,
                  items: const [
                    DropdownMenuItem(
                      value: 'ws',
                      enabled: true,
                      child: Text('Websocket'),
                    ),
                  ],
                  onChanged: (value) {
                    protocol = value!;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '',
                    hintStyle: TextStyle(color: Colors.black87),
                    border: InputBorder.none,
                    icon: Icon(Icons.connected_tv),
                    iconColor: Colors.black87,
                    label: Text('点击输入网络地址'),
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: const TextStyle(color: Colors.black87),
                  onChanged: (value) {
                    ws.setCallback(onMessage, onClose, onError);
                    ws.setAddress(value);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ConnectButton(ws),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView( // Wrap receiveBox with SingleChildScrollView
                    child: receiveBox,
                  ),
                ),
              ]),
        ));
  }
}

void onMessage(dynamic message) {
  receiveBox.addMessage(message);
  print(message);
}

void onClose() {
  print('close');
}

void onError(e) {
  print(e);
}
