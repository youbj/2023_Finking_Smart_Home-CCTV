import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class WebRTCSocket {
  late io.Socket _socket;
  String? user;

  Future<String?> connectSocket() {
    final Completer<String> completer = Completer<String>();

    _socket = io.io('http://172.20.10.3:5002/', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.onConnect((data) {
      user = _socket.id;

      completer.complete(user);
      debugPrint('[socket] connected : $user');
    });

    return completer.future;
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
