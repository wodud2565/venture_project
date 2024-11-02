import React, { useEffect, useState } from "react";
import { doc, getDoc } from "firebase/firestore";
import { db, auth } from "../firebase";
import { useAuthState } from "react-firebase-hooks/auth";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { useDispatch } from "react-redux";
import { updateUserWishlist, updateViewedVehicles } from "../redux/vehicleSlice";

const Wishlist = () => {
  const [user] = useAuthState(auth);
  const [wishlist, setWishlist] = useState([]);
  const [vehicles, setVehicles] = useState([]);
  const [userName, setUserName] = useState("");
  const navigate = useNavigate();
  const dispatch = useDispatch();

  useEffect(() => {
    const fetchWishlistAndUserName = async () => {
      if (user) {
        try {
          const userRef = doc(db, "Users", user.uid);
          const userDoc = await getDoc(userRef);

          if (userDoc.exists()) {
            const userData = userDoc.data();
            setWishlist(userData.wishlist || []);
            setUserName(`${userData.firstName || ""} ${userData.lastName || ""}`.trim());
          }
        } catch (error) {
          console.error("Error fetching user data:", error);
        }
      }
    };

    fetchWishlistAndUserName();
  }, [user]);

  useEffect(() => {
    const fetchVehicles = async () => {
      if (wishlist.length > 0) {
        try {
          const vehiclePromises = wishlist.map((vehicleId) => axios.get(`https://us-central1-findingcar-12d9d.cloudfunctions.net/MyApi/api/vehicles/${vehicleId}`).then((response) => response.data));
          const vehiclesData = await Promise.all(vehiclePromises);
          setVehicles(vehiclesData);
        } catch (error) {
          console.error("Error fetching vehicle data:", error);
        }
      } else {
        setVehicles([]); // 찜목록이 비어있으면 vehicles 상태를 빈 배열로 설정
      }
    };

    fetchVehicles();
  }, [wishlist]);

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

        // 로컬 상태 업데이트
        setWishlist((prevWishlist) => prevWishlist.filter((id) => id !== vehicleId));
        setVehicles((prevVehicles) => prevVehicles.filter((vehicle) => vehicle.차량번호 !== vehicleId));

        alert("찜목록에서 제거되었습니다.");
      } catch (error) {
        console.error("Error removing from wishlist:", error);
        alert("찜목록에서 제거하는데 실패했습니다.");
      }
    } else {
      alert("로그인이 필요합니다.");
    }
  };

  const handleDetailClick = async (vehicleId) => {
    if (user) {
      try {
        await dispatch(
          updateViewedVehicles({
            userId: user.uid,
            vehicleId,
          })
        ).unwrap();
      } catch (error) {
        console.error("Error updating viewed vehicles:", error);
      }
    }
    navigate(`/vehicle/${vehicleId}`);
  };

  return (
    <div className="wishlist">
      <h2>{userName ? `${userName}의 찜목록` : "찜목록"}</h2>
      <div className="vehicles-section">
        {vehicles.map((vehicle) => (
          <div key={vehicle.차량번호} className="vehicle-card">
            <img src={`/logoimages/${vehicle.제조국}/${vehicle.브랜드}.png`} alt={vehicle.브랜드} className="brand-logo" />
            <div className="release-date">
              <h3>{vehicle.출시년도}년형</h3>
            </div>
            <img src={`/images/${vehicle.차량번호}.png`} alt={vehicle.이름} />
            <div className="text-card">
              <h2>{vehicle.이름}</h2>
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
                <button className="detail-button" onClick={() => handleDetailClick(vehicle.차량번호)}>
                  상세 보기
                </button>
                <button className="like-button" onClick={() => handleRemoveFromWishlist(vehicle.차량번호)}>
                  찜해제
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Wishlist;
