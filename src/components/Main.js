import React, { useEffect, useState } from 'react';
import VehicleDetail from '../pages/VehicleDetail'; // 경로 수정

const categories = {
  한국: ['현대', '기아', '제네시스', '쉐보레', 'GMC', 'KG모빌리티', '르노코리아', '스마트 EV', '대창모터스', '디피코', '쎄보모빌리티', '제이스모빌리티', 'EVKMC', '마이브', '모빌리티네트웍스'],
  유럽: ['벤츠', 'BMW', '아우디', '폭스바겐', '미니', '볼보', '폴스타', '재규어', '랜드로버', '포르쉐', '페라리', '람보르기니', '마세라티', '맥라렌', '애스턴마틴', '푸조', '시트로엥', 'DS', '벤틀리', '롤스로이스'],
  일본: ['토요타', '렉서스', '혼다', '마쓰다', '닛산'],
  미국: ['포드', '링컨', '지프', '캐딜락', '테슬라'],
};

const vehicleTypes = {
  승용: ['경형', '소형', '준중형', '중형', '준대형', '대형', '스포츠카'],
  RV: ['경형 SUV', '소형 SUV', '준중형 SUV', '중형 SUV', '대형 SUV', 'RV/MPV'],
  상용: ['승합', '화물'],
};

const engineTypes = ['가솔린', '디젤', '하이브리드', '전기', 'LPG'];
const fuelEfficiencyRanges = [
  { label: '4 이하', min: 0, max: 4 },
  { label: '4 ~ 7', min: 4, max: 7 },
  { label: '7 ~ 11', min: 7, max: 11 },
  { label: '11 ~ 15', min: 11, max: 15 },
  { label: '15 이상', min: 15, max: 100 },
];
const powerRanges = [
  { label: '100 이하', min: 0, max: 100 },
  { label: '100 ~ 200', min: 100, max: 200 },
  { label: '200 ~ 300', min: 200, max: 300 },
  { label: '300 ~ 400', min: 300, max: 400 },
  { label: '400 이상', min: 400, max: 2000 },
];

const chunkArray = (array, size) => {
  const result = [];
  for (let i = 0; i < array.length; i += size) {
    result.push(array.slice(i, i + size));
  }
  return result;
};

