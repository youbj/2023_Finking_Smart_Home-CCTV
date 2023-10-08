import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home`s Cam'),
        ),
        body: AppBody(),
      ),
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.max,
      enableAudio: false, // 오디오 사용 여부 설정
    );

    await _controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void runFallDetector() async {
    final baseUrl = Uri.parse('http://0.0.0.0:5001/run_fall_detector');
    try {
      final response = await http.get(baseUrl);
      if (response.statusCode == 200) {
        // fall_detector.py 실행에 성공한 경우
        print('Fall Detector is running!');
      } else {
        // fall_detector.py 실행에 실패한 경우
        print('Failed to run Fall Detector!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Column(
        children: [
          Container(
              height: size.height * 0.8, child: CameraPreview(_controller)),
          ElevatedButton(
              onPressed: () async {
                runFallDetector();
              },
              child: Text('test'))
        ],
      ),
    );
  }
}
