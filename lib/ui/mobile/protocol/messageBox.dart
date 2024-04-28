import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageBox extends StatefulWidget {
  MessageBox({super.key}) {}

  // ignore: library_private_types_in_public_api
  _MessageBoxState state = _MessageBoxState();

  void addMessage(String message) {
    state.addMessage(message);
  }

  @override
  // ignore: no_logic_in_create_state
  State<MessageBox> createState() => state;
}

class _MessageBoxState extends State<MessageBox> {
  String _message = '接收框：';

  _MessageBoxState() {}

  void addMessage(String message) {
    setState(() {
      _message += '\r\n$message';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Text(
        _message,
        softWrap: true,
        style: const TextStyle(
          color: Colors.white,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
