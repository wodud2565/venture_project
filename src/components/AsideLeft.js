import React from 'react';

const AsideLeft = () => {
  return (
    <div className="aside-left">
      <div className="RS">
        추천시스템
        <div className="box">
          <img src={`/images/1112.png`} alt="이미지오류" />
          <div>이름</div>
        </div>
        <div className="box">
          <img src={`/images/1112.png`} alt="이미지오류" />
          <div className="text">이름123456789123456789</div>
        </div>
        <div className="box">
          <img src={`/images/1112.png`} alt="이미지오류" />
          <div>이름</div>
        </div>
        <div className="box">
          <img src={`/images/1112.png`} alt="이미지오류" />
          <div>이름</div>
        </div>
      </div>
    </div>
  );
};

export default AsideLeft;
