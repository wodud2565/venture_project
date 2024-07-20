import React from 'react';
import Header from '../components/Header';
import Main from '../components/Main';
import AsideLeft from '../components/AsideLeft';
import AsideRight from '../components/AsideRight';
import Footer from '../components/Footer';

/* 임시로 만든 페이지 */


const WishlistPage = () => {
  return (
    <div className="container">
      <Header />
      <div className="content">
        <AsideLeft />
        <Main />
        <AsideRight />
      </div>
      <Footer />
    </div>
  );
};

export default WishlistPage;