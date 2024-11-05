import React from "react";
import { Routes, Route } from "react-router-dom";
import HomePage from "./pages/HomePage";
import VehicleDetailPage from "./pages/VehicleDetailPage";
import LoginPage from "./pages/LoginPage";
import SignupPage from "./pages/SignupPage";
import ForgotPasswordPage from "./pages/ForgotPasswordPage";
import WishlistPage from "./pages/WishlistPage";
import WritePostPage from "./pages/WritePostPage";
import PostListPage from "./pages/PostListPage";
import PostPage from "./pages/PostPage";
import InfoPage from "./pages/InfoPage";
import ListPage from "./pages/ListPage";
import PrivateRoute from "./PrivateRoute";
import { AuthProvider } from "./context/AuthContext";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import "./App.css";

const App = () => {
  return (
    <>
      <AuthProvider>
        <ToastContainer />
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/vehicle/:vehicleId" element={<VehicleDetailPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/forgot-password" element={<ForgotPasswordPage />} />
          <Route path="/signup" element={<SignupPage />} />
          <Route
            path="/wishlist"
            element={
              <PrivateRoute>
                <WishlistPage />
              </PrivateRoute>
            }
          />
          <Route path="/write" element={<WritePostPage />} />
          <Route path="/postlist" element={<PostListPage />} />
          <Route path="/post/:postId" element={<PostPage />} />
          <Route path="/infopage" element={<InfoPage />} />
          <Route path="/review" element={<ListPage />} />
          <Route path="/reviews/:vehicleId" element={<InfoPage />} />
        </Routes>
      </AuthProvider>
    </>
  );
};

export default App;
