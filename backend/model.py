import torch
import torch.nn as nn
import numpy as np
import librosa

class CNNTransformer(nn.Module):
    def __init__(self, input_size=257, num_classes=2):
        super(CNNTransformer, self).__init__()
        self.cnn = nn.Sequential(
            nn.Conv1d(input_size, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool1d(kernel_size=2),
            nn.Conv1d(128, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool1d(kernel_size=2)
        )
        self.transformer_layer = nn.TransformerEncoderLayer(d_model=32, nhead=2)
        self.transformer = nn.TransformerEncoder(self.transformer_layer, num_layers=1)
        self.fc = nn.Linear(32, num_classes)

    def forward(self, x):
        x = self.cnn(x)
        x = x.permute(2, 0, 1)
        x = self.transformer(x)
        x = x.mean(dim=0)
        x = self.fc(x)
        return x

class ScreamDetector:
    def __init__(self, model_path):
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.model = CNNTransformer(input_size=257, num_classes=2)

        # 모델 가중치 로드
        try:
            state_dict = torch.load(model_path, map_location=self.device)
            self.model.load_state_dict(state_dict)
            self.model.eval()
            print(f"Model loaded successfully from {model_path}")
        except Exception as e:
            print(f"Error loading model: {e}")
            # 임시로 랜덤 가중치 사용 (데모용)
            print("Using random weights for demo purposes")

        self.model.to(self.device)

    def preprocess_audio(self, audio_data, sample_rate=22050):
        """
        오디오 데이터를 스펙트로그램으로 변환
        """
        try:
            # STFT를 사용해 스펙트로그램 생성
            stft = librosa.stft(audio_data, hop_length=512, n_fft=512)
            magnitude = np.abs(stft)

            # 최소 길이 확보 (10 프레임)
            if magnitude.shape[1] < 10:
                padding = 10 - magnitude.shape[1]
                magnitude = np.pad(magnitude, ((0, 0), (0, padding)), mode='constant')

            return magnitude
        except Exception as e:
            print(f"Error in preprocessing: {e}")
            # 기본 크기로 더미 데이터 생성
            return np.random.random((257, 10))

    def predict(self, audio_data, sample_rate=22050):
        """
        오디오 데이터에서 비명 여부 예측
        """
        try:
            # 전처리
            spectrogram = self.preprocess_audio(audio_data, sample_rate)

            # 텐서로 변환
            input_tensor = torch.FloatTensor(spectrogram).unsqueeze(0).to(self.device)

            # 예측
            with torch.no_grad():
                output = self.model(input_tensor)
                probabilities = torch.softmax(output, dim=1)
                predicted_class = torch.argmax(probabilities, dim=1).item()
                confidence = probabilities[0][predicted_class].item()

            is_scream = predicted_class == 1
            return is_scream, confidence

        except Exception as e:
            print(f"Error in prediction: {e}")
            # 에러 발생시 안전을 위해 False 반환
            return False, 0.0