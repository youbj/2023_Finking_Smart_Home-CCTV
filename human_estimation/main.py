import matplotlib.pyplot as plt
import torch
import cv2
import math
from torchvision import transforms
import numpy as np
import os
import datetime
import time
from tqdm import tqdm
from flask import Flask, render_template, request, redirect, url_for, jsonify #  Flask, request, jsonify 필수 
from utils.datasets import letterbox
from utils.general import non_max_suppression_kpt
from utils.plots import output_to_keypoint, plot_skeleton_kpts
from push_notifications import send_push_notification

app = Flask(__name__) # 추가해주기 

UPLOAD_FOLDER = '../images'  # 이미지를 저장하는 디렉토리

def fall_detection(poses):
    for pose in poses:
        xmin, ymin = (pose[2] - pose[4] / 2), (pose[3] - pose[5] / 2)
        xmax, ymax = (pose[2] + pose[4] / 2), (pose[3] + pose[5] / 2)
        left_shoulder_y = pose[23]
        left_shoulder_x = pose[22]
        right_shoulder_y = pose[26]
        left_body_y = pose[41]
        left_body_x = pose[40]
        right_body_y = pose[44]
        len_factor = math.sqrt(((left_shoulder_y - left_body_y) ** 2 + (left_shoulder_x - left_body_x) ** 2))
        left_foot_y = pose[53]
        right_foot_y = pose[56]
        dx = int(xmax) - int(xmin)
        dy = int(ymax) - int(ymin)
        difference = dy - dx
        if left_shoulder_y > left_foot_y - len_factor and left_body_y > left_foot_y - (
                len_factor / 2) and left_shoulder_y > left_body_y - (len_factor / 2) or (
                right_shoulder_y > right_foot_y - len_factor and right_body_y > right_foot_y - (
                len_factor / 2) and right_shoulder_y > right_body_y - (len_factor / 2)) \
                or difference < 0:
            return True, (xmin, ymin, xmax, ymax)
    return False, None


def generate_image(image):
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs('images')

    current_time = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    filename = f'fall_capture_{current_time}.jpg'
    
    # 이미지 파일로 저장
    save_path = os.path.join(UPLOAD_FOLDER, filename)
    cv2.imwrite(save_path, image)

# 상태1) 기본상태에서 넘어짐으로 변경될 때
def falling_alarm(image, bbox, prev_fall):
    # 해당 함수가 넘어짐이 발생했을 때 어떻게 할 것인가 나타내는 함수
        
    current_time = datetime.datetime.now().strftime('%Y%m%d%H%M%S')   
    filename = f'fall_capture_{current_time}.jpg' 
    
    x_min, y_min, x_max, y_max = bbox
    cv2.rectangle(image, (int(x_min), int(y_min)), (int(x_max), int(y_max)), color=(0, 0, 255),
                  thickness=5, lineType=cv2.LINE_AA)

    # 경고 메시지 표시: "Person Fell down" 메시지를 이미지 상단에 표시
    cv2.putText(image, 'Person Fell down', (11, 100), 0, 1, [0, 0, 255], thickness=3, lineType=cv2.LINE_AA)
    
    #저장 경로를 저장하는 것
    if not prev_fall:
        save_path = os.path.join('..\images', filename)
        cv2.imwrite(save_path, image)
        file_url = f'/upload'  # 업로드 엔드포인트 ,파일을 저장하는 대신에 /upload 엔드포인트로 이동한 URL을 반환
        return file_url

#상태2) 넘어져 있는 형상이 계속될 때
def falling_check(image, bbox):
    
    x_min, y_min, x_max, y_max = bbox
    cv2.rectangle(image, (int(x_min), int(y_min)), (int(x_max), int(y_max)), color=(0, 0, 255),
                  thickness=5, lineType=cv2.LINE_AA)

    cv2.putText(image, 'Person Fell down', (11, 100), 0, 1, [0, 0, 255], thickness=3, lineType=cv2.LINE_AA)
    
# 상태3) 움직임이 인식되지 않은 채 8시간이 경과되었을 때
def no_movement(image, img_save): 
    font = cv2.FONT_HERSHEY_SIMPLEX
    text = "There is no movement.A check is required."
    
    # 텍스트 바운더리 가져오기
    textsize = cv2.getTextSize(text, font, 1, 2)[0]

    # 텍스트 바운더리로 좌표 구하기
    textX = (image.shape[1] - textsize[0]) // 2
    textY = (image.shape[0] + textsize[1]) // 2
    
    if img_save:
        generate_image(image)  
    cv2.putText(image, text, (textX,textY), font, 1, (0, 0, 255),  thickness=4, lineType=cv2.LINE_AA)
    
    # 보류: 알람보내는거 함수 만들면 될 듯
    
    
    
