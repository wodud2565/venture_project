// Redux Toolkit과 비동기 작업을 위한 유틸리티 import
import { createSlice, createAsyncThunk } from "@reduxjs/toolkit";
// HTTP 요청을 위한 axios import
import axios from "axios";
// Firestore 데이터베이스 작업을 위한 함수들 import
import { doc, updateDoc, arrayUnion, arrayRemove } from "firebase/firestore";
// Firebase 설정에서 가져온 Firestore 데이터베이스 인스턴스
import { db } from "../firebase";

// 비동기 액션 생성: 추천 차량 목록 가져오기
export const fetchRecommendations = createAsyncThunk("vehicles/fetchRecommendations", async ({ userVehicleIds, isRandom = false }) => {
  try {
    const baseUrl = "https://fastapi-service-855062579538.asia-northeast3.run.app";
    // 랜덤 추천인지 사용자 기반 추천인지에 따라 엔드포인트 결정
    const endpoint = isRandom ? "/random-recommend" : "/recommend";

    // 랜덤 추천일 경우 GET 요청, 사용자 기반 추천일 경우 POST 요청
    const response = isRandom ? await axios.get(`${baseUrl}${endpoint}`, { withCredentials: true }) : await axios.post(`${baseUrl}${endpoint}`, { vehicleIds: userVehicleIds }, { withCredentials: true });

    // 응답에서 추천된 차량 목록 반환
    return response.data.recommended_vehicles;
  } catch (error) {
    // 에러 발생 시 커스텀 에러 메시지 또는 서버에서 제공한 에러 메시지 throw
    throw new Error(error.response?.data?.detail || "추천을 가져오는데 실패했습니다.");
  }
});

// 비동기 액션 생성: 차량 상세 정보 가져오기
export const fetchVehicleDetails = createAsyncThunk("vehicles/fetchVehicleDetails", async (vehicleIds) => {
  try {
    // 각 차량 ID에 대해 병렬로 상세 정보 요청
    const vehiclePromises = vehicleIds.map((vehicleId) => axios.get(`https://us-central1-findingcar-12d9d.cloudfunctions.net/MyApi/api/vehicles/${vehicleId}`).then((res) => res.data));
    // 모든 요청이 완료될 때까지 기다린 후 결과 반환
    return await Promise.all(vehiclePromises);
  } catch (error) {
    throw new Error("차량 상세 정보를 가져오는데 실패했습니다.");
  }
});

// 비동기 액션 생성: 사용자 위시리스트 업데이트
export const updateUserWishlist = createAsyncThunk("vehicles/updateUserWishlist", async ({ userId, vehicleId, action }) => {
  try {
    const userRef = doc(db, "Users", userId);
    // 'add' 액션이면 배열에 추가, 'remove' 액션이면 배열에서 제거
    await updateDoc(userRef, {
      wishlist: action === "add" ? arrayUnion(vehicleId) : arrayRemove(vehicleId),
    });
    return { vehicleId, action };
  } catch (error) {
    throw new Error("위시리스트 업데이트에 실패했습니다.");
  }
});

// 비동기 액션 생성: 사용자가 조회한 차량 목록 업데이트
export const updateViewedVehicles = createAsyncThunk("vehicles/updateViewedVehicles", async ({ userId, vehicleId }) => {
  try {
    const userRef = doc(db, "Users", userId);
    // 사용자의 조회한 차량 목록에 새로운 차량 ID 추가
    await updateDoc(userRef, {
      viewedVehicles: arrayUnion(vehicleId),
    });
    return vehicleId;
  } catch (error) {
    throw new Error("조회 기록 업데이트에 실패했습니다.");
  }
});

// 차량 관련 Redux 슬라이스 생성
const vehicleSlice = createSlice({
  name: "vehicles",
  // 초기 상태 정의
  initialState: {
    recommendedVehicles: [], // 추천 차량 목록
    vehicleDetails: [], // 차량 상세 정보
    wishlist: [], // 사용자 위시리스트
    viewedVehicles: [], // 사용자가 조회한 차량 목록
    isLoading: false, // 데이터 로딩 중 여부
    error: null, // 에러 정보
    isUpdating: false, // 데이터 업데이트 중 여부
  },
  // 동기 액션에 대한 리듀서
  reducers: {
    // 위시리스트 설정
    setWishlist: (state, action) => {
      state.wishlist = action.payload;
    },
    // 조회한 차량 목록 설정
    setViewedVehicles: (state, action) => {
      state.viewedVehicles = action.payload;
    },
    // 에러 초기화
    clearError: (state) => {
      state.error = null;
    },
    // 상태 초기화
    resetState: (state) => {
      state.recommendedVehicles = [];
      state.vehicleDetails = [];
      state.wishlist = [];
      state.viewedVehicles = [];
      state.isLoading = false;
      state.error = null;
      state.isUpdating = false;
    },
  },
  // 비동기 액션에 대한 리듀서
  extraReducers: (builder) => {
    builder
      // fetchRecommendations 액션 처리
      .addCase(fetchRecommendations.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchRecommendations.fulfilled, (state, action) => {
        state.isLoading = false;
        state.recommendedVehicles = action.payload;
      })
      .addCase(fetchRecommendations.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message;
      })
      // fetchVehicleDetails 액션 처리
      .addCase(fetchVehicleDetails.pending, (state) => {
        state.isUpdating = true;
        state.error = null;
      })
      .addCase(fetchVehicleDetails.fulfilled, (state, action) => {
        state.isUpdating = false;
        state.vehicleDetails = action.payload;
      })
      .addCase(fetchVehicleDetails.rejected, (state, action) => {
        state.isUpdating = false;
        state.error = action.error.message;
      })
      // updateUserWishlist 액션 처리
      .addCase(updateUserWishlist.pending, (state) => {
        state.isUpdating = true;
        state.error = null;
      })
      .addCase(updateUserWishlist.fulfilled, (state, action) => {
        state.isUpdating = false;
        const { vehicleId, action: wishlistAction } = action.payload;
        if (wishlistAction === "add") {
          state.wishlist.push(vehicleId);
        } else {
          state.wishlist = state.wishlist.filter((id) => id !== vehicleId);
        }
      })
      .addCase(updateUserWishlist.rejected, (state, action) => {
        state.isUpdating = false;
        state.error = action.error.message;
      })
      // updateViewedVehicles 액션 처리
      .addCase(updateViewedVehicles.pending, (state) => {
        state.isUpdating = true;
        state.error = null;
      })
      .addCase(updateViewedVehicles.fulfilled, (state, action) => {
        state.isUpdating = false;
        if (!state.viewedVehicles.includes(action.payload)) {
          state.viewedVehicles.push(action.payload);
        }
      })
      .addCase(updateViewedVehicles.rejected, (state, action) => {
        state.isUpdating = false;
        state.error = action.error.message;
      });
  },
});

// 액션 생성자 내보내기
export const { setWishlist, setViewedVehicles, clearError, resetState } = vehicleSlice.actions;
// 리듀서 내보내기
export default vehicleSlice.reducer;
