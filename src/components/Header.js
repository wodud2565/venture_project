import React, { useEffect, useState, useContext } from "react";
import { Link, useNavigate } from "react-router-dom";
import { AuthContext } from "../context/AuthContext";
import { auth } from "../firebase";

const Header = () => {
  const { user, isAuthenticated, logout } = useContext(AuthContext);
  const navigate = useNavigate();
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  useEffect(() => {
    const header = document.querySelector(".header");
    const setMarginTop = () => {
      document.body.style.marginTop = `${header.offsetHeight}px`;
    };
    setMarginTop();

    window.addEventListener("resize", setMarginTop);

    return () => {
      window.removeEventListener("resize", setMarginTop);
    };
  }, []);

  const handleLogout = async () => {
    try {
      await auth.signOut();
      logout();
      navigate("/login");
    } catch (error) {
      console.error("로그아웃 실패:", error.message);
    }
  };
  // 메뉴 토글 함수
  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  return (
    <div className="header">
      <nav>
        <div className="nav-left">
          <button onClick={toggleMenu} className="menu-button">
            {isMenuOpen ? <img src="/icons/close.png" alt="Close Menu" className="icon" /> : <img src="/icons/open.png" alt="Open Menu" className="icon" />}
          </button>
        </div>
        <div className="nav-center">
          <button className="menu-button">
            <Link to="/">
              <h1>Finding Car</h1>
            </Link>
          </button>
        </div>
        <ul className="nav-right">
          {isAuthenticated ? (
            <>
              <li>{user && <div className="name">{user.displayName || `${user.lastName}`}</div>}</li>
              <li>
                <button className="menu-button" onClick={handleLogout}>
                  <img src="/icons/logout.png" alt="Logout" className="icon" />
                </button>
              </li>
              <li>
                <button className="menu-button">
                  <Link to="/wishlist">
                    <img src="/icons/wishlist.png" alt="Wishlist" className="icon" />
                  </Link>
                </button>
              </li>
            </>
          ) : (
            <>
              <li>
                <button className="menu-button">
                  <Link to="/login">
                    <img src="/icons/login.png" alt="Login" className="icon" />
                  </Link>
                </button>
              </li>
              <li>
                <button className="menu-button">
                  <Link to="/wishlist">
                    <img src="/icons/wishlist.png" alt="Wishlist" className="icon" />
                  </Link>
                </button>
              </li>
            </>
          )}
        </ul>
      </nav>

      {/* 메뉴 리스트 - 헤더 아래에 표시됨 */}
      {isMenuOpen && (
        <div className="menu-list-container">
          <ul className="menu-list">
            <li>
              <Link to="/postlist" onClick={toggleMenu}>
                게시판
              </Link>
            </li>
            <li>
              <Link to="/review" onClick={toggleMenu}>
                이차어때
              </Link>
            </li>
          </ul>
        </div>
      )}
    </div>
  );
};

export default Header;