def is_allowed_file(filename):
    # 허용된 파일 확장자 목록을 지정합니다.
    ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'gif'}
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})

    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    if file and is_allowed_file(file.filename):
        # 안전한 파일 이름 생성
        current_time = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
        filename = f'fall_capture_{current_time}.jpg'

        # 이미지 파일 저장
        save_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(save_path)# save_path는 저장할 경로 및 파일 이름 ,저장

        file_url = f'/get_image/{filename}'  # 이미지의 URL 생성
        return jsonify({'message': 'File uploaded successfully', 'file_url': file_url})
         # 파일 업로드가 성공하면 JSON 응답을 반환
         # 응답에는 업로드된 파일의 URL도 포함
    return jsonify({'error': 'Invalid file format'})


def get_pose_model():
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    print("device: ", device)
    weigths = torch.load('yolov7-w6-pose.pt', map_location=device)
    model = weigths['model']
    _ = model.float().eval()
    if torch.cuda.is_available():
        model = model.half().to(device)
    return model, device


def get_pose(image, model, device):
    image = letterbox(image, 960, stride=64, auto=True)[0]
    image = transforms.ToTensor()(image)
    image = torch.tensor(np.array([image.numpy()]))
    if torch.cuda.is_available():
        image = image.half().to(device)
    with torch.no_grad():
        output, _ = model(image)
    output = non_max_suppression_kpt(output, 0.25, 0.65, nc=model.yaml['nc'], nkpt=model.yaml['nkpt'],
                                     kpt_label=True)
    with torch.no_grad():
        output = output_to_keypoint(output)
    return image, output


def prepare_image(image):
    _image = image[0].permute(1, 2, 0) * 255
    _image = _image.cpu().numpy().astype(np.uint8)
    _image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
    _image = cv2.cvtColor(_image, cv2.COLOR_RGB2BGR)
    return _image

device_index = 0

def main():
    # 웹캠 캡처를 생성합니다.
    vid_cap = cv2.VideoCapture(device_index)  # 0은 기본 웹캠을 가리킵니다. 다른 카메라 사용시 device_index를 1로 사용하면 됨
    

    model, device = get_pose_model()
    
    prev_fall = False    
    
    check_time=0
    
    if not vid_cap.isOpened():
        print("디바이스를 열 수 없습니다.")
        exit()
    
    while True:  # 무한 루프를 사용하여 웹캠 스트림을 계속 처리합니다.
        success, frame = vid_cap.read()
        
        if not success:
            print('Error while reading frame. Exiting...')
            break       
        
        # 웹캠 프레임(frame)을 처리하고 필요한 작업을 수행합니다.
        image, output = get_pose(frame, model, device)
        _image = prepare_image(image)
        is_fall, bbox = fall_detection(output)    
        
        if(check_time>=28800): #8시간 60*60*8 
            if check_time%30==0: #움직임이 감지되지 않는다면 30초에 한번씩 이미지 저장
                img_save = True
            else: 
                img_save = False
            no_movement(_image, img_save)
            
            continue
           
        # 넘어지는 즉시 사진
        if is_fall is not None:  # 넘어짐 감지 결과가 있는 경우
            if is_fall != prev_fall:
                if is_fall:
                    falling_alarm(_image, bbox, prev_fall)
                prev_fall = is_fall
            else:
                if is_fall:
                    falling_check(_image, bbox)
            check_time=0
        else:            
            check_time+=1               

        # 결과를 화면에 표시합니다.
        cv2.imshow('Fall Detection!', _image)

        # 'q' 키를 누르면 루프를 종료합니다.
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # 루프를 빠져나온 후, 리소스를 정리합니다.
    vid_cap.release()
    cv2.destroyAllWindows()

@app.route('/send-notification') #http://localhost:5000/send-notification 접속시 알람 발송 
def send_notification():
    device_token = "DEVICE_TOKEN"
    title = "Detect "
    message = "timestamp , 넘어짐이 감지되었습니다 !"

    result = send_push_notification(device_token, title, message)

    return result


if __name__ == '__main__':
    # 웹캠 캡쳐
    vid_cap = cv2.VideoCapture(0) 
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)    
    main()
