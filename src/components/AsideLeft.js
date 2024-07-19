import React from 'react';

const AsideLeft = () => {
  return (
    <div className="aside-left">
      <div class="RS">
        추천시스템
        <div class="box">
          <img src={`/images/1112.png`} alt={<p>이미지오류</p>} />
          <div>이름</div>
        </div>
        <div class="box">
          <img src={`/images/1112.png`} alt={<p>이미지오류</p>} />
          <div class="text">이름123456789123456789</div>
        </div>
        <div class="box">
          <img src={`/images/1112.png`} alt={<p>이미지오류</p>} />
          <div>이름</div>
        </div>
        <div class="box">
          <img src={`/images/1112.png`} alt={<p>이미지오류</p>} />
          <div>이름</div>
        </div>
      </div>
    </div>
    // 현준이 파트 = 추천 배너. 차량카드 4개정도 띄우고 배너 섹션 이쁘게 만들기!
    // 막히는 부분있으면 개인카톡!
  );
};

export default AsideLeft;
