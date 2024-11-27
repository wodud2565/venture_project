import React, { useState, useEffect } from "react";

const AsideRight = () => {
  const [time, setTime] = useState(new Date());

  useEffect(() => {
    const interval = setInterval(() => setTime(new Date()), 1000);
    return () => clearInterval(interval);
  }, []);

  const formatTime = (date) => {
    return date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", hour12: false });
  };

  return (
    <div className="aside-right">
      <div className="RS">
        <div className="chatbot-top">
          <span className="time">{formatTime(time)}</span> {/* 시간 간단히 표시 */}
          <span>
            <img className="wifi" src="/icons/wifi.png" alt="와이파이" />
          </span>
        </div>
        <img className="chatbot-icon" src={`/icons/chatbot.png`} alt="챗봇이미지" />
        <div className="cb-t1">차량 비교 챗봇</div>
        <div className="cb-t2">차량을 비교 하고 싶나요?</div>

        <button className="cb-t3">
          <span>
            <img className="chatbot-bottom" src="/icons/file.png" alt="file" />
          </span>
          <a href="https://langchain-gwvhzwbsyg5treztdqri2p.streamlit.app/" target="_blank">
            챗봇으로 이동
          </a>
          <span>
            <img className="chatbot-bottom" src="/icons/mic.png" alt="mic" />
          </span>
        </button>
      </div>
    </div>
  );
};

export default AsideRight;
