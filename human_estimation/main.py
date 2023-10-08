import matplotlib.pyplot as plt
import torch
import cv2
import math
from torchvision import transforms
import numpy as np
import os
import time

from tqdm import tqdm

from utils.datasets import letterbox
from utils.general import non_max_suppression_kpt
from utils.plots import output_to_keypoint, plot_skeleton_kpts


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


# def save_fall_capture(image, save_dir='..\images'):
#     # 저장할 디렉토리를 지정
#     if not os.path.exists(save_dir):
#         os.makedirs(save_dir)

#     # 현재 시간을 기반으로 파일 이름 생성 (타임스탬프 사용)
#     timestamp = int(time.time())  # 현재 시간을 초 단위로 얻음
#     filename = f'fall_capture_{timestamp}.jpg'
    
#     # 이미지를 지정된 디렉토리에 저장
#     save_path = os.path.join(save_dir, filename)
#     cv2.imwrite(save_path, image)

def falling_alarm(image, bbox):
    # 해당 함수가 넘어짐이 발생했을 때 어떻게 할 것인가 나타내는 함수
    # 바운딩 박스 그리기: 빨간색 사각형으로 물체의 위치를 표시
    
    #아래 두 명령어는 이미지를 저장하는 것
    timestamp = int(time.time())  # 현재 시간을 초 단위로 얻음
    filename = f'fall_capture_{timestamp}.jpg'
    
    x_min, y_min, x_max, y_max = bbox
    cv2.rectangle(image, (int(x_min), int(y_min)), (int(x_max), int(y_max)), color=(0, 0, 255),
                  thickness=5, lineType=cv2.LINE_AA)

    # 경고 메시지 표시: "Person Fell down" 메시지를 이미지 상단에 표시
    cv2.putText(image, 'Person Fell down', (11, 100), 0, 1, [0, 0, 255], thickness=3, lineType=cv2.LINE_AA)
    
    #저장 경로를 저장하는 것
    save_path = os.path.join('..\images', filename)
    cv2.imwrite(save_path, image)
# 사진 경로 상위 dir인 images에 저장되는데 시간을 줘서 저장할지 아니면 fall detection에서 false에서 true로 넘어갈 때 변경할지 정해야 할 듯

    

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
    return _image


def main():
    # 웹캠 캡처를 생성합니다.
    vid_cap = cv2.VideoCapture(0)  # 0은 기본 웹캠을 가리킵니다. 다른 카메라를 사용하려면 적절한 인덱스를 사용하세요.

    # Pose 모델을 로드합니다.
    model, device = get_pose_model()
    
    prev_fall = False
    
    while True:  # 무한 루프를 사용하여 웹캠 스트림을 계속 처리합니다.
        success, frame = vid_cap.read()
        if not success:
            print('Error while reading frame. Exiting...')
            break
        
        
        # 웹캠 프레임(frame)을 처리하고 필요한 작업을 수행합니다.
        image, output = get_pose(frame, model, device)
        _image = prepare_image(image)
        is_fall, bbox = fall_detection(output)
        
        if is_fall:  # 넘어짐이 발생했을 때                
                falling_alarm(_image, bbox)           

        # 결과를 화면에 표시합니다.
        cv2.imshow('Fall Detection!', _image)

        # 'q' 키를 누르면 루프를 종료합니다.
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # 루프를 빠져나온 후, 리소스를 정리합니다.
    vid_cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    # 웹캠 캡쳐
    vid_cap = cv2.VideoCapture(0)
    
    main()
