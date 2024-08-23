const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");
const path = require("path");
const app = express();
const port = process.env.PORT || 3001;

// PostgreSQL 연결 설정
// 실제 환경에서는 비밀번호와 데이터베이스 설정을 환경 변수로 관리하는 것이 좋습니다.
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "postgres",
  password: "5432", // 실제 비밀번호로 대체
  port: 5432,
});

// CORS 미들웨어 사용
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, "build")));

// 차량 데이터 조회 API
// 필터링, 정렬, 페이지네이션을 포함한 데이터 조회를 처리합니다.
app.get("/api/vehicles", async (req, res) => {
  const {
    page = 1, // 페이지 번호
    limit = 20, // 한 페이지에서 가져올 데이터 수
    brand, // 브랜드 필터
    type, // 차종 필터
    engine, // 엔진 타입 필터
    minPrice, // 최소 가격 필터
    maxPrice, // 최대 가격 필터
    fuelEfficiency, // 연비 필터
    power, // 출력 필터
    searchTerm, // 검색어 필터
    sortOption, // 정렬 옵션
  } = req.query;

  const offset = (page - 1) * limit; // 페이지네이션 오프셋 계산

  let query = "SELECT * FROM vehicle WHERE 1=1"; // 기본 쿼리, WHERE 1=1은 조건 추가를 쉽게 하기 위함
  const queryParams = []; // SQL 쿼리에 사용할 매개변수
  const filterConditions = []; // 필터 조건을 담을 배열

  // 브랜드 필터링 (합집합 처리)
  if (brand) {
    const brands = brand.split(",");
    filterConditions.push(`브랜드 = ANY(ARRAY[${brands.map((_, i) => `$${queryParams.length + i + 1}`).join(", ")}])`);
    queryParams.push(...brands);
  }

  // 차종 필터링 (합집합 처리)
  if (type) {
    const types = type.split(",");
    filterConditions.push(`차종 = ANY(ARRAY[${types.map((_, i) => `$${queryParams.length + i + 1}`).join(", ")}])`);
    queryParams.push(...types);
  }

  // 엔진 필터링 (합집합 처리)
  if (engine) {
    const engines = engine.split(",");
    filterConditions.push(engines.map((_, i) => `엔진 ILIKE $${queryParams.length + i + 1}`).join(" OR "));
    engines.forEach((eng) => queryParams.push(`%${eng}%`));
  }

  // 가격 필터링 (교집합 처리)
  if (minPrice) {
    queryParams.push(minPrice);
    filterConditions.push(`최소가격 >= $${queryParams.length}`);
  }

  if (maxPrice) {
    queryParams.push(maxPrice);
    filterConditions.push(`최대가격 <= $${queryParams.length}`);
  }

  // 연비 필터링 (교집합 처리)
  if (fuelEfficiency) {
    const fuelEfficiencies = fuelEfficiency.split(",");
    const conditions = fuelEfficiencies.map((range) => {
      const [min, max] = range.split("-").map(Number);
      queryParams.push(min, max);
      return `((최소연비 >= $${queryParams.length - 1} AND 최소연비 <= $${queryParams.length}) OR (최대연비 >= $${queryParams.length - 1} AND 최대연비 <= $${queryParams.length}))`;
    });
    filterConditions.push(`(${conditions.join(" OR ")})`);
  }

  // 출력 필터링 (교집합 처리)
  if (power) {
    const powers = power.split(",");
    const conditions = powers.map((range) => {
      const [min, max] = range.split("-").map(Number);
      queryParams.push(min, max);
      return `((최소출력 >= $${queryParams.length - 1} AND 최소출력 <= $${queryParams.length}) OR (최대출력 >= $${queryParams.length - 1} AND 최대출력 <= $${queryParams.length}))`;
    });
    filterConditions.push(`(${conditions.join(" OR ")})`);
  }

  // 이름 필터링 (검색어)
  if (searchTerm) {
    queryParams.push(`%${searchTerm}%`);
    filterConditions.push(`이름 ILIKE $${queryParams.length}`);
  }

  // 필터 조건들을 결합하여 최종 쿼리 생성
  if (filterConditions.length > 0) {
    query += " AND (" + filterConditions.join(") AND (") + ")";
  }

  // 정렬 옵션 처리
  if (sortOption && sortOption !== "브랜드순") {
    if (sortOption === "낮은 가격순") {
      query += " ORDER BY 최소가격 ASC";
    } else if (sortOption === "높은 가격순") {
      query += " ORDER BY 최대가격 DESC";
    } else if (sortOption === "낮은 연비순") {
      query += " ORDER BY 최소연비 ASC";
    } else if (sortOption === "높은 연비순") {
      query += " ORDER BY 최대연비 DESC";
    } else if (sortOption === "낮은 출력순") {
      query += " ORDER BY 최소출력 ASC";
    } else if (sortOption === "높은 출력순") {
      query += " ORDER BY 최대출력 DESC";
    }
  }

  // 페이지네이션 처리 (LIMIT과 OFFSET)
  queryParams.push(limit, offset);
  query += ` LIMIT $${queryParams.length - 1} OFFSET $${queryParams.length}`;

  try {
    const result = await pool.query(query, queryParams); // 데이터베이스 쿼리 실행
    res.json(result.rows); // 결과 반환
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Database query failed" }); // 오류 처리
  }
});

// 특정 차량 데이터 조회 (상세 페이지)
app.get("/api/vehicles/:id", async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      `
      WITH filtered_vehicle AS (
        SELECT * 
        FROM vehicle 
        WHERE 차량번호 = $1
      )
      SELECT * 
      FROM filtered_vehicle v
      LEFT JOIN vehicle_detail vd ON v.차량번호 = vd.차량번호
      `,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Vehicle not found" }); // 차량이 없을 때
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Database query failed" }); // 오류 처리
  }
});

// React 앱 제공
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build", "index.html")); // React 빌드 파일 제공
});

// 서버 시작
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
