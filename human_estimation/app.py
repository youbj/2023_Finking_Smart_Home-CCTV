from flask import Flask, render_template, request, jsonify, send_from_directory #  Flask, request, jsonify 필수 
import subprocess
import mysql.connector
import requests
from datetime import datetime

app = Flask(__name__)


# MySQL 연결 설정
db_config = {
    'user': 'root',
    'password': '1234',
    'host': 'localhost',
    'database': 'flask',
    'ssl_disabled': True  # SSL 비활성화

}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/images/<filename>')
def images(filename):
    return send_from_directory('images', filename)

# 백엔드에서 제공하는 API 엔드포인트
@app.route('/get_camera_data', methods=['GET'])
def get_camera_data():
    # MySQL 연결 생성
    connection = mysql.connector.connect(**db_config)

    # 커서 생성
    cursor = connection.cursor()

    # 데이터베이스에서 데이터 조회
    query = "SELECT * FROM camera_log3 WHERE id = %s"  # id로 필터링
    values = ("이연규",) #values 값 고정
    cursor.execute(query, values)
    data = cursor.fetchone()  # 한 레코드만 가져옴 (여러 레코드라면 fetchall() 사용)

    # 연결 및 커서 닫기
    cursor.close()
    connection.close()
    
    if data:
        # 데이터가 존재할 경우 JSON 형태로 응답
        response = {
            'id': data[0],                # id 컬럼
            'camera_start_time': data[1],  # camera_start_time 컬럼
            'camera_image' : data[2]
        }
        return jsonify(response)  # JSON 형태로 데이터 반환
    else:
        return jsonify({'message': '데이터가 없습니다.'}), 404  # 데이터가 없을 경우 404 응답

@app.route('/run_fall_detector')
def run_fall_detector():

    # subprocess를 사용하여 python main.py 실행 (이 부분은 python main.py가 정확한 경로에 있어야 함)
    cmd = 'python before_main.py'
    subprocess.Popen(cmd, shell=True)


    return 'Fall Detector is running!'

# 넘어진 감지 스크린샷 프론트로 api전송 
@app.route('/upload', methods=['POST'])
def upload_file():

    user = request.form.get('user')
    current_time = request.form.get('current_time')
    filename = request.form.get('filename')
    situation = request.form.get('situation')

    print(f'user: {user}')

    return jsonify({'message': 'File uploaded successfully', 'user': user, 'current_time': current_time, 'filename': filename, 'situation': situation})
   
    
    
    
    


# # 유병주가 개발 중
# @app.route('/generate_fall_capture', methods=['POST'])
# def generate_fall_capture():
#     data = request.get_json()
#     image_path = main.generate_image(data.get('..\image'))  # 이미지 파일 경로 가져오기
    
#     return jsonify({"image_path": image_path})

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True,port=5001)
   


# 사용법:
# /get_camera_data:  엔드포인트로 GET 요청을 보내면 카메라에 관련된 데이터가 JSON 형식으로 반환

# 데이터 형식:
# 반환되는 데이터는 JSON
# id: 카메라 ID (정수)
# camera_start_time: 카메라 작동 시작 시간 (문자열)