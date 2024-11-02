import React, { useState, useEffect } from "react";
import { useAuthState } from "react-firebase-hooks/auth";
import { useDispatch, useSelector } from "react-redux";
import { auth } from "../firebase";
import { updateUserWishlist } from "../redux/vehicleSlice";

const VehicleDetail = ({ vehicle }) => {
  const [user] = useAuthState(auth);
  const dispatch = useDispatch();

  // Redux에서 위시리스트 상태를 가져옵니다
  const globalWishlist = useSelector((state) => state.vehicles.wishlist);

  // 로컬 위시리스트 상태를 관리합니다
  const [localWishlist, setLocalWishlist] = useState(globalWishlist);

  // globalWishlist가 변경될 때 localWishlist를 업데이트합니다
  useEffect(() => {
    setLocalWishlist(globalWishlist);
  }, [globalWishlist]);

  // 차량을 찜 목록에 추가하는 함수입니다.
  const handleAddToWishlist = async (vehicleId) => {
    if (user) {
      try {
        await dispatch(
          updateUserWishlist({
            userId: user.uid,
            vehicleId,
            action: "add",
          })
        ).unwrap();
        // 로컬 상태 즉시 업데이트
        setLocalWishlist((prev) => [...prev, vehicleId]);
        alert("찜목록에 추가되었습니다.");
      } catch (error) {
        console.error("Error adding to wishlist:", error);
        alert("찜하기에 실패했습니다.");
      }
    } else {
      alert("로그인이 필요합니다.");
    }
  };

  // 차량을 찜 목록에서 제거하는 함수입니다.
  const handleRemoveFromWishlist = async (vehicleId) => {
    if (user) {
      try {
        await dispatch(
          updateUserWishlist({
            userId: user.uid,
            vehicleId,
            action: "remove",
          })
        ).unwrap();
        // 로컬 상태 즉시 업데이트
        setLocalWishlist((prev) => prev.filter((id) => id !== vehicleId));
        alert("찜목록에서 제거되었습니다.");
      } catch (error) {
        console.error("Error removing from wishlist:", error);
        alert("찜해제에 실패했습니다.");
      }
    } else {
      alert("로그인이 필요합니다.");
    }
  };

  // 차량의 외장 색상을 렌더링하는 함수입니다.
  const renderColors = () => {
    return Array.from({ length: 10 }, (_, i) => i + 1).map((i) => {
      const colorName = vehicle[`색상${i}`];
      const colorCode = vehicle[`색상${i}코드`];
      return colorName ? (
        <div key={i} className="color-item">
          <div className="color-box" style={{ backgroundColor: colorCode }}></div>
          <div className="color-name">{colorName}</div>
        </div>
      ) : null;
    });
  };

  return (
    <div className="vehicle-detail">
      <div className="vehicle-image-section">
        <div className="image-container">
          <div className="top-text">
            <h2>{`${vehicle.브랜드} ${vehicle.이름}`}</h2>
          </div>
          <img src={`/innerimages/${vehicle.상세사진}.jpg`} alt={vehicle.이름} className="vehicle-image" />
          <div className="middle-text">
            <div className="release-year">{`${vehicle.출시년도}년형`}</div>
          </div>
          <div className="bottom-text">
            {localWishlist.includes(vehicle.차량번호) ? (
              <button className="like-button" onClick={() => handleRemoveFromWishlist(vehicle.차량번호)}>
                찜해제
              </button>
            ) : (
              <button className="like-button" onClick={() => handleAddToWishlist(vehicle.차량번호)}>
                찜하기
              </button>
            )}
          </div>
        </div>
      </div>
      <div className="vehicle-specs">
        <h2>차량 스펙</h2>
        <h3>차종: {vehicle.차종}</h3>
        <h3>엔진: {vehicle.엔진}</h3>
        <h3>연비: {`${vehicle.최소연비} ~ ${vehicle.최대연비} km/l`}</h3>
        <h3>출력: {`${vehicle.최소출력} ~ ${vehicle.최대출력} hp`}</h3>
        <h3>가격: {`${vehicle.최소가격} ~ ${vehicle.최대가격} 만원`}</h3>
      </div>
      <div className="vehicle-colors">
        <h3>외장 색상</h3>
        <hr />
        <div className="colors">{renderColors()}</div>
      </div>
      <div className="vehicle-description">
        <h2>설명</h2>
        <h3>{vehicle.내용}</h3>
      </div>
    </div>
  );
};

export default VehicleDetail;
