import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getCameraData() async {
  var baseUrl = Uri.parse('http://192.168.0.32:5001/get_camera_data');

  final response = await http.get(baseUrl);
  if (response.statusCode == 200) {
    // fall_detector.py 실행에 성공한 경우
    print('response success');
    return json.decode(response.body);
  } else {
    // fall_detector.py 실행에 실패한 경우
    print('Failed to run Fall Detector!');
    throw Exception('error');
  }
}

class CameraData {
  final String id;
  final String cameraStartTime;
  final String cameraImage;
  CameraData(this.id, this.cameraStartTime, this.cameraImage);
}

Future<CameraData> fetchData() async {
  try {
    final data = await getCameraData();
    String id = data['id'];
    String camera_start_time = data['camera_start_time'];
    String camera_image = data['camera_image'];
    return CameraData(id, camera_start_time, camera_image);
  } catch (error) {
    print('오류: $error');
    // 에러 처리가 필요한 경우 적절한 값이나 예외를 throw 할 수 있습니다.
    rethrow;
  }
}

void updateData() async {
  final updateUrl = Uri.parse('http://192.168.0.32:5001/run_fall_detector');
  try {
    final response = await http.get(updateUrl);
    if (response.statusCode == 200) {
      // fall_detector.py 실행에 성공한 경우
      print('Update!');
    } else {
      // fall_detector.py 실행에 실패한 경우
      print('Failed to run Fall Detector!');
    }
  } catch (e) {
    print('Error: $e');
  }
}
