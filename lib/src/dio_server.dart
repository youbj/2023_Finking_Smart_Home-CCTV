import 'package:dio/dio.dart';

const url = "https://leeyeongyu.pythonanywhere.com/api/endpoint";
// Flask 서버의 엔드포인트 URL 설정

class Server {
  Future<void> getReq() async {
    try {
      // Dio 클라이언트 생성
      Dio dio = Dio();

      // GET 요청 보내기
      Response response = await dio.get(url);

      // 응답 처리
      if (response.statusCode == 200) {
        // 성공적인 응답
        print(response.data);
      } else {
        // 오류 응답
        print('오류 응답 - 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('오류 발생: $e');
    }
  }
}

Server server = Server();
