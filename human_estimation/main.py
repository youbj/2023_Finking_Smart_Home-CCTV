import matplotlib.pyplot as plt
import torch
import cv2
import math
from torchvision import transforms
import numpy as np
import os
import datetime
import time
import requests
from tqdm import tqdm
from flask import Flask, render_template, request, redirect, url_for, jsonify #  Flask, request, jsonify 필수 
from utils.datasets import letterbox
from utils.general import non_max_suppression_kpt
from utils.plots import output_to_keypoint, plot_skeleton_kpts

app = Flask(__name__) # 추가해주기 

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


def generate_image(image, save_dir='..\images'):
    if not os.path.exists('..\images'):
        os.makedirs('images')

    current_time = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    filename = f'fall_capture_{current_time}.jpg'
    
    # 이미지 파일로 저장
    save_path = os.path.join(save_dir, filename)
    cv2.imwrite(save_path, image)
    
    

# 기본상태에서 넘어짐으로 변경될 때
def falling_alarm(image, bbox, prev_fall):
    # 해당 함수가 넘어짐이 발생했을 때 어떻게 할 것인가 나타내는 함수
    # 바운딩 박스 그리기: 빨간색 사각형으로 물체의 위치를 표시
    
    x_min, y_min, x_max, y_max = bbox
    cv2.rectangle(image, (int(x_min), int(y_min)), (int(x_max), int(y_max)), color=(0, 0, 255),
                  thickness=5, lineType=cv2.LINE_AA)

    # 경고 메시지 표시: "Person Fell down" 메시지를 이미지 하단에 표시
    cv2.putText(image, 'Person Fell down', (11, image.shape[0] - 100), 0, 1, [0, 0, 255], thickness=3, lineType=cv2.LINE_AA)

    #저장 경로를 저장하는 것
    if not prev_fall:
        # save_path = os.path.join('..\images', filename)        
        # cv2.imwrite(save_path, image)
        generate_image(image)
        


# 넘어져 있는 형상이 계속될 때
def falling_check(image, bbox):
    
    x_min, y_min, x_max, y_max = bbox
    cv2.rectangle(image, (int(x_min), int(y_min)), (int(x_max), int(y_max)), color=(0, 0, 255),
                  thickness=5, lineType=cv2.LINE_AA)

    # 경고 메시지 표시: "Person Fell down" 메시지를 이미지 하단에 표시
    cv2.putText(image, 'Person Fell down', (11, image.shape[0] - 100), 0, 1, [0, 0, 255], thickness=3, lineType=cv2.LINE_AA)



# 움직임이 인식되지 않은 채 8시간이 경과되었을 때
def no_movement(image, img_save): 
    font = cv2.FONT_HERSHEY_SIMPLEX
    text = "There is no movement.\nA check is required."
    
    # 텍스트 바운더리 가져오기
    textsize = cv2.getTextSize(text, font, 1, 2)[0]

    # 텍스트 바운더리로 좌표 구하기
    textX = (image.shape[1] - textsize[0]) // 2
    textY = (image.shape[0] + textsize[1]) // 2
    
    if img_save:
        generate_image(image)
    
    cv2.putText(image, text, (textX,textY), font, 1, (0, 0, 255),  thickness=4, lineType=cv2.LINE_AA)


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

@app.route('/upload', methods=['POST']) # api 추가 
def main():  
    # 웹캠 캡처를 생성합니다.
    vid_cap = cv2.VideoCapture(device_index)  # 다른 카메라 사용시 device_index를 1로 사용하면 됨

    # Pose 모델을 로드합니다.
    model, device = get_pose_model()
    
    prev_fall = False    
    
    check_time=0
    fall_check_time =0
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
        
        
            
        # if is_fall is not None:  # 넘어짐 감지 결과가 있는 경우
        #     if is_fall != prev_fall:
        #         if is_fall:
        #             # 넘어짐 감지된 이미지 저장
        #             check_time+=1
        #             if check_time>=3:
        #                 save_fall_capture(_image)
        #             falling_check(_image, bbox)
        #         prev_fall = is_fall
        #     else:
        #         if is_fall:
        #             falling_check(_image, bbox)
                                

        # 결과를 화면에 표시합니다.
        mirror = cv2.flip(_image,1)
        cv2.imshow('Fall Detection!', _image)

        # 'q' 키를 누르면 루프를 종료합니다.
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # 루프를 빠져나온 후, 리소스를 정리합니다.
    vid_cap.release()
    cv2.destroyAllWindows()


if __name__ == '__main__':
    # 웹캠 캡쳐
    vid_cap = cv2.VideoCapture(device_index)
    
    main()