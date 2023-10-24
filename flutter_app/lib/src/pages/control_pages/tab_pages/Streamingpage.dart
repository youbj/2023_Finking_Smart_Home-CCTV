import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../websocket/webrtc_controller.dart';
import '../websocket/webrtc_mainview.dart';
import '../websocket/webrtc_peerview.dart';

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
  }

  @override
  void didChangeDependencies() {
    // 수정 필요 --> 소켓 재접속 관련
    super.didChangeDependencies();
    print('실행은 함');
    if (!_controller.isSocketConnected()) {
      print('재접속');
      _controller.initHandler();
    }
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
            break;
        }
        return Scaffold(
          appBar: screenState == ScreenState.initDone
              ? AppBar(
                  title: const Text('Online User list'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.restart_alt,
                        color: Colors.white,
                      ),
                      tooltip: 'list reset',
                      onPressed: () async {
                        await _controller.requsetList();
                      },
                    ),
                  ],
                )
              : null,
          body: body,
          floatingActionButton: screenState == ScreenState.initDone
              ? FloatingActionButton(
                  child: const Icon(Icons.call),
                  onPressed: () async {
                    await _controller.sendOffer();

                    _moveToVideoView();
                  },
                )
              : null,
        );
      },
    );
  }

  Widget _initDone() {
    return SafeArea(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: _controller.userListNotifier,
        builder: (_, list, __) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              String userId = list[index];
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text(
                  userId,
                  style: TextStyle(
                    color: _controller.to == userId ? Colors.red : null,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _controller.to = userId;
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _receivedCalling() {
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _controller.sendAnswer();
                    _moveToVideoView();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.call),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _moveToVideoView() {
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebRTCPeerView(
          controller: _controller,
        ),
      ),
    ).whenComplete(() {
      _controller.screenNotifier.value = ScreenState.initDone;
    });
  }
}
