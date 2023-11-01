import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:guardian/src/pages/control_pages/websocket/webrtc_controller.dart';

class WebRTCMainView extends StatefulWidget {
  const WebRTCMainView({Key? key, this.controller}) : super(key: key);

  final WebRTCController? controller;

  @override
  State<WebRTCMainView> createState() => _WebRTCMainViewState();
}

class _WebRTCMainViewState extends State<WebRTCMainView> {
  late final WebRTCController _controller;
  final ValueNotifier<bool> _btnNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller!;
  }

  @override
  void dispose() {
    _btnNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.webRTCVideoViewContext = context;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('CCTV Mode'),
          ),
          body: GestureDetector(
            onTap: () {
              _btnNotifier.value = !_btnNotifier.value;
            },
            child: Stack(
              children: [
                _videoWidget(
                    _controller.localVideoNotifier, _controller.localRenderer!),
                _btnWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<bool>(
        valueListenable: _btnNotifier,
        builder: (_, visible, __) => visible
            ? Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        await _controller.close(null);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _videoWidget(ValueNotifier<bool> listener, RTCVideoRenderer renderer) {
    return ValueListenableBuilder<bool>(
      valueListenable: listener,
      builder: (_, value, __) {
        return value
            ? RTCVideoView(
                renderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              )
            : const Center(
                child: Icon(Icons.person_off),
              );
      },
    );
  }
}
