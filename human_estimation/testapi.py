from flask import Flask, render_template, request, redirect, url_for, jsonify #  Flask, request, jsonify 필수 
import subprocess
import mysql.connector
from datetime import datetime

app = Flask(__name__)

# MySQL 연결 설정
db_config = {
    'user': 'root',
    'password': '1234',
    'host': 'localhost',
    'database': 'flask',
    #'ssl_disabled': True  # SSL 비활성화
}

@app.route('/')
def index():
    return render_template('index.html')

# 백엔드에서 제공하는 API 엔드포인트
@app.route('/get_camera_data', methods=['GET'])
def get_camera_data():
    # MySQL 연결 생성
    connection = mysql.connector.connect(**db_config)

    # 커서 생성
    cursor = connection.cursor()

    # 데이터베이스에서 데이터 조회
    query = "SELECT * FROM camera_log WHERE id = %s"  # id로 필터링
    values = ("3801",)
    cursor.execute(query, values)
    data = cursor.fetchone()  # 한 레코드만 가져옴 (여러 레코드라면 fetchall() 사용)

    # 연결 및 커서 닫기
    cursor.close()
    connection.close()

    if data:
        # 데이터가 존재할 경우 JSON 형태로 응답
        response = {
            'id': data[0],                # id 컬럼
            'camera_start_time': data[1]  # camera_start_time 컬럼
        }
        return jsonify(response)  # JSON 형태로 데이터 반환
    else:
        return jsonify({'message': '데이터가 없습니다.'}), 404  # 데이터가 없을 경우 404 응답

@app.route('/run_fall_detector')
def run_fall_detector():
    # MySQL 연결 생성
    connection = mysql.connector.connect(**db_config)

    # 커서 생성
    cursor = connection.cursor()

    # 이미 해당 id로 레코드가 있는지 확인
    check_query = "SELECT * FROM camera_log WHERE id = %s"
    check_values = ("3801",)
    cursor.execute(check_query, check_values)
    existing_record = cursor.fetchone()

    if existing_record:
        # 이미 레코드가 존재하면 해당 레코드를 업데이트
        camera_start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        update_query = "UPDATE camera_log SET camera_start_time = %s WHERE id = %s"
        update_values = (camera_start_time, "3801")
        cursor.execute(update_query, update_values)
    else:
        # 레코드가 없으면 새로 삽입
        camera_start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        insert_query = "INSERT INTO camera_log (id, camera_start_time) VALUES (%s, %s)"
        insert_values = ("3801", camera_start_time)
        cursor.execute(insert_query, insert_values)

    connection.commit()  # 데이터베이스에 변경 사항을 커밋.

    # subprocess를 사용하여 python main.py 실행 (이 부분은 python main.py가 정확한 경로에 있어야 함)
    cmd = 'python main.py'
    subprocess.Popen(cmd, shell=True)

    # 연결 및 커서 닫기
    cursor.close()
    connection.close()

    return 'Fall Detector is running!'
# 넘어진 감지 스크린샷 프론트로 api전송 
@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return '파일이 없습니다.'
    
    file = request.files['file']
    
    if file.filename == '': #파일의 이름이 비어있다면 
        return '파일을 선택하지 않았습니다.'
    
    # 업로드된 파일을 저장할 경로 지정
    save_path = 'C:\\Users\\20map\\Desktop\\Jaewon2\\2023_Finking_Smart_Home-CCTV\\human_estimation\\images\\'
    file.save(save_path + file.filename)
    
    return '파일 업로드 완료'


if __name__ == '__main__':
    
    app.run(debug=True, port=5001)

# 사용법:
# /get_camera_data:  엔드포인트로 GET 요청을 보내면 카메라에 관련된 데이터가 JSON 형식으로 반환

# 데이터 형식:
# 반환되는 데이터는 JSON
# id: 카메라 ID (정수)
# camera_start_time: 카메라 작동 시작 시간 (문자열)