function Main() {
  const [vehicles, setVehicles] = useState([]);
  const [selectedBrands, setSelectedBrands] = useState([]);
  const [selectedTypes, setSelectedTypes] = useState([]);
  const [selectedEngines, setSelectedEngines] = useState([]);
  const [selectedFuelEfficiencies, setSelectedFuelEfficiencies] = useState([]);
  const [selectedPowers, setSelectedPowers] = useState([]);
  const [minPrice, setMinPrice] = useState('');
  const [maxPrice, setMaxPrice] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [sortOption, setSortOption] = useState('브랜드순'); // 드롭다운 메뉴와 관련된 상태 추가
  const [selectedVehicle, setSelectedVehicle] = useState(null); // 상세보기로 선택된 차량

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

  const toggleTypeSelection = (type) => {
    setSelectedTypes((prevSelectedTypes) => (prevSelectedTypes.includes(type) ? prevSelectedTypes.filter((t) => t !== type) : [...prevSelectedTypes, type]));
  };

  const toggleEngineSelection = (engine) => {
    setSelectedEngines((prevSelectedEngines) => (prevSelectedEngines.includes(engine) ? prevSelectedEngines.filter((e) => e !== engine) : [...prevSelectedEngines, engine]));
  };

  const toggleFuelEfficiencySelection = (range) => {
    setSelectedFuelEfficiencies((prevSelectedFuelEfficiencies) => (prevSelectedFuelEfficiencies.includes(range) ? prevSelectedFuelEfficiencies.filter((r) => r !== range) : [...prevSelectedFuelEfficiencies, range]));
  };
  const togglePowerSelection = (range) => {
    setSelectedPowers((prevSelectedPowers) => (prevSelectedPowers.includes(range) ? prevSelectedPowers.filter((r) => r !== range) : [...prevSelectedPowers, range]));
  };

  const handleSearch = () => {
    let filteredVehicles = selectedBrands.length ? vehicles.filter((vehicle) => selectedBrands.includes(vehicle.브랜드)) : vehicles;
    filteredVehicles = filteredVehicles.filter((vehicle) => (!minPrice || vehicle.최대가격 >= minPrice) && (!maxPrice || vehicle.최소가격 <= maxPrice));
    filteredVehicles = selectedTypes.length ? filteredVehicles.filter((vehicle) => selectedTypes.includes(vehicle.차종)) : filteredVehicles;
    filteredVehicles = selectedEngines.length ? filteredVehicles.filter((vehicle) => selectedEngines.some((engine) => vehicle.엔진.includes(engine))) : filteredVehicles;
    filteredVehicles = selectedFuelEfficiencies.length ? filteredVehicles.filter((vehicle) => selectedFuelEfficiencies.some((range) => vehicle.최소연비 <= range.max && vehicle.최대연비 >= range.min)) : filteredVehicles;
    filteredVehicles = selectedPowers.length ? filteredVehicles.filter((vehicle) => selectedPowers.some((range) => vehicle.최소출력 <= range.max && vehicle.최대출력 >= range.min)) : filteredVehicles;
    filteredVehicles = searchTerm ? filteredVehicles.filter((vehicle) => vehicle.이름.toLowerCase().includes(searchTerm.toLowerCase())) : filteredVehicles;

    // 정렬 로직 추가
    if (sortOption === '브랜드순') {
      filteredVehicles.sort((a, b) => a.브랜드.localeCompare(b.브랜드));
    } else if (sortOption === '낮은 가격순') {
      filteredVehicles.sort((a, b) => a.최소가격 - b.최소가격);
    } else if (sortOption === '높은 가격순') {
      filteredVehicles.sort((a, b) => b.최대가격 - a.최대가격);
    } else if (sortOption === '낮은 연비순') {
      filteredVehicles.sort((a, b) => a.최소연비 - b.최소연비);
    } else if (sortOption === '높은 연비순') {
      filteredVehicles.sort((a, b) => b.최대연비 - a.최대연비);
    } else if (sortOption === '낮은 출력순') {
      filteredVehicles.sort((a, b) => a.최소출력 - b.최소출력);
    } else if (sortOption === '높은 출력순') {
      filteredVehicles.sort((a, b) => b.최대출력 - a.최대출력);
    }

    return filteredVehicles;
  };

  const filteredVehicles = handleSearch();

  const handleDetailClick = (vehicle) => {
    setSelectedVehicle(vehicle);
  };

  const handleBackToMain = () => {
    setSelectedVehicle(null);
  };

  if (selectedVehicle) {
    return <VehicleDetail vehicle={selectedVehicle} onBack={handleBackToMain} />;
  }

  return (
    <div className="Main">
      <div className="filter-section">
        <input type="text" placeholder="차량 이름을 입력하세요" value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
        <button onClick={handleSearch}>검색</button>
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
      <div className="price-filter-section">
        <input type="number" placeholder="최소가격 입력" value={minPrice} onChange={(e) => setMinPrice(e.target.value)} />
        ~
        <input type="number" placeholder="최대가격 입력" value={maxPrice} onChange={(e) => setMaxPrice(e.target.value)} />
        <button onClick={handleSearch}>검색</button>
      </div>
      <div className="type-filter-section">
        {Object.entries(vehicleTypes).map(([category, types]) => (
          <div key={category} className="type-category">
            <h3 className="type-category-name">{category}</h3>
            <div className="type-grid">
              {types.map((type) => (
                <button key={type} className={`type-button ${selectedTypes.includes(type) ? 'selected' : ''}`} onClick={() => toggleTypeSelection(type)}>
                  {type}
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>
      <div className="engine-filter-section">
        <h3>엔진</h3>
        {engineTypes.map((engine) => (
          <button key={engine} className={`engine-button ${selectedEngines.includes(engine) ? 'selected' : ''}`} onClick={() => toggleEngineSelection(engine)}>
            {engine}
          </button>
        ))}
      </div>
      <div className="fuel-efficiency-filter-section">
        <div className="fuel-efficiency-category">
          <h3 className="fuel-efficiency-category-name">연비</h3>
          <div className="fuel-efficiency-grid">
            {fuelEfficiencyRanges.map((range) => (
              <button key={range.label} className={`fuel-efficiency-button ${selectedFuelEfficiencies.includes(range) ? 'selected' : ''}`} onClick={() => toggleFuelEfficiencySelection(range)}>
                {range.label}
              </button>
            ))}
          </div>
        </div>
      </div>
      <div className="power-filter-section">
        <div className="power-category">
          <h3 className="power-category-name">출력</h3>
          <div className="power-grid">
            {powerRanges.map((range) => (
              <button key={range.label} className={`power-button ${selectedPowers.includes(range) ? 'selected' : ''}`} onClick={() => togglePowerSelection(range)}>
                {range.label}
              </button>
            ))}
          </div>
        </div>
      </div>
      <div className="dropdown-section">
        <select value={sortOption} onChange={(e) => setSortOption(e.target.value)} className="dropdown">
          <option value="브랜드순">브랜드순</option>
          <option value="낮은 가격순">낮은 가격순</option>
          <option value="높은 가격순">높은 가격순</option>
          <option value="낮은 연비순">낮은 연비순</option>
          <option value="높은 연비순">높은 연비순</option>
          <option value="낮은 출력순">낮은 출력순</option>
          <option value="높은 출력순">높은 출력순</option>
        </select>
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
                <h3> {vehicle.출시년도}년형</h3>
              </div>
              <img src={`/images/${vehicle.차량번호}.png`} alt={vehicle.이름} />
              <div className="text-card">
                <h2>{vehicle.이름}</h2>
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
                  <div className="info-label">출력:</div>
                  <div className="info-value">
                    {vehicle.최소출력} ~ {vehicle.최대출력}
                  </div>
                </div>
                <div className="info">
                  <div className="info-label">가격:</div>
                  <div className="info-value">
                    {vehicle.최소가격} ~ {vehicle.최대가격}만원
                  </div>
                </div>
                <div className="button-group">
                  <button className="detail-button" onClick={() => handleDetailClick(vehicle)}>
                    상세 보기
                  </button>
                  <button className="like-button">찜하기</button>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default Main;
