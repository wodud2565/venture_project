import React, { useEffect, useState } from 'react';

const categories = {
  한국: ['현대', '기아', '제네시스', '쉐보레', 'GMC', 'KG모빌리티', '르노코리아', '스마트 EV', '대창모터스', '디피코', '쎄보모빌리티', '제이스모빌리티', 'EVKMC', '마이브', '모빌리티네트웍스'],
  유럽: ['벤츠', 'BMW', '아우디', '폭스바겐', '미니', '볼보', '폴스타', '재규어', '랜드로버', '포르쉐', '페라리', '람보르기니', '마세라티', '맥라렌', '애스턴마틴', '푸조', '시트로엥', 'DS', '벤틀리', '롤스로이스'],
  일본: ['토요타', '렉서스', '혼다', '마쓰다', '닛산'],
  미국: ['포드', '링컨', '지프', '캐딜락', '테슬라'],
};

const chunkArray = (array, size) => {
  const result = [];
  for (let i = 0; i < array.length; i += size) {
    result.push(array.slice(i, i + size));
  }
  return result;
};

const Main = () => {
  const [vehicles, setVehicles] = useState([]);
  const [selectedBrands, setSelectedBrands] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch('http://localhost:3001/api/vehicles')
      .then((response) => response.json())
      .then((data) => {
        setVehicles(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error('Error fetching data:', error);
        setError(error);
        setLoading(false);
      });
  }, []);

  const toggleBrandSelection = (brand) => {
    setSelectedBrands((prevSelectedBrands) => (prevSelectedBrands.includes(brand) ? prevSelectedBrands.filter((b) => b !== brand) : [...prevSelectedBrands, brand]));
  };

  const filteredVehicles = selectedBrands.length ? vehicles.filter((vehicle) => selectedBrands.includes(vehicle.브랜드)) : vehicles;

  return (
    <div className="main">
      <div className="filter-section">
        <input type="text" placeholder="브랜드를 입력하세요" value={selectedBrands.join(', ')} readOnly />
      </div>
      <div className="categories-section">
        <div style={{ display: 'flex' }}>
          {Object.entries(categories).map(([region, brands]) => (
            <div key={region} className="category">
              <h3 className="country-name">{region}</h3>
              <div className="country-divider"></div>
              <div className="brand-grid">
                {chunkArray(brands, 5).map((brandChunk, chunkIndex) => (
                  <div key={chunkIndex} className="brand-column">
                    {brandChunk.map((brand) => (
                      <div key={brand} className={`brand-card ${selectedBrands.includes(brand) ? 'selected' : ''}`} onClick={() => toggleBrandSelection(brand)}>
                        <img src={`/logoimages/${region}/${brand}.png`} alt={brand} title={brand} className="brand-logo" />
                        <div className="brand-name">{brand}</div>
                        {selectedBrands.includes(brand) && <div className="selected-overlay"></div>}
                      </div>
                    ))}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
      <div className="vehicles-section">
        {loading ? (
          <p>Loading...</p>
        ) : error ? (
          <p>Error: {error.message}</p>
        ) : (
          filteredVehicles.map((vehicle) => (
            <div key={vehicle.차량번호} className="vehicle-card">
              <img src={`/logoimages/${vehicle.제조국}/${vehicle.브랜드}.png`} alt={vehicle.브랜드} className="brand-logo" />
              <div className="release-date">
                <h3>출시년도: {vehicle.출시년도}</h3>
              </div>
              <img src={`/images/${vehicle.차량번호}.png`} alt={vehicle.이름} />
              <div className="text-card">
                <h2>{vehicle.이름}</h2>
                <div className="info">
                  <div className="info-label">제조국:</div>
                  <div className="info-value">{vehicle.제조국}</div>
                </div>
                <div className="info">
                  <div className="info-label">브랜드:</div>
                  <div className="info-value">{vehicle.브랜드}</div>
                </div>
                <div className="info">
                  <div className="info-label">차종:</div>
                  <div className="info-value">{vehicle.차종}</div>
                </div>
                <div className="info">
                  <div className="info-label">엔진:</div>
                  <div className="info-value">{vehicle.엔진}</div>
                </div>
                <div className="info">
                  <div className="info-label">연비:</div>
                  <div className="info-value">
                    {vehicle.최소연비} ~ {vehicle.최대연비}
                  </div>
                </div>
                <div className="info">
                  <div className="info-label">가격:</div>
                  <div className="info-value">
                    {vehicle.최소가격} ~ {vehicle.최대가격}만원
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default Main;
