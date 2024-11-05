import React from "react";
import { Link } from "react-router-dom"; // 차량 클릭 시 링크로 상세 페이지로 이동

const ReviewList = ({ reviews = [] }) => {
  // reviews가 없을 경우 빈 배열로 기본값 설정
  if (!Array.isArray(reviews)) {
    return <div>데이터를 불러오는 중 오류가 발생했습니다.</div>; // reviews가 배열이 아닌 경우
  }

  if (!reviews.length) {
    return <div>Loading reviews...</div>; // 배열이 비어 있을 때 로딩 메시지
  }

  const renderStars = (rating) => {
    const fullStars = Math.floor(rating); // 평점에서 fullstar 개수
    const halfStars = rating % 1 >= 0.5 ? 1 : 0; // 평점에서 halfstar 개수 (소수점 버림 처리)
    const emptyStars = 5 - fullStars - halfStars; // 남은 별은 emptystar로 처리

    const stars = [];

    // fullstar 추가
    for (let i = 0; i < fullStars; i++) {
      stars.push(<img key={`full-${i}`} src="/icons/fullstar.png" alt="Full Star" />);
    }

    // halfstar 추가
    if (halfStars === 1) {
      stars.push(<img key="half" src="/icons/halfstar.png" alt="Half Star" />);
    }

    // emptystar 추가
    for (let i = 0; i < emptyStars; i++) {
      stars.push(<img key={`empty-${i}`} src="/icons/emptystar.png" alt="Empty Star" />);
    }

    return stars;
  };

  return (
    <div>
      <div className="review-list">
        {reviews.map((review) => (
          <Link to={`/reviews/${review.차량번호}`} key={review.차량번호} className="review-card-link">
            <div className="review-card">
              <h2>{review.이름}</h2>
              <p>
                <strong className="plus">장점</strong>
                {review.장점}
              </p>
              <p>
                <strong className="minus">단점</strong>
                {review.단점}
              </p>
              <div className="review-rating">
                {renderStars(review.평점)}
                <span className="review-point">{review.평점}</span>
                {/* 평점에 따른 별 이미지 표시 */}
              </div>
              <img className="review-image" src={`/images/${review.차량번호}.png`} alt={review.이름} />
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
};

export default ReviewList;
