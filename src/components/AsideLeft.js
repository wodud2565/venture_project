import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuthState } from "react-firebase-hooks/auth";
import { useDispatch, useSelector } from "react-redux";
import { auth, db } from "../firebase";
import { doc, getDoc } from "firebase/firestore";
import { fetchRecommendations, fetchVehicleDetails, updateUserWishlist, updateViewedVehicles, setWishlist, setViewedVehicles } from "../redux/vehicleSlice";

const AsideLeft = () => {
  // Firebase 인증 상태 관리
  const [user] = useAuthState(auth); // 현재 로그인된 사용자 정보를 가져옵니다.
  const [userName, setUserName] = useState(""); // 사용자의 이름을 저장합니다.
  const navigate = useNavigate();
  const dispatch = useDispatch();

  // 로컬 상태 관리
  const [localWishlist, setLocalWishlist] = useState([]);
  const [displayedVehicles, setDisplayedVehicles] = useState([]);

  // Redux 상태 가져오기
  const { vehicleDetails: vehicles, wishlist, viewedVehicles, isLoading: isInitialLoading, isUpdating, error, recommendedVehicles: rawRecommendations } = useSelector((state) => state.vehicles);

  // 사용자 데이터 가져오기
  useEffect(() => {
    const fetchUserData = async () => {
      if (!user) return;

      try {
        const userRef = doc(db, "Users", user.uid);
        const userDoc = await getDoc(userRef);
        if (!userDoc.exists()) return;
        const userData = userDoc.data();
        const firstName = userData.firstName || "이름없음";
        const lastName = userData.lastName || "";
        setUserName(`${firstName}${lastName}`.trim());
        dispatch(setWishlist(userData.wishlist || []));
        dispatch(setViewedVehicles(userData.viewedVehicles || []));
      } catch (error) {
        console.error("Firebase에서 사용자 데이터를 가져오는 중 오류 발생:", error);
      }
    };

    fetchUserData();
  }, [user, dispatch]);

  // 위시리스트 상태 동기화
  useEffect(() => {
    setLocalWishlist(wishlist);
  }, [wishlist]);

  // 추천 데이터 가져오기
  useEffect(() => {
    const fetchData = async () => {
      try {
        if (user) {
          const allVehicles = [...new Set([...wishlist, ...viewedVehicles])];
          await dispatch(
            fetchRecommendations({
              userVehicleIds: allVehicles,
              isRandom: false,
            })
          ).unwrap();
        } else {
          await dispatch(
            fetchRecommendations({
              isRandom: true,
            })
          ).unwrap();
        }
      } catch (error) {
        console.error("데이터를 가져오는 중 오류 발생:", error);
      }
    };

    fetchData();
  }, [dispatch, user, wishlist, viewedVehicles]);

  // 추천 차량 상세 정보 가져오기
  useEffect(() => {
    const updateDisplayedVehicles = async () => {
      if (rawRecommendations.length > 0) {
        const fetchedVehicles = await dispatch(fetchVehicleDetails(rawRecommendations)).unwrap();
        setDisplayedVehicles(fetchedVehicles);
      }
    };

    updateDisplayedVehicles();
  }, [dispatch, rawRecommendations]);

  // 차량 상세 페이지로 이동 및 조회 기록 업데이트
  const handleDetailClick = async (vehicle) => {
    navigate(`/vehicle/${vehicle.차량번호}`);
    if (user) {
      try {
        await dispatch(
          updateViewedVehicles({
            userId: user.uid,
            vehicleId: vehicle.차량번호,
          })
        ).unwrap();

        const allVehicles = [...new Set([...localWishlist, ...viewedVehicles, vehicle.차량번호])];
        await dispatch(
          fetchRecommendations({
            userVehicleIds: allVehicles,
            isRandom: false,
          })
        ).unwrap();
      } catch (error) {
        console.error("조회 기록 업데이트 중 오류 발생:", error);
      }
    }
  };

  // 위시리스트에 차량 추가
  const handleAddToWishlist = async (vehicleId) => {
    if (!user) {
      alert("로그인이 필요한 기능입니다.");
      return;
    }
    try {
      await dispatch(
        updateUserWishlist({
          userId: user.uid,
          vehicleId,
          action: "add",
        })
      ).unwrap();

      const updatedWishlist = [...localWishlist, vehicleId];
      setLocalWishlist(updatedWishlist);

      const allVehicles = [...new Set([...updatedWishlist, ...viewedVehicles])];
      const newRecommendations = await dispatch(
        fetchRecommendations({
          userVehicleIds: allVehicles,
          isRandom: false,
        })
      ).unwrap();

      const newVehicles = await dispatch(fetchVehicleDetails(newRecommendations)).unwrap();
      setDisplayedVehicles(newVehicles);
    } catch (error) {
      console.error("위시리스트 추가 중 오류 발생:", error);
    }
  };

  // 위시리스트에서 차량 제거
  const handleRemoveFromWishlist = async (vehicleId) => {
    try {
      await dispatch(
        updateUserWishlist({
          userId: user.uid,
          vehicleId,
          action: "remove",
        })
      ).unwrap();

      const updatedWishlist = localWishlist.filter((id) => id !== vehicleId);
      setLocalWishlist(updatedWishlist);

      const allVehicles = [...new Set([...updatedWishlist, ...viewedVehicles])];
      const newRecommendations = await dispatch(
        fetchRecommendations({
          userVehicleIds: allVehicles,
          isRandom: false,
        })
      ).unwrap();

      const newVehicles = await dispatch(fetchVehicleDetails(newRecommendations)).unwrap();
      setDisplayedVehicles(newVehicles);
    } catch (error) {
      console.error("위시리스트 제거 중 오류 발생:", error);
    }
  };

  // 컴포넌트 렌더링
  return (
    <div className="aside-left">
      <div className="LS">
        <h2 className="title">
          {user ? (
            <>
              {userName || "사용자"} 님의
              <br />
              맞춤 추천 차량
            </>
          ) : (
            "랜덤 추천 시스템"
          )}
        </h2>{" "}
        {isInitialLoading ? (
          <p>초기 데이터를 불러오는 중...</p>
        ) : error ? (
          <p className="error">{error}</p>
        ) : (
          <>
            {isUpdating && <p>추천 목록을 업데이트하는 중...</p>}
            {displayedVehicles.map((vehicle) => (
              <div key={vehicle.차량번호} className="box">
                <img src={`/images/${vehicle.차량번호}.png`} alt={vehicle.이름} />
                <div>{vehicle.이름}</div>
                <div className="button-group">
                  <button className="detail-button" onClick={() => handleDetailClick(vehicle)}>
                    상세 보기
                  </button>
                  {user &&
                    (localWishlist.includes(vehicle.차량번호) ? (
                      <button className="like-button" onClick={() => handleRemoveFromWishlist(vehicle.차량번호)}>
                        찜해제
                      </button>
                    ) : (
                      <button className="like-button" onClick={() => handleAddToWishlist(vehicle.차량번호)}>
                        찜하기
                      </button>
                    ))}
                </div>
              </div>
            ))}
          </>
        )}
      </div>
    </div>
  );
};

export default AsideLeft;
