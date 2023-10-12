from flask import Flask, render_template
from flask_cors import CORS
from flask_socketio import SocketIO, emit

app = Flask(__name__)
CORS(app)
socketio = SocketIO(app,  cors_allowed_origins="*")

@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('connect')
def handle_connect():
    print('Client connected')

@socketio.on('message_from_client')
def handle_message(data):
    print('Message from client:', data)
    emit('message_from_server', data)

if __name__ == '__main__':
    socketio.run(app,host='0.0.0.0',port=5002, debug=True)