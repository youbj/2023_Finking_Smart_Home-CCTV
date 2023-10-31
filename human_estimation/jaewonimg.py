from flask import Flask, render_template, request, jsonify, send_from_directory, url_for
import os

app = Flask(__name__)

# 이미지를 저장할 디렉토리 설정
UPLOAD_FOLDER = 'images'  # 이미지를 업로드할 상대 경로 설정
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' in request.files:
        image = request.files['image']
        if image:
            # 이미지를 업로드할 경로 설정
            image_path = os.path.join(app.config['UPLOAD_FOLDER'], image.filename)
            image.save(image_path)
            
            # 이미지의 URL 생성
            imageurl = url_for('uploaded_file', filename=image.filename)
            
            # 여기서 데이터베이스에 이미지 URL을 저장하는 코드를 추가
            # 예를 들어, MySQL 데이터베이스에 저장하는 코드:
            import pymysql

            # 데이터베이스 연결 설정
            db = pymysql.connect(host="localhost", user="root", password="1234", db="flask")
            cursor = db.cursor()

            # 이미지 URL을 데이터베이스에 저장
            update_query = "UPDATE camera_log SET imageurl = %s WHERE id = 3801"
            cursor.execute(update_query, (imageurl,))
            db.commit()
            db.close()
            
            return jsonify({"message": "Image uploaded successfully", "imageurl": imageurl})

    
    return jsonify({"error": "No image provided"})

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

@app.route('/')
def index():
    return render_template('indexjaewon.html')
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000,debug=True )
