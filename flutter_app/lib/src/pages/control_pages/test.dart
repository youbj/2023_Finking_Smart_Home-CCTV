// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ImageDisplay extends StatefulWidget {
//   @override
//   _ImageDisplayState createState() => _ImageDisplayState();
// }

// class _ImageDisplayState extends State<ImageDisplay> {
//   late io.Socket socket;

//   @override
//   void initState() {
//     super.initState();

//     socket = io.io('http://192.168.0.11:5001', <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket.on('connect', (_) {
//       print('Socket connected');
//     });

//     // 이미지 데이터 수신
//     socket.on('update_image', (data) {
//       String imageData = data['imageData'];

//       // 이미지 데이터를 디코드하여 바이트 배열로 변환
//       List<int> imageBytes = Uint8List.fromList(Uint8List.fromList(imageData.codeUnits));

//       // 이미지를 Memory Image로 변환하여 화면에 표시
//       MemoryImage memoryImage = MemoryImage(Uint8List.fromList(imageBytes));

//       setState(() {
//         // 상태를 업데이트하여 이미지를 다시 그립니다.
//         _displayedImage = Container(
//           child: Image(image: memoryImage),
//         );
//       });
//     });

//     socket.connect();
//   }

//   Widget _displayedImage = Container();

//   Future<void> sendImage() async {
//     final imagePicker = ImagePicker();
//     final image = await imagePicker.pickImage(source: ImageSource.gallery);

//     if (image == null) {
//       print('No image selected');
//       return;
//     }

//     final imageFile = File(image.path);
//     List<int> imageBytes = await imageFile.readAsBytes();
//     String imageBase64 = String.fromCharCodes(imageBytes);

//     // 이미지 데이터를 서버로 보냅니다.
//     socket.emit('image_update', {'imageData': imageBase64});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: sendImage,
//             child: Text('Send Image to Server'),
//           ),
//           _displayedImage,
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     socket.disconnect();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebcamDisplay extends StatefulWidget {
  @override
  _WebcamDisplayState createState() => _WebcamDisplayState();
}

class _WebcamDisplayState extends State<WebcamDisplay> {
  RTCVideoRenderer _rtcVideoRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initializeWebcam();
  }

  _initializeWebcam() async {
    await _rtcVideoRenderer.initialize();
    final mediaStream = await navigator.mediaDevices.getUserMedia({'video': true});
    _rtcVideoRenderer.srcObject = mediaStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webcam Display'),
      ),
      body: Center(
        child: RTCVideoView(_rtcVideoRenderer),
      ),
    );
  }

  @override
  void dispose() {
    _rtcVideoRenderer.srcObject?.getTracks().forEach((track) => track.stop());
    _rtcVideoRenderer.dispose();
    super.dispose();
  }
}
