import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import axios from "axios"; // axios 임포트
import Header from "../components/Header";
import VehicleDetail from "../components/VehicleDetail";
import AsideLeft from "../components/AsideLeft";
import AsideRight from "../components/AsideRight";
import Footer from "../components/Footer";

const VehicleDetailPage = () => {
  const { vehicleId } = useParams();
  const [vehicle, setVehicle] = useState(null);

  useEffect(() => {
    const fetchVehicle = async () => {
      try {
        // axios를 사용하여 GET 요청
        const response = await axios.get(`http://localhost:3001/api/vehicles/${vehicleId}`);
        setVehicle(response.data); // 응답 데이터 설정
      } catch (error) {
        console.error("Error fetching vehicle data:", error);
      }
    };

    fetchVehicle();
  }, [vehicleId]);

  return (
    <div className="container">
      <Header />
      <div className="content">
        <AsideLeft />
        <div>{vehicle ? <VehicleDetail vehicle={vehicle} /> : <p>Loading...</p>}</div>
        <AsideRight />
      </div>
      <Footer />
    </div>
  );
};

export default VehicleDetailPage;
