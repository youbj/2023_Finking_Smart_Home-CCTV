import cv2
import mediapipe as mp
import numpy as np
import glob
from sklearn.neighbors import KNeighborsClassifier

mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh()

'''특징 추출 함수 knn에서 사용할 좌표값을 얻기 위해 얼굴의 특징점을 추출하는 함수이다'''
def extract_face_features(image):
    
    _image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)# 여기서 _image를 전처리하여 사용할 수 있다. 전처리는 knn에서 분류할 때 더 사이즈나 선명도 등을 말한다.
    # Mediapipe를 사용하여 얼굴 인식 수행
    results = face_mesh.process(_image)
    
    landmarks = []
    if results.multi_face_landmarks: # 특징값을 추출하기 위한 방법으로 mediapipe를 사용해 눈코입 좌표와 같은 값을 배열로 입력한다.
        for face_landmarks in results.multi_face_landmarks:
            single_landmarks = []
            for landmark in face_landmarks.landmark:
                single_landmarks.append((landmark.x, landmark.y, landmark.z))
            landmarks.append(single_landmarks)
    else:
        return None
    return landmarks


def prepare_dataset():
    dataset = []
    labels = []

    # 학습에 사용할 사진 경로 및 클래스 레이블 지정
    image_paths = glob.glob('C:/Users/YooByeongJu/Desktop/2023_Finking_Smart_Home-CCTV/images/*.jpg') # 사진 경로 입력하면 됨 
    class_labels = []

    for x in range(len(image_paths)): # 이건 나 혼자라서 하나의 이름만 계속 입력했지만 사용할 때는 각자 사진이 들어간 만큼 이름을 입력해줘야함
        class_labels.append('yoobyeongju') # 예시로 유병주 10장 이연규 5장 박재원 6장 순서에 맞춰 유병주 10번 이연규 5번 박재원 6번 입력

    for image_path, class_label in zip(image_paths, class_labels):
        image = cv2.imread(image_path)
        landmarks = extract_face_features(image)

        if landmarks is not None: # 이건 사진에서 특징을 찾지 못했을 때 그냥 초기화 값 넣는 거라고 생각하면 됨 
            dataset.extend(landmarks) # 실제로 난 사진이 셀카만 많아서 가까이서 같은 포즈나 구도는 잘 인식했지만 사진과 다른게 많으면 인식에 어려움이 있었음
            labels.extend([class_label] * len(landmarks))

    dataset = np.array(dataset)
    labels = np.array(labels) # 데이터셋을 2D로 변환하는 것
    
    return dataset, labels



def calculate_face_region(landmarks): # 이건 얼굴의 좌표 구하는 거라고 생각하면 됨
    frame_width = cap.get(cv2.CAP_PROP_FRAME_WIDTH) # YOLO에서 얼굴을 box형태로 detection되는 거랑 같은 원리
    frame_height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    x_coords = [landmark[0] for landmark in landmarks]
    y_coords = [landmark[1] for landmark in landmarks]
    x1 = int(min(x_coords) * frame_width)
    y1 = int(min(y_coords) * frame_height)
    x2 = int(max(x_coords) * frame_width)
    y2 = int(max(y_coords) * frame_height)

    return x1, y1, x2, y2



'''여기서 부터 진짜 시작'''
dataset, labels = prepare_dataset() # 데이터셋과 라벨 불러오고
print('라벨화 완료')
dataset = dataset.reshape(dataset.shape[0], -1)
knn = KNeighborsClassifier(n_neighbors=3)
print('분류 완료')
knn.fit(dataset, labels)
print('knn 완료')
cap = cv2.VideoCapture(0) # 라이브로 영상 나온다길래 웹캠에서 하는 형식으로 가져옴 동영상부분으로 필요하면 화요일 이후에 수정 가능

while cap.isOpened():
    ret, frame = cap.read()

    if not ret: # 웹캠이 연동 안되었을 경우
        print('웹캠 연동 불가')
        continue

    flipped_frame = cv2.flip(frame, 1) # 좌우반전 적용한 거로 딱히 필요한 건 아님
    landmarks = extract_face_features(frame) 

    # 좌우반전을 원하지 않으면 아래의 모든flipped_frame을 frame으로 변경해주면 됩니다.
    if landmarks is None:
        cv2.putText(flipped_frame, '얼굴을 감지할 수 없습니다.', (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        cv2.imshow('Face Recognition', flipped_frame) 
    else:
        num_faces = len(landmarks)
        predictions = []

        for i in range(num_faces):
            # 예측 수행
            face_landmarks = landmarks[i]
            face_landmarks = np.reshape(face_landmarks, (1, -1))
            distances, indices = knn.kneighbors(face_landmarks)
            closest_label = labels[indices[0][0]]
            
            threshold = 1 # 임계값으로 데이터에서 얻은 특징과 웹캠에서 실시간으로 얻은 특징이 얼마나 다른가를 나타냄
                            # 1에 가까울수록 기준이 엄격해지고 0에 가까울수록 관대해 Unknown이 될 확률이 높다 조절 가능
            
            if distances[0][0] > threshold:
                closest_label = "Unknown"
            predictions.append(closest_label)

        for i in range(num_faces):
            x1, y1, x2, y2 = calculate_face_region(landmarks[i])
            label = predictions[i]
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.putText(flipped_frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

        cv2.imshow('Face Recognition', flipped_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()

