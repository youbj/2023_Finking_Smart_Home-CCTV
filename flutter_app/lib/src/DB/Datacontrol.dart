import 'dart:convert';
import 'package:quiver/core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getCameraData() async { //실제 사용 X 
  var baseUrl = Uri.parse('http://172.20.10.3:5001/get_camera_data');

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

Future<Map<String, dynamic>> getCameraImage() async { 
  var baseUrl = Uri.parse('http://localhost:5001/generate_fall_capture');

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

// class CameraData {
//   final int id;
//   final String cameraStartTime;

//   CameraData(this.id, this.cameraStartTime, );
// }
// class ImageData{
//   final String imageUrl;

//   ImageData(this.imageUrl);
// }

// Future<Map<String, dynamic>> fetchData() async { // getcamera에서 받은 데이터를 처리 -> 이미지 받아야 함(or img string 값)--> page holder 106번 줄
//   try {
//     final data = await getCameraData();
//     final imageData = await getCameraImage();

//     int id = data['id'];
//     String cameraStartTime = data['camera_start_time'];
//     String imageUrl = imageData['image_url'];

//     return {
//       'cameraData': CameraData(id, cameraStartTime),
//       'cameraImage': ImageData(imageUrl),
//     };
//   } catch (error) {
//     print('오류: $error');
//     rethrow;
//   }
// }

// void updateData() async {
//   final updateUrl = Uri.parse('http://172.20.10.3:5001/run_fall_detector');
//   try {
//     final response = await http.get(updateUrl);
//     if (response.statusCode == 200) {
//       // fall_detector.py 실행에 성공한 경우
//       print('Update!');
//     } else {
//       // fall_detector.py 실행에 실패한 경우
//       print('Failed to run Fall Detector!');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

class CameraData {
  final int id;
  final String cameraStartTime;
  final String imageUrl;

  CameraData(this.id, this.cameraStartTime, this.imageUrl);
}

Future<CameraData> fetchData() async { // getcamera에서 받은 데이터를 처리 -> 이미지 받아야 함(or img string 값)--> page holder 106번 줄
  try {
    final data = await getCameraData();
    int id = data['id'];
    String cameraStartTime = data['camera_start_time'];
    String imageUrl = data['image_url'];

    return CameraData(id, cameraStartTime, imageUrl);
  } catch (error) {
    print('오류: $error');
    rethrow;
  }
}

void updateData() async {
  final updateUrl = Uri.parse('http://172.20.10.3:5001/run_fall_detector');
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