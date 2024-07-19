import React from 'react';

const VehicleDetail = ({ vehicle, onBack }) => {
  const renderColors = () => {
    const colors = [];
    for (let i = 1; i <= 10; i++) {
      if (vehicle[`색상${i}`]) {
        colors.push(
          <div key={i} className="color-item">
            <div className="color-box" style={{ backgroundColor: vehicle[`색상${i}코드`] }}></div>
            <div className="color-name">{vehicle[`색상${i}`]}</div>
          </div>
        );
      }
    }
    return colors;
  };

  return (
    <div className="vehicle-detail">
      <button className="detail-button" onClick={onBack}>
        뒤로 가기
      </button>
      <div className="vehicle-image-section">
        <div className="image-container">
          <div className="top-text">
            <h2>{vehicle.브랜드 + ' ' + vehicle.이름}</h2>
          </div>
          <img src={`/innerimages/${vehicle.상세사진}.jpg`} alt={vehicle.이름} className="vehicle-image" />
          <div className="bottom-text">
            <div className="release-year">{vehicle.출시년도}년형</div>
          </div>
        </div>
      </div>
      <div className="vehicle-specs">
        <h2>차량 스펙</h2>
        <h3>차종: {vehicle.차종}</h3>
        <h3>엔진: {vehicle.엔진}</h3>
        <h3>
          연비: {vehicle.최소연비} ~ {vehicle.최대연비} km/l
        </h3>
        <h3>
          출력: {vehicle.최소출력} ~ {vehicle.최대출력} hp
        </h3>
        <h3>
          가격: {vehicle.최소가격} ~ {vehicle.최대가격} 만원
        </h3>
      </div>
      <div className="vehicle-colors">
        <h3>외장 색상</h3>
        <hr />
        <div className="colors">{renderColors()}</div>
      </div>
      <div className="vehicle-description">
        <h2>설명</h2>
        <h2>{vehicle.내용}</h2>
      </div>
    </div>
  );
};

export default VehicleDetail;
