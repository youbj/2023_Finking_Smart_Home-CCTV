import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class WebRTCSocket {
  late io.Socket _socket;
  String? user;

  Future<String?> connectSocket() {
    final Completer<String> completer = Completer<String>();

    _socket = io.io('http://192.168.0.30:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.onConnect((data) {
      user = _socket.id;

      completer.complete(user);
      debugPrint('[socket] connected : $user');
    });

    return completer.future;
  }

  bool isSocketConnected() {
    return _socket.connected; // 연결이 있으면 true, 그렇지 않으면 false를 반환
  }

  void socketOn(String event, void Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void socketEmit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void disconnectSocket() {
    _socket.dispose();
  }
}
