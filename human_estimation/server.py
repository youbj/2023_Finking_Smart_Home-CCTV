from flask import Flask, render_template, request
from flask_cors import CORS
from flask_socketio import SocketIO


app = Flask(__name__)
CORS(app)
socketio = SocketIO(app,  cors_allowed_origins="*")

userList = []


@app.route('/')
def index():
    return render_template('index.html')

@socketio.on('connect')
def handle_connection():
    userId = request.sid
    userList.append(userId)
#유저 연결시 데이터 보냄
    print(f'[connection] userLogin: {userId}')
    socketio.emit('updateUserlist', {'userList': userList})
    print(f'[connection] userList sent: {userList}')


#offer가 왔을 때 처리
#1. [caller] 본인 아이디, 상대 아이디, offer data 전달
#2. 상대에게 본인 아이디, offer data 전달
@socketio.on('offer')
def handle_offer(data):
    to = data['to']
    from_user = data['from']
    offer_type = data['offerType']
    offer_sdp = data['offerSDP']
    audio_only = data['audioOnly']
    print(f'[offer] data: to: {to}, from: {from_user}, audioOnly: {audio_only}')
    socketio.emit('offer', {'from': from_user, 'offerSDP': offer_sdp, 'offerType': offer_type, 'audioOnly': audio_only}, room=to)

#offer refuse 처리
@socketio.on('refuse')
def handle_refuse(data):
    to = data['to']
    print(f'[offer] refuse: {to}')
    socketio.emit('refuse', room=to)

#offer 요청에 대한 answer 응답 처리
#1. [callee] 상대방 아이디, answer data 전달
#2. 상대에게 answer data 전달
@socketio.on('answer')
def handle_answer(data):
    to = data['to']
    answer_sdp = data['answerSDP']
    answer_type = data['answerType']
    print(f'[answer] data: to: {to}')
    socketio.emit('answer', {'answerSDP': answer_sdp, 'answerType': answer_type}, room=to)

# ice candidate
# send offer/answer 발생시 상대방에게 network정보 전달
@socketio.on('iceCandidate')
def handle_ice_candidate(data):
    to = data['to']
    candidate = data['candidate']
    sdp_mid = data['sdpMid']
    sdp_mline_index = data['sdpMLineIndex']
    print(f'[iceCandidate] data: to: {to}, candidate: {candidate}, sdpMid: {sdp_mid}, sdpMLineIndex: {sdp_mline_index}')
    socketio.emit('remoteIceCandidate', {'candidate': candidate, 'sdpMid': sdp_mid, 'sdpMLineIndex': sdp_mline_index, 'to': to}, room=to)

#close peer connection
@socketio.on('disconnectPeer')
def handle_disconnect_peer(data):
    to = data['to']
    print(f'[disconnect] to: {to}')
    if to is not None:
        socketio.emit('disconnectPeer', room=to)

#연결 해제시 userlist update
@socketio.on('disconnect')
def handle_disconnect():
    userId = request.sid
    userList.remove(userId)
    socketio.emit('updateUserlist', {'userList': userList}, broadcast=True)
    print(f'[disconnected] id: {userId}')

if __name__ == '__main__':
    socketio.run(app,host='192.168.0.13', port=5002,debug=True )