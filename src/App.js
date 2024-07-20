import React from 'react';
import { Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import VehicleDetail from './pages/VehicleDetail';
import LoginPage from './pages/LoginPage';
import WishlistPage from './pages/WishlistPage';
import './App.css';

const App = () => {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/vehicle/:차량번호" element={<VehicleDetail />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/wishlist" element={<WishlistPage />} />
    </Routes>
  );
};

export default App;
