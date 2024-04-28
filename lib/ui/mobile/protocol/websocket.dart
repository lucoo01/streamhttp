import 'package:web_socket_channel/web_socket_channel.dart';

class Websocket {
  String _address = '';
  dynamic _onMessage, _onClose, _onError;

  WebSocketChannel? connection;
  bool isConnected = false;

  void setAddress(String address) {
    _address = address;
  }

  void setCallback(dynamic onMessage, onClose, onError) {
    _onMessage = onMessage;
    _onClose = onClose;
    _onError = onError;
  }

  void connect() {
    try {
      final wsUrl = Uri.parse(_address);
      connection = WebSocketChannel.connect(wsUrl);
      isConnected = true;
      connection?.stream.listen(_onMessage, onDone: () {
        isConnected = false;
        _onClose();
      }, onError: _onError);
    } catch (e) {}
  }

  void disconnect() {
    try {
      connection?.sink.close();
      isConnected = false;
    } catch (e) {}
  }
}
