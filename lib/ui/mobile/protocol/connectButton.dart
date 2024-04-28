import 'package:flutter/material.dart';
import 'package:network_proxy/ui/mobile/protocol/websocket.dart';

// ignore: must_be_immutable
class ConnectButton extends StatefulWidget {
  Websocket _ws = Websocket();
  ConnectButton(Websocket ws, {super.key}) {
    _ws = ws;
  }

  @override
  // ignore: no_logic_in_create_state
  State<ConnectButton> createState() => _ConnectButtonState(_ws);
}

class _ConnectButtonState extends State<ConnectButton> {
  Websocket _wsConn = Websocket();
  String text = '连接';

  _ConnectButtonState(Websocket ws) {
    _wsConn = ws;
  }

  void _toggle() {
    setState(() {
      if (!_wsConn.isConnected) {
        _wsConn.connect();
      } else {
        _wsConn.disconnect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ButtonStyle(
              // backgroundColor:
              //     MaterialStateProperty.all(const Color(0xFFE8E8E8)),
              // shape: MaterialStateProperty.all(
              //   RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16.0),
              //   ),
              // ),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 14.0)),
              // minimumSize: MaterialStateProperty.all(const Size(0, 0)),
              // maximumSize: MaterialStateProperty.all(const Size(375.0, 36.0)),
            ),
            child: Text(
              !_wsConn.isConnected ? '连接' : '断开',
              style: TextStyle(
                fontSize: 14,
                color: !_wsConn.isConnected
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _toggle();
            },
          ),
        ),
      ],
    );
  }
}
