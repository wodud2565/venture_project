# 표준 라이브러리 임포트
import os  # 운영 체제와 상호 작용하기 위한 모듈 (환경 변수 접근 등)
import logging  # 로깅 기능을 제공하는 모듈

# FastAPI 관련 임포트
from fastapi import FastAPI, HTTPException  # FastAPI 웹 프레임워크와 HTTP 예외 처리
from fastapi.middleware.cors import CORSMiddleware  # CORS(Cross-Origin Resource Sharing) 미들웨어

# Pydantic 임포트 (데이터 검증 및 설정 관리)
from pydantic import BaseModel  # API 요청/응답 모델 정의를 위한 기본 모델 클래스

# 타입 힌팅을 위한 임포트
from typing import List  # 타입 힌팅에서 리스트 타입을 사용하기 위한 임포트

# SQLAlchemy ORM 관련 임포트
from sqlalchemy import create_engine  # 데이터베이스 엔진 생성
from sqlalchemy.orm import sessionmaker  # 데이터베이스 세션 생성
from sqlalchemy.ext.declarative import declarative_base  # ORM 모델의 기본 클래스
from sqlalchemy import Column, Integer, String, Float  # 데이터베이스 테이블 컬럼 타입

# 데이터 처리 및 분석 라이브러리
import pandas as pd  # 데이터 조작 및 분석을 위한 pandas 라이브러리

# 머신러닝 관련 라이브러리
from sklearn.metrics.pairwise import cosine_similarity  # 코사인 유사도 계산을 위한 함수


# FastAPI 인스턴스 생성
app = FastAPI()

# CORS 미들웨어 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://findingcar-12d9d.web.app"],  # 여기에 클라이언트 도메인을 추가
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# PostgreSQL 데이터베이스 설정
# 환경 변수에서 데이터베이스 접속 정보를 가져옴
DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_NAME = os.environ.get("DB_NAME")
DB_HOST = os.environ.get("DB_HOST")  # GCP의 PostgreSQL 주소로 변경 필요 시 교체
# SQLAlchemy 엔진 생성
engine = create_engine(f"postgresql+pg8000://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}")
# 세션 팩토리 생성
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# SQLAlchemy 모델의 기본 클래스 정의
Base = declarative_base()

# 차량 데이터베이스 모델 정의
# 이 클래스는 데이터베이스의 'vehicle' 테이블과 매핑됨
class Vehicle(Base):
    __tablename__ = 'vehicle'
    차량번호 = Column(Integer, primary_key=True)
    이름 = Column(String)
    최소가격 = Column(Float)
    최대가격 = Column(Float)
    최소연비 = Column(Float)
    최대연비 = Column(Float)
    최소출력 = Column(Float)
    최대출력 = Column(Float)

# Pydantic 모델 정의 (React에서 보내는 추천 컬렉션을 받기 위한 모델)
class RecommendationRequest(BaseModel):
    vehicleIds: List[int]  # React에서 추천 컬렉션 배열을 전달받음

# 데이터베이스에서 차량 정보 로드
def load_vehicle_data():
    try:
        session = SessionLocal()
        vehicles = session.query(Vehicle).all()
        session.close()
        df = pd.DataFrame([{c.name: getattr(v, c.name) for c in v.__table__.columns} for v in vehicles])
        return df
    except Exception as e:
        logging.error(f"차량 데이터를 로드하는 중 오류: {e}")
        return pd.DataFrame()

# 랜덤 추천 생성 함수
# 추천할 차량이 충분하지 않을 때 사용
def get_random_recommendations(vehicle_data, num_recommendations=3):
    if len(vehicle_data) < num_recommendations:
        num_recommendations = len(vehicle_data)
    return vehicle_data.sample(n=num_recommendations)['차량번호'].tolist()

# 추천 시스템 알고리즘 (코사인 유사도 기반)
def generate_recommendations(user_vehicle_ids, vehicle_data):
    if not user_vehicle_ids:
        return get_random_recommendations(vehicle_data)
    # 사용자가 본 차량의 데이터 추출
    user_vehicles = vehicle_data[vehicle_data['차량번호'].isin(user_vehicle_ids)]
    if user_vehicles.empty:
        return get_random_recommendations(vehicle_data)
        
    # 차량 데이터를 기준으로 특징 벡터 생성
    vehicle_vectors = vehicle_data[['최소가격', '최대가격', '최소연비', '최대연비', '최소출력', '최대출력']].values
    user_vectors = user_vehicles[['최소가격', '최대가격', '최소연비', '최대연비', '최소출력', '최대출력']].values
    
    # 사용자가 본 차량과 모든 차량 간의 코사인 유사도 계산
    similarity = cosine_similarity(user_vectors, vehicle_vectors)
    # 유사도의 평균값으로 각 차량에 대한 평균 유사도 계산
    similarity_scores = similarity.mean(axis=0)

    # 상위 3개의 추천 차량 번호 반환
    top_indices = similarity_scores.argsort()[-3:][::-1]
    return vehicle_data.iloc[top_indices]['차량번호'].tolist()

# 추천 API 엔드포인트
@app.post("/recommend")
async def recommend(request: RecommendationRequest):
    try:
        vehicle_data = load_vehicle_data()  # 데이터베이스에서 차량 데이터 로드
        if vehicle_data.empty:
            raise HTTPException(status_code=500, detail="차량 데이터를 로드할 수 없습니다.")
        
        # 전달된 차량 번호 배열을 기반으로 추천
        recommended_vehicle_ids = generate_recommendations(request.vehicleIds, vehicle_data)
        return {"recommended_vehicles": recommended_vehicle_ids}
    except Exception as e:
        logging.error(f"추천 생성 중 오류: {e}")
        raise HTTPException(status_code=500, detail="추천 생성 중 오류 발생")

# 랜덤 추천 API 엔드포인트 (추천 목록이 없을 때 사용)
@app.get("/random-recommend")
async def random_recommend():
    try:
        vehicle_data = load_vehicle_data()  # 데이터베이스에서 차량 데이터 로드
        if vehicle_data.empty:
            raise HTTPException(status_code=500, detail="차량 데이터를 로드할 수 없습니다.")
        
        random_recommendations = get_random_recommendations(vehicle_data)  # 랜덤 추천 생성
        return {"recommended_vehicles": random_recommendations}
    except Exception as e:
        logging.error(f"랜덤 추천 생성 중 오류: {e}")
        raise HTTPException(status_code=500, detail="랜덤 추천 생성 중 오류 발생")

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)