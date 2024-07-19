import React from 'react';
import { Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import VehicleDetail from './pages/VehicleDetail';
import './App.css';

const App = () => {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/vehicle/:차량번호" element={<VehicleDetail />} />
    </Routes>
  );
};

export default App;
