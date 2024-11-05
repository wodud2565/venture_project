import React from "react";
import { Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage";
import VehicleDetailPage from "./pages/VehicleDetailPage";
import LoginPage from "./pages/LoginPage";
import WishlistPage from "./pages/WishlistPage";
import WritePostPage from "./pages/WritePostPage";
import PostListPage from "./pages/PostListPage";
import PostPage from "./pages/PostPage";
import InfoPage from "./pages/InfoPage";
import ListPage from "./pages/ListPage";
import "./App.css";

const App = () => {
  return (
    <Routes>
      <Route path="/" element={<HomePage />} />
      <Route path="/vehicle/:vehicleId" element={<VehicleDetailPage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/wishlist" element={<WishlistPage />} />
      <Route path="/write" element={<WritePostPage />} />
      <Route path="/postlist" element={<PostListPage />} />
      <Route path="/post/:postId" element={<PostPage />} />
      <Route path="/infopage" element={<InfoPage />} />
      <Route path="/list" element={<ListPage />} />
      <Route path="/reviews/:vehicleId" element={<InfoPage />} />
    </Routes>
  );
};

export default App;
