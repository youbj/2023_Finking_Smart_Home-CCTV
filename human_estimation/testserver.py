from flask import Flask, render_template
from flask_cors import CORS
from flask_socketio import SocketIO, send

app = Flask(__name__)
CORS(app)
socketio = SocketIO(app,  cors_allowed_origins="*")

# Flask 라우트를 정의합니다.
@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('example')
def expmple_send(msg):
    print(msg)
    for i in range(10):
        socketio.send(str(i)) # flutter로 전송
        socketio.sleep(0.5)

@socketio.on('message')
def handle_message(data): #데이터 받는 방식
    print('received message: ' + data)


if __name__ == '__main__':
    socketio.run(app,host='192.168.0.13', port=5002,debug=True )