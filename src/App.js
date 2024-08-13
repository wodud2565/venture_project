import React from "react";
import { Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage";
import VehicleDetailPage from "./pages/VehicleDetailPage";
import LoginPage from "./pages/LoginPage";
import WishlistPage from "./pages/WishlistPage";
import "./App.css";

const App = () => {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/vehicle/:vehicleId" element={<VehicleDetailPage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/wishlist" element={<WishlistPage />} />
    </Routes>
  );
};

export default App;
