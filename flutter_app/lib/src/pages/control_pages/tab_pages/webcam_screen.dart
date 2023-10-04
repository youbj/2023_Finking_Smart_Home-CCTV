import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/src/widgets/text.dart' as flutter;

Future<void> main() async {
  runApp(WebcamScreen());
}

class WebcamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBody();
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  bool cameraAccess = false;
  String? error;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    getCameras();
    super.initState();
  }

  Future<void> getCameras() async {
    try {
      await window.navigator.mediaDevices!
          .getUserMedia({'video': true, 'audio': false});
      setState(() {
        cameraAccess = true;
      });

      final cameras = await availableCameras();
      setState(() {
        this.cameras = cameras;
      });
    } on DomException catch (e) {
      setState(() {
        error = '${e.name}: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(child: flutter.Text('오류 발생: $error'));
    }
    if (!cameraAccess) {
      return Center(child: flutter.Text('아직 카메라 접근 권한이 허용되지 않았습니다.'));
    }
    if (cameras == null) {
      return Center(child: flutter.Text('카메라 목록을 가져오는 중입니다.'));
    }
    if (cameras!.isEmpty) {
      return Center(child: flutter.Text('사용 가능한 카메라가 없습니다.'));
    }
    return CameraView(camera: cameras![0]);
  }
}

class CameraView extends StatefulWidget {
  final CameraDescription camera;

  const CameraView({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Center(child: flutter.Text('Initializing camera...'));
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }
}
