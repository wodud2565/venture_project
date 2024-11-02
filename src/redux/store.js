import { configureStore } from "@reduxjs/toolkit";
import vehicleReducer from "./vehicleSlice";

export const store = configureStore({
  reducer: {
    vehicles: vehicleReducer,
    // 추가적인 리듀서들을 여기에 추가할 수 있습니다
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: false, // Firebase 객체 사용을 위해 직렬화 체크를 비활성화
    }),
  devTools: process.env.NODE_ENV !== "production", // 개발 환경에서만 Redux DevTools 활성화
});
