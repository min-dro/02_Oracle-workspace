----- < 실습 문제 > -----
-- 도서관리 프로그램을 만들기 위한 테이블들 만들기 --
-- 이때, 제약조건에 이름을 부여할것
-- 각 컬럼에 주석 달기

-- 1. 출판사들에 대한 데이터를 담기 위한 출판사 테이블 (TB_PUBLISHER)
-- 컬럼 : PUB_NO (출판사번호) -- 기본키 (PUBLISHER_PK)
--        PUB_NAME (출판사명) -- NOT NULL (PUBLISHER_NN)
--        PHONE (출판사전화번호) -- 제약조건 없음
CREATE TABLE TB_PUBLISHER(
        PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
        PUB_NAME VARCHAR2(20) CONSTRAINT PUBLISHER_NN NOT NULL,
        PHONE CHAR(14)
);
COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';
-- 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_PUBLISHER VALUES(1
                              , '삼성'
                              , '010-1234-5678'
);
INSERT INTO TB_PUBLISHER VALUES(2
                              , '엘지'
                              , '010-9876-5432'
);
INSERT INTO TB_PUBLISHER VALUES(3
                              , '애플'
                              , NULL
);
-- 2. 도서들에 대한 데이터를 담기 위한 도서 테이블 (TB_BOOK)
-- 컬럼 : BK_NO (도서번호) -- 기본키 (BOOK_PK)
--        BK_TITLE (도서명) -- NOT NULL (BOOK_NN_TITLE)
--        BK_AUTHOR (저자명) -- NOT NULL (BOOK_NN_AUTHOR)
--        BK_PRICE (가격)
--        BK_PUB_NO (출판사번호) -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
--                                 이 때, 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 한다.
CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(30) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT BOK_NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER CONSTRAINT BOOK_FK REFERENCES TB_PUBLISHER(PUB_NO)
);
COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';
-- 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_BOOK VALUES(1
                         , '자바'
                         , '내가'
                         , '10000'
                         , 3
);
INSERT INTO TB_BOOK VALUES(2
                         , '오라클'
                         , '너가'
                         , '9000'
                         , 3
);
INSERT INTO TB_BOOK VALUES(3
                         , 'SQL'
                         , '우리가'
                         , '8000'
                         , 2
);
INSERT INTO TB_BOOK VALUES(4
                         , 'Python'
                         , '너희가'
                         , '7000'
                         , 1
);
INSERT INTO TB_BOOK VALUES(5
                         , 'JDBC'
                         , '그가'
                         , '5000'
                         , 1
);
-- 3. 회원에 대한 데이터를 담기 위한 회원 테이블 (TB_MEMBER)
-- 컬럼명 : MEMBER_NO (회원번호) -- 기본키 (MEMBER_PK)
--         MEMBER_ID (아이디) -- 중복금지 (MEMBER_UQ)
--         MEMBER_PWD (비밀번호) -- NOT NULL (MEMBER_NN_PWD)
--         MEMBER_NAME (회원명) -- NOT NULL (MEMBER_NN_NAME)
--         GENDER (성별) -- 'M' 또는 'F' 로 입력되도록 제한 (MEMBER_CK_GEN)
--         ADDRESS (주소)
--         PHONE (연락처)
--         STATUS (탈퇴여부) -- 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N' 으로만 입력되도록 제약조건 (MEMBER_CK_ST)
--         ENROLL_DATE (가입일) -- 기본값으로 SYSDATE, NOT NULL 제약조건 (MEMBER_NN_EN)
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(30) CONSTRAINT MEMBER_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(1) CONSTRAINT MEMBER_CK_GEN CHECK(GENDER IN ('M', 'F')),
    ADDRESS VARCHAR2(100),
    PHONE CHAR(14),
    STATUS CHAR(1) DEFAULT 'N' CONSTRAINT MEMBER_CK_ST CHECK(STATUS IN ('Y', 'N')),
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
);
COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';
-- 5개 정도의 샘플 데이터 추가하기
INSERT INTO TB_MEMBER VALUES(1
                           , '아이디1'
                           , '비밀번호1'
                           , '이현민'
                           , 'M'
                           , '서울 송파구'
                           , '010-1111-1111'
                           , 'N'
                           , SYSDATE
);
INSERT INTO TB_MEMBER VALUES(2
                           , '아이디2'
                           , '비밀번호2'
                           , '이효웅'
                           , 'M'
                           , '광주 북구'
                           , '010-2222-2222'
                           , 'N'
                           , DEFAULT
);
INSERT INTO TB_MEMBER VALUES(3
                           , '아이디3'
                           , '비밀번호3'
                           , '조동민'
                           , 'M'
                           , '경기 군포'
                           , '010-3333-3333'
                           , DEFAULT
                           , SYSDATE
);
INSERT INTO TB_MEMBER VALUES(4
                           , '아이디4'
                           , '비밀번호4'
                           , '구현준'
                           , 'M'
                           , '부산 해운대구'
                           , '010-4444-4444'
                           , 'N'
                           , SYSDATE
);
INSERT INTO TB_MEMBER VALUES(5
                           , NULL
                           , '비밀번호5'
                           , '지민석'
                           , NULL
                           , NULL
                           , '010-1111-1111'
                           , 'N'
                           , SYSDATE
);
-- 4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블 (TB_RENT)
-- 컬럼 : RENT_NO (대여번호) -- 기본키 (RENT_PK)
--        RENT_MEM_NO (대여회원번호) -- 외래키 (RENT_FK_MEM) TB_MEMBER 와 참조하도록
--                                    이 때, 부모 데이터 삭제 시 자식 데이터 값이 NULL 이 되도록 옵션 설정
--        RENT_BOOK_NO (대여도서번호) -- 외래키 (RENT_FK_BOOK) TB_BOOK 와 참조하도록
--                                     이 때, 부모 데이터 삭제 시 자식 데이터 값이 NULL 값이 되도록 옵션 설정
--        RENT_DATE (대여일) -- 기본값 SYSDATE
CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER(MEMBER_NO) ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK(BK_NO) ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);
COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';
-- 3개 정도의 샘플 데이터 추가하기
INSERT INTO TB_RENT VALUES(1, 1, 1, SYSDATE);
INSERT INTO TB_RENT VALUES(2, 2, 2, SYSDATE);
INSERT INTO TB_RENT VALUES(3, 3, 3, DEFAULT);

-- JOIN 을 활용해보기 (오라클 전용 구문 / ANSI 구문)
-- 예) 모든 도서 정보들에 대해 도서명, 저자명, 가격, 출판사명 조회
-- 예) 2024/07/01 ~ 2024/08/01 사이의 도서 대여 정보들에 대해 
--    대여번호, 대여한회원의 아이디, 대여한 회원의 이름, 
--    대여 도서명, 대여일 조회
SELECT BK_TITLE, BK_AUTHOR, BK_PRICE, PUB_NAME
  FROM TB_BOOK, TB_PUBLISHER
 WHERE BK_PUB_NO = PUB_NO;
 
SELECT RENT_NO, MEMBER_ID, MEMBER_NAME, BK_TITLE, RENT_DATE
  FROM TB_RENT
  JOIN TB_MEMBER ON (RENT_MEM_NO = MEMBER_NO)
  JOIN TB_BOOK ON (RENT_BOOK_NO = BK_NO)
 WHERE RENT_DATE BETWEEN '2024/07/01' AND '2024/08/01';