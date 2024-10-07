import React from "react";

const Footer = () => {
  // 최상단으로 스크롤하는 함수
  const scrollToTop = () => {
    window.scrollTo({
      top: 0, // 페이지 최상단으로 이동
      behavior: "smooth", // 부드럽게 스크롤 이동
    });
  };

  return (
    <div className="footer">
      <button className="footer-button" onClick={scrollToTop}>
        맨 위로 이동
      </button>
    </div>
  );
};

export default Footer;
