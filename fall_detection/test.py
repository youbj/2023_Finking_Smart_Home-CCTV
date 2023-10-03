from flask import Flask, render_template, request, redirect, url_for
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
    'ssl_disabled': True  # SSL 비활성화
}

@app.route('/')
def index():
    return render_template('index.html')
@app.route('/run_fall_detector')
def run_fall_detector():
    # MySQL 연결 생성
    connection = mysql.connector.connect(**db_config)

    # 커서 생성
    cursor = connection.cursor()

    # 이미 해당 id로 레코드가 있는지 확인
    check_query = "SELECT * FROM camera_log WHERE id = %s" ##테이블 확인하기 
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

    # subprocess를 사용하여 fall_detector.py 실행 (이 부분은 fall_detector.py가 정확한 경로에 있어야 함)
    cmd = 'python fall_detector.py'
    subprocess.Popen(cmd, shell=True)

    # 연결 및 커서 닫기
    cursor.close()
    connection.close()

    return 'Fall Detector is running!'

if __name__ == '__main__':
    app.run(debug=True, port=5000)
####