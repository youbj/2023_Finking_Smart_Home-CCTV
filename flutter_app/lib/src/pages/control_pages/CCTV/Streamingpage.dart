import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../DB/Datacontrol.dart';
import '../websocket/webrtc_controller.dart';
import '../websocket/webrtc_mainview.dart';

class Streamingpage extends StatefulWidget {
  const Streamingpage({Key? key}) : super(key: key);

  @override
  State<Streamingpage> createState() => _StreamingpageState();
}

class _StreamingpageState extends State<Streamingpage> {
  final WebRTCController _controller = WebRTCController();

  @override
  void initState() {
    super.initState();
    _controller.initHandler();
    print('초기화 되용');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScreenState>(
      valueListenable: _controller.screenNotifier,
      builder: (_, screenState, __) {
        late Widget body;
        switch (screenState) {
          case ScreenState.loading:
            body = const Center(
              child: Text('Loading...'),
            );
            break;
          case ScreenState.initDone:
            body = _initDone();
            break;
          case ScreenState.receivedCalling:
            body = _receivedCalling();
            // if (_controller.localVideoNotifier.value) {
            //   _controller.turnOffMedia();
            // }
            break;
        }
        return Scaffold(
          appBar: screenState != ScreenState.loading
              ? AppBar(
                  title: const Text('CCTV Mode'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.restart_alt,
                        color: Colors.white,
                      ),
                      tooltip: 'camera reset',
                      onPressed: () async {
                        await _controller.turnOffStreamming(); // 카메라 방향 전환
                      },
                    ),
                  ],
                )
              : null,
          body: body,
          floatingActionButton: screenState == ScreenState.initDone
              ? FloatingActionButton(
                  onPressed: () {
                    updateData();
                  },
                  tooltip: '감지 모드 켜기',
                  child: CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.videocam),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _initDone() {
    _controller.turnOnStreamming();
    return Stack(
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _controller.localVideoNotifier,
          builder: (_, value, __) {
            return value
                ? RTCVideoView(
                    _controller.localRenderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const Center(
                    child: Text('Loading...'),
                  );
          },
        ),
      ],
    );
  }

  Widget _receivedCalling() {
    Timer(Duration(seconds: 3), () {
      _controller.sendAnswer();
      _moveToVideoView();
    });

    return Stack(
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _controller.localVideoNotifier,
          builder: (_, value, __) {
            return value
                ? RTCVideoView(
                    _controller.localRenderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const Center(child: Icon(Icons.person_off));
          },
        ),
      ],
    );
  }

  void _moveToVideoView() {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebRTCMainView(
          controller: _controller,
        ),
      ),
    ).whenComplete(() {
      _controller.screenNotifier.value = ScreenState.initDone;
      Timer(Duration(seconds: 4), () {
        _controller.turnOnStreamming();
      });
    });
  }
}
