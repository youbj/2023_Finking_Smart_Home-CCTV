from flask import Flask, render_template
from flask_cors import CORS
import subprocess

app = Flask(__name__)
CORS(app)
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/run_fall_detector')
def run_fall_detector():
    # fall_detector.py를 실행하는 명령어
    cmd = 'python main.py --source 0'
    
    # subprocess를 사용하여 명령어 실행
    subprocess.Popen(cmd, shell=True)
    
    return 'Fall Detector is running!'

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=5001)
