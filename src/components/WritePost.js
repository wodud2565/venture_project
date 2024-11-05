import React, { useState, useEffect } from "react";
import "react-quill/dist/quill.snow.css";
import ReactQuill from "react-quill";
import styles from "./WritePost.module.css";
import { auth } from "../firebase"; // Firebase 설정 파일에서 auth 가져오기

const WritePost = () => {
  // 로그인 상태 확인하고 아니면 전 페이지로 퇴장
  // 이메일 파이어베이스에서 가져오기
  const [email, setEmail] = useState(""); // 이메일을 상태로 관리
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [category, setCategory] = useState("");

  useEffect(() => {
    // Firebase Auth에서 현재 로그인된 사용자의 이메일 가져오기
    const unsubscribe = auth.onAuthStateChanged((user) => {
      if (user) {
        setEmail(user.email); // 로그인된 사용자의 이메일 설정
      } else {
        // 로그아웃 상태일 경우 로그인 페이지로 리다이렉트하는 등 추가 로직을 여기에 작성 가능
        setEmail(""); // 로그아웃 상태일 때 이메일을 빈 문자열로 설정
      }
    });

    // 컴포넌트 언마운트 시 리스너 정리
    return () => unsubscribe();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log(title, content, category, email);

    try {
      const response = await fetch("https://us-central1-findingcar-12d9d.cloudfunctions.net/MyApi/api/posts", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          title,
          content,
          category,
          email, // 로그인된 사용자의 이메일이 전송됨
        }),
      });

      if (!response.ok) {
        // HTTP 상태 코드가 2xx가 아닌 경우 에러 처리
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      console.log("Post created:", data);
      // 성공 메시지와 게시판페이지로 넘어가기
      window.location.href = `/postlist`;
      alert("등록되었습니다.");
    } catch (error) {
      console.error("Error creating post:", error);
      alert("잠시 후 다시 시도해 주세요.");
    }
  };

  return (
    <div className={styles.postForm}>
      <h2>글쓰기</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <select id="category" value={category} onChange={(e) => setCategory(e.target.value)} required>
            <option value="">말머리</option>
            <option value="자유">자유</option>
            <option value="질문">질문</option>
          </select>
        </div>
        <div>
          <input type="text" id="title" value={title} onChange={(e) => setTitle(e.target.value)} required maxLength="100" placeholder="제목" />
        </div>
        <div>
          <ReactQuill value={content} onChange={setContent} modules={modules} formats={formats} />
        </div>

        <button type="submit">작성</button>
      </form>
    </div>
  );
};

// Quill 에디터의 모듈 및 포맷 설정
const modules = {
  toolbar: [
    [{ header: "1" }, { header: "2" }, { font: [] }],
    [{ list: "ordered" }, { list: "bullet" }],
    [{ script: "sub" }, { script: "super" }],
    [{ indent: "-1" }, { indent: "+1" }],
    [{ direction: "rtl" }],
    [{ size: ["small", false, "large", "huge"] }],
    [{ color: [] }, { background: [] }],
    [{ align: [] }],
    ["link", "image"],
    ["clean"], // 'clean' 버튼은 서식을 제거합니다.
  ],
};

const formats = ["header", "font", "list", "bullet", "script", "indent", "direction", "size", "color", "background", "align", "link", "image"];

export default WritePost;
