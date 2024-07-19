const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');
const app = express();
const port = process.env.PORT || 3001;

// PostgreSQL 연결 설정
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: '5432', // 실제 비밀번호로 대체
  port: 5432,
});

// CORS 미들웨어 사용
app.use(cors());

// JSON 요청 본문을 처리할 수 있도록 미들웨어 추가
app.use(express.json());

// 정적 파일 제공
app.use(express.static(path.join(__dirname, 'build')));

// 모든 차량 데이터 조회 예제
app.get('/api/vehicles', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM vehicle');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database query failed' });
  }
});

// 특정 차량 데이터 조회 예제
app.get('/api/vehicles/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT * FROM vehicle WHERE 차량번호 = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Vehicle not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database query failed' });
  }
});

// React 앱 제공
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

// 서버 시작
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
