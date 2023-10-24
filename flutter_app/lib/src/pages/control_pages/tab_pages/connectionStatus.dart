import 'package:flutter/material.dart';

class ConnectionStatus extends ChangeNotifier {
  //화면 이벤트 관리
  bool _connected = false;
  bool get connected => _connected;

  int _count = 0;
  int get count => _count;

  void setConnected(bool value) {
    _connected = value;
    notifyListeners();
  }
}
