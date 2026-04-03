/*
    * DDL (DATE DEFINITION LANGUAGE)
    
    - 데이터 정의 언어
    - 오라클에서 제공하는 객체 (OBJECT) 를 새로이 만들고 (CREATE), 구조를 변경하고 (ALTER), 구조 자체를 삭제하는 (DROP) 명령문
    - 즉, 데이터베이스를 이루고 있는 구조물 자체를 정의하는 명령문으로, 주로 DB 관리자, 설계자가 이용함!!
    
    * 오라클의 객체 (OBJECT)
    
    - 오라클 데이터베이스를 이루고 있는 "구조물"
    
    [ 종류 ] (기술면접)
    테이블 (TABLE), 뷰 (VIEW), 시퀀스 (SEQUENCE), 인덱스 (INDEX),
    패키지 (PACKAGE), 트리거 (TRIGGER), 프로시저 (PROCEDURE)<-리턴값 X, 함수 (FUNCTION)<-리턴값 O
    동의어 (SYNONYM), 사용자 (USER)
*/

/*
    < CREATE TABLE >
    
    * 테이블  (TABLE)
    
    - 행 (ROW), 열 (COULUMN) 로 구성되는 "가장 기본적인" 데이터베이스 객체 (구조물)
    - 모든 데이터는 항상 테이블을 통해서 저장된다!!
    - 즉, 데이터를 보관하고자 한다면 테이블을 무조건 만들어야함!!
    
    [ 표현법 ]
    
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        컬럼명 자료형,
        컬럼명 자료형,
        ...
    );
    
    < 자료형 >
    
    - 문자열 CHARACTER
    : 크기는 BYTE 단위로 지정한다.
      숫자, 영문자, 특수문자 => 한 글자 당 1BYTE 로 취급
      한글                 => 한 글자 당 3BYTE 로 취급
      
      CHAR(바이트수) : 최대 2000BYTE 까지 지정 가능(SQLD)
                      고정길이 문자열 (아무리 적은 값이 들어와도 공백으로 채워서 처음 할당 된
                      주로 들어올 값의 글자수가 딱 정해져 있을 경우 쓰는게 유리함!!
                      예) 성별 : '남' / '여' => 한 칸당 3BYTE 로 처리
                                'M' / 'F'  => 한 칸당 1BYTE 로 처리
                          전화번호 : 010-XXXX-XXXX => 한 칸당 13BYTE 로 처리 (만약 - 를 제외하고 저장할거라면 한칸당 11BYTE 로 처리)
                          주민번호 : YYMMDD-GXXXXXX => 한 칸당 14BYRE 로 처리
      
      VARCHAR2(바이트수) : 최대 4000BYTE 까지 지정 가능(SQLD)
                          가변길이 문자열 (적은 값이 들어오면 그 담긴 값에 맞춰서 저장 공간의 크기가 줄어듦)
                          그렇다고 해서 작은 공간에 큰 값을 넣을 수 없다!!
                          주로 글자 수 또는 데이터의 용량이 가늠이 되지 않을 경우 쓰는게 유리함!!
                          예) 게시글 제목, 아이디, 비밀번호 등등
                          (VAR 는 가변, 2 는 두배라는 뜻)
      
      CLOB : 최대 128TB 까지 저장 가능 (대용량 문자열 자료형_
             대체로 문자열 관련 함구들을 적용 불가!!
             주로 저장해야한 문자열의 용량이 만도 안되게 큰 경우 쓰면 유리함!!
             예) 게시글 내용 (무지막지하게 길 거 같을 때)

    - 숫자 NUMBER : 정수, 실수 상관없이 모두 다 보관 가능
    
    - 날짜 DATE : 년, 월, 일, 시, 분, 초를 모두 다 포함한 자료형
*/

-->> 회원들의 데이터를 담을 수 있는 테이블 (아이디, 비밀번호, 이름, 회원가입일) MEMBER 테이블 생성하기
CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE
);
--> Table MEMBER이(가) 생성되었습니다.
--> 한 계정 내에 동일한 이름의 테이블명 중복 불가!!
--> 한 테이블 내에 동일한 이름의 컬럼명 중복 불가!!
--> 이름을 지을 때에는 대소문자 구문 X (낙타 표기법 사용 불가, 언더바로 구분)(스네이크 케이스)
-- VARCHAR2 더라도 사이즈를 오버해서 담을 수는 없기 때문에, 다소 넉넉하게 사이즈를 지정하는 것이 좋음!!

-- 테이블이 잘 만들어졌나 확인
-- 1. 접속탭 > 해당 계정 > 테이블 정보 로 직접 확인하기

-- 2. 단순 SELECT 문을 이용하는 방법
SELECT * FROM MEMBER;

-- 3. 데이터 딕셔너리를 이용해서 테이블 정보 확인하기
-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블 (오직 조회 용도)
-- 예) 이 데이터베이스의 모든 계정 정보들, 이 데이터베이스의 모든 테이블 정보들, 이 데이터베이스의 모든 컬럼 정보들
-- USER_TABLES : 현재 이 계정이 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 데이터 딕셔너리
SELECT * FROM USER_TABLES;

-- USER_TAB_COLUMS : 현재 이 계정이 가지고 있는 테이블들의 모든 컬럼의 정보들을 조회할 수 있는 데이터 딕셔너리
SELECT * FROM USER_TAB_COLUMNS;

/*
    * 컬럼에 주석 달기 (컬럼에 대한 설명)
    
    [ 표현법 ]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
*/

-- 각각 '회원아이디', '회원비밀번호', '회원이름', '회원가입일' 이렇게 주석을 달려면?
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';
--> 권장사항!!

-- 만들어진 MEMNER 테이블에 데이터 넣어보기
-- 데이터를 추가 (삽입) 할 수 있는 구문 : INSERT 문 (한 행 단위로 추가, 값의 순서가 중요)
-- INSERT INTO 테이블명 VALUES(첫번째컬럼값, 두번째컬럼값, 세번째컬럼값, ..., 마지막컬럼값);
INSERT INTO MEMBER VALUES('user01', 'pass01', '홍길동', '2021-02-01');
--> 1 행 이(가) 삽입되었습니다.

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES('user02', 'pass02', '김말똥', '22/02/02');

INSERT INTO MEMBER VALUES('user03', 'pass03', '고영희', SYSDATE);

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, SYSDATE);
--> 아이디, 비밀번호, 이름에 NULL 값이 존재해서는 안됨!!

INSERT INTO MEMBER VALUES('user03', 'pass04', '박말순', SYSDATE);
--> 중복된 아이디는 존재해서는 안됨!!

-- 위의 NULL 값이나 중복된 아이디 값은 유효하지 않은 값들이다.
-- (즉, 테이블에 저장되면 안되는 값들이다)
-- 유효한 데이터값들을 유지하기 위해서 "제약조건" 을 걸어줘야 한다!!

--------------------------------------------------------------------------------

/*
    < 제약조건 CONSTRAINTS >
    
    - 원하는 데이터값만 항상 유지하기 위해서 (보관하기 위해서)
      특정 컬럼마다 설정하는 제약 (데이터 무결성 보장을 목적으로)
      
    - 제약조건이 부여된 컬럼에 들어올 데이터에 문제가 있는지 없는지 자동으로 검사해줌!!
      (애초에 데이터에 문제가 있다면 데이터가 저장되지 않음!!)
      
    [ 종류 ]
    
    NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREGIN KEY (SQLD)
    
    - 컬럼에 제약조건을 부여하는 방식 : 컬럼레벨방식 / 테이블레벨방식
*/

/*
    1. NOT NULL 제약조건
    
    - 해당 컬럼에 반드시 값이 존재해야 하는 경우 사용
      (즉, NULL 값이 절대로 들어와서는 안되는 컬럼에 부여)
      
      단, NOT NULL 제약조건은 컬럼레벨방식으로 부여할 수 있다!!
*/

-- 위에서 생성한 MEMBER 테이블 보완한 MEM_NOTNULL 테이블 생성
-- NOT NULL 제약조건을 추가한 형태로 새로 생성해보기!!

-- 컬럼레벨방식
-- [ 표현법 ]
-- 컬럼명 자료형 제약조건
-- : 제약조건을 부여하고자 하는 컬럼 뒤에 곧바로 기술하는 방법

CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAILE VARCHAR2(30)
);

SELECT * FROM MEM_NOTNULL;

--> 컬럼 명세에서 NULLABLE 항목이 NO 일 경우 NOT NULL 제약조건이 걸린 것!!
--  (NULL 이 못들어간다 라는 뜻)

-- 회원 정보 INSERT 해보기
INSERT INTO MEM_NOTNULL VALUES(1
                                , 'user01'
                                , 'pass01'
                                , '홍길동'
                                , '남'
                                , '010-1234-1234'
                                , 'user01@gmail.com');

INSERT INTO MEM_NOTNULL VALUES(2
                             , NULL
                             , NULL
                             , NULL
                             , NULL
                             , NULL
                             , NULL);
--> CANNOT INSERT NULL INTO 계정명.테이블명.컬럼명 오류 발생!!
--  NOT NULL 제약조건에 위배되서 오류가 발생함!!

INSERT INTO MEM_NOTNULL VALUES(2
                             , 'user02'
                             , 'pass02'
                             , '김갑생'
                             , NULL
                             , NULL
                             , NULL);
--> NOT NULL 제약조건이 걸려있는 컬럼에는 반드시 값이 존재해야함!!
--  NOT NULL 제약조건이 걸려있지 않은 컬럼에는 NULL 값이 들어가도 됨!!

INSERT INTO MEM_NOTNULL VALUES(3
                             , 'user01'
                             , 'pass03'
                             , '박말순'
                             , '여'
                             , NULL
                             , NULL);
                             
--------------------------------------------------------------------------------

/*
    2.UNIQUE 제약조건
    
    - 컬럼에 중복값을 제한하는 제약조건
    
    - 데이터 삽입 / 수정 시 기존에 해당 컬럼값 중에 중복값이 이미 있을 경우
      추가 또는 수정이 되지 않도록 막아줌
      
    - 컬럼레벨 / 테이블레벨방식 모두 다 가능
*/

-- 위에서 만든 MEM_NOTNULL 테이블을 보완한 MEM_UNIQUE 테이블 생성해보기
-- UNIQUE 제약조건까지 추가한 형태로 만들어보자!!
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
);
--> 한 컬럼에 여러개의 제약조건을 걸 수 있다!!
-- 특히, 컬럼레벨방식의 경우 띄어쓰기 (공백) 로 구분해서 나열해주면 됨!!

SELECT * FROM MEM_UNIQUE;

-- MEM_UNIQUE 테이블 삭제 (DROP) 후 테이블레벨방식으로 재생성
-- [ 표현법 ]
-- DROP TABLE 테이블명;
DROP TABLE MEM_UNIQUE;
--> Tavle MEM_UNIQUE이(가) 삭제되었습니다.

-- 테이블 삭제 후 조회
SELECT * FROM MEM_UNIQUE;
--> table or view does not exist 오류 발생!!

-- 테이블레벨방식
-- : 컬럼명들을 모두 나열한 뒤 마지막에 어느 컬럼에 어느 제약조건을 걸건지
--   마저 연이어서 나열하는 방식

CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL, -- UNIQUE 제약조건 킵
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONDE CHAR(13),
    EMAIL VARCHAR2(30), -- 여기까지는 컬럼들을 나열한 부분
    UNIQUE(MEM_ID) -- 위에서 제시한 컬럼들 중 어느 컬럼에 어느 제약조건을 걸건지 추가적으로 나열하는 부분 (테이블레벨방식)
);

SELECT * FROM MEM_UNIQUE;

--> 제약조건 탭을 열면 UNIQUE 제약조건이 어느 컬럼에 걸렸는지 확인 가능!!

INSERT INTO MEM_UNIQUE VALUES(1
                            , 'user01'
                            , 'pass01'
                            , '홍길동'
                            , '남'
                            , '010-1234-1234'
                            , 'user01@gmail.com');
                            
INSERT INTO MEM_UNIQUE VALUES(2
                            , 'user02'
                            , 'pass02'
                            , '김갑생'
                            , NULL
                            , NULL
                            , NULL);
                            
INSERT INTO MEM_UNIQUE VALUES(3
                            , 'user02'
                            , 'user03'
                            , '박말순'
                            , '남'
                            , NULL
                            , NULL);
--> UNIQUE CONSTRAINT (계정명.SYS_C~~) VIOLATED 오류 발생
--  UNIQUE 제약조건에 위배되었기 때문에 오류가 발생함!!
--> 오류 구문으로 제약조건에 위배되었다고 알려는 주지만
--  아까 NOT NULL 제약조건이 위배되었을 때 처럼 정확하게 어느 계정의 어느 테이블의 어느 컬럼에서
--  제약조건이 위배되있는지는 안알려줌!!
--  단, 제약조건명을 제시해서 어느 부분에 오류가 났는지는 알려줌
--  여기서 SYS_C~~~ 는 제약조건의 이름을 뜻함!! (제약조건명)
--  DDL.SYS_C007082 : DDL 계정의 SYS_C007060 이름의 제약조건

-- 제약조건 부여 시 직접 제약조건명을 지정해주지 않으면
-- 오라클 시스템에서 알아서 임의의 제약조건명을 부여해줌 (SYS_C~~~)

/*
    * 제약조건 부여 시 제약조건명도 지정하는 표현식 (권장사항)
    
    - 컬럼레벨방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형 CONSTRAINT 제약조건명 제약조건,
        컬럼명 자료형,
        ...
    );
    
    - 테이블레벨방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        컬럼명 자료형,
        CONSETRAINT 제약조건명 제약조건(컬럼명)
    );
    
    - 이 때 두 방식 모두 "CONSTRAINT 제약조건명" 은 생략 가능!!
      단, 생략 시 제약조건명이 임의로 SYS_C~~~ 로 붙음!!
      
    - 제약조건명을 지을 때의 팁이라고 한다면
      테이블명_컬럼명_제약조건약자 처럼 키워드를 조합해서 짓는다.
*/

-- 위에서 만든 MEM_UNIQUE 테이블을 보완한 테이블 MEM_CON_NM 테이블 생성
-- 테이블 구조는 그대로 두고, 제약조건에 이름을 붙이는 형식으로 보완해보자!!
CREATE TABLE MEM_CON_NM (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEM_PWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),
    CONSTRAINT MEM_ID_UQ UNIQUE(MEM_ID)
);

SELECT * FROM MEM_CON_NM;

INSERT INTO MEM_CON_NM VALUES(1
                            , 'user01'
                            , 'pass01'
                            , '홍길동'
                            , NULL
                            , NULL
                            , NULL);
                    
INSERT INTO MEM_CPN_NM VALUES(2
                            , 'user01'
                            , 'pass02'
                            , '김갑생'
                            , '남'
                            , NULL
                            , NULL);
--> unique constraint (DDL.MEM_ID_UQ) violated
--  제약조건명을 지정한 후 오류 구문을 보면
--  컬럼명 + 제약조건 키워드 등을 조합해서 지었기 때문에 한눈에
-- 어디서 어떤 오류가 발생했는지 대강 바로 알아차릴 수 있게된다!!

INSERT INTO MEM_CON_NM VALUES(2
                            , 'user02'
                            , 'pass02'
                            , '김말똥'
                            , '가'
                            , NULL
                            , NULL);
                            
SELECT * FROM MEM_CON_NM;
--> GENDER 컬럼에 '남' 또는 '여' 만 들어가게 하고 싶음!!

--------------------------------------------------------------------------------

/*
    3. CHACK 제약 조건
    
    - 컬럼에 기록될 수 있는 값에 대한 "조건식" 을 설정해줄 수 있다.
      (즉, 조건식에 맞아 떨어지는 값들만 해당 컬럼에 저장하겠다)
      
    [ 표현법 ]
    CHECK(해당컬럼명이포함된조건식);
*/

-- 위의 테이블을 보완해서 성별 자리에 '남' 또는 '여' 만 저장 가능하도록 MEM_CHECK 테이블을 생성
CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- 컬럼레벨방식
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE NOT NULL   
    -- CHECK(GENDER IN ('남', '여')) -- 테이블레벨방식
);

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK VALUES(1
                           , 'user01'
                           , 'pass01'
                           , '홍길동'
                           , '남'
                           , '010-1234-1234'
                           , 'user01@gmail.com'
                           , SYSDATE);
                           
INSERT INTO MEM_CHECK VALUES(2
                           , 'user02'
                           , 'pass02'
                           , '김갑생'
                           , '여'
                           , NULL
                           , NULL
                           , SYSDATE);
    
INSERT INTO MEM_CHECK VALUES(3
                           , 'user03'
                           , 'pass03'
                           , '박말순'
                           , NULL
                           , NULL
                           , NULL
                           , SYSDATE);
--> GENDER 컬럼에는 CHECK 제약조건을 건 거지 NOT NULL 제약조건을 건 건 아님!!
--  CHECK 제약조건에 NULL 값도 존재 가능함!! (단, CHECK 제약조건 조건식에 IS NOT NULL 포함 X)
--  만약 NULL 값 또한 못들어오게 막고 싶다면 NOT NULL 도 같이 부여해주면 됨!!

INSERT INTO MEM_CHECK VALUES(4
                           , 'user04'
                           , 'pass04'
                           , '김말똥'
                           , '가'
                           , NULL
                           , NULL
                           , SYSDATE);
--> check constraint (DDL.SYS_C007071) violated 오류 발생!!
--  마찬가지로 CHECK 제약조건 또한 위배되었을 때 제약조건명으로만 오류로 알려줌!!

--> 어차피 회원가입일은 INSERT 되는 시점임!!
--  항상 SYSDATE 값에 대한 "기본값" 지정 가능

/*
    * 특성 컬럼에 들어올 값에 대한 "기본값" 지정 가능
    
    - DEFAULT 설정 (제약조건은 아님!!)
*/

-- 위에서 만들었던 MEM_CHECK 테이블 삭제 후 재생성
DROP TABLE MEM_CHECK;

SELECT * FROM MEM_CHECK;

-- 회원가입일에 항상 SYSDATE 를 기본값으로 넣을 수 있게끔 보완한 테이블로 MEM_CHECK 생성해보기!!
CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL
);

--> DEFAULT 설정 시 컬럼 명세창에서 DATA_DEFAULT 항목에서 확인 가능!!

--  이 시점부터 MEM_DATE 컬럼에 딱히 담을 값이 없다면 알아서 기본값인 SYSDATE 로 담아주게됨!!

/*
    * 데이터 삽입 시 일부 데이터만 지정해서 넣는 방법
    
    [ 표현법 ]
    INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3)
                 VALUES(넣을값1, 넣을값2, 넣을값3);
    
    - 이 때, 테이블명 옆에 언급되지 않은 컬럼명에 대해서는 NULL 값으로 채워져서 INSERT 됨!! 
*/

INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, MEM_DATE)
               VALUES(1, 'user01', 'pass01' ,'홍길동', SYSDATE);
                
INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, MEM_DATE)
               VALUES(2, 'user02', 'pass02', '김말똥', DEFAULT);     
--> DEFAULT 설정값으로 INSERT 를 하고 싶다면 DEFAULT 키워드를 쓰면 된다!!

INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_DATE)
               VALUES(1, 'user03', 'pass03', DEFAULT);
--> MEM_NAME 은 NOT NULL 제약조건인데, MEM_NAME 컬럼을 명시하지 않았기 때문에
-- INSERT 과정에서 NULL 값이 삽입되려고해서 오류 발생!!

INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME)
               VALUES(3, 'user03', 'pass03', '박말순');
--> 다만, NOT NULL 제약조건이 걸린 컬럼을 명시하지 않더라도
--  그 컬럼에 DEFAULT 설정이 들어가 있다면 NULL 대신 그 DEFAULT 값이 우선적으로 INSERT 되게 됨!!

-- DEFAULT 가 제약조건이 아닌 일반 설정인 이유!!
INSERT INTO MEM_CHECK(MEM_NO, MEM_ID, MEM_PWD, MEM_NAME, MEM_DATE)
               VALUES(4, 'user04', 'pass04', '고영희', '19/11/11');
--> DEFAULT 설정을 했다고 해서 무조건 그 컬럼에 DEFAULT 값만 들어가라는 법은 없음!!
--  그래서 제약조건으로 취급되지 않고 일반 설정으로 취급됨!!

--------------------------------------------------------------------------------

/*
    4. PRIMARY KEY (기본키, 주키) 제약조건
    
    - 테이블에서 각 행들의 정보를 "유일" 하게 "식별" 할 수 있는 컬럼에 부여하는 제약조건
    
    - 각 행들을 구분할 수 있는 식별자의 역할, 식별자의 의미로 사용할 수 있음!!
      (HASHMAP 으로 따지면 KEY 같은 존재)
      
    예) 회원번호, 주문번호, 사번, 학번, 예약번호 등..
    
    - 중복되지 않고 값이 반드기 존재해야 하는 컬럼에 PRIMARY KEY 제약조건을 부여하는 것이 좋다!!
      (역할로 따지면 NOT NULL + UNIQUE 합친 느낌)
    
    - 단 한 테이블 당 한개만 지정 가능함!! (최소성)    
*/

-- 위의 테이블을 보완하여 PRIMARY KEY 제약조건이 추가된 테이블 생성
-- MEM_PRIMARYKEY1 테이블을 생성해보자!!
CREATE TABLE MEM_PRIMARYKEY1 (
    MEM_NO NUMBER CONSTRAINT MEM_PK PRIMARY KEY, -- 컬럼레벨방식
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
    -- CONTRAINT MEM_PK PRIMARY_KEY(MEM_NO) 테이블레벨방식
);    
--> 사실 MEM_NO 대신 MEM_ID 컬럼이 PRIMARY KEY 가 될 수도 있다!!
--  MEM_PRIMARYKEY1 테이블 기준으로
--  회원들을 유일하게 식별 가능한 컬럼들 : MEM_NO, MEM_ID (PRIMARY KEY 의 후보군 : 후보키, CANDIDATE KEY)
--> MEM_ID 는 문자열이므로 내부적으로 회원 한명만 조회해야 할 때 동등비교 연산 속도가 느려질 수 있어서
--  단순히 정수로만 표현하는 MEM_NO 을 PRIMARY_KEY 로 최종 선정!! (인위적 식별자) 
--  만약 MEM_ID 가 PRIMARY KEY 가 된다면 그때는 MEM_NO 컬럼은 필요없어짐!! (본식별자)

--> PRIMARY KEY 제약조건이 부여된 컬럼은 NULL 값이 들어갈 수 없음!!
--  (컬럼 명세에서 NULLABEL 항목이 NO 라고 표시됨)
--> 마찬가지로 제약조건 탭에서 확인 가능!!

INSERT INTO MEM_PRIMARYKEY1 VALUES(1
                                 , 'user01'
                                 , 'pass01'
                                 , '홍길동'
                                 , '남'
                                 , NULL
                                 , NULL);
                                 
INSERT INTO MEM_PRIMARYKEY1 VALUES(NULL
                                 , 'user02'
                                 , 'pass02'
                                 , '김말순'
                                 , '여'
                                 , NULL
                                 , NULL);
--> cannot insert NULL into ("DDL"."MEM_PRIMARYKEY1"."MEM_NO") 오류 발생!!
--  PRIMARY KEY 컬럼에 NULL 값으로 인한 오류
--  (NOT NULL)

INSERT INTO MEM_PRIMARYKEY1 VALUES(1
                                 , 'user02'
                                 , 'pass02'
                                 , '김말순'
                                 , '여'
                                 , NULL
                                 , NULL);
--> unique constraint (DDL.MEM_PK) violated 오류 발생!!
--  PRIMARK KEY 컬럼에 중복으로 인한 오류
--  (UNIQUE 제약조건 위배 시 발생하던 오류 구문과 동일)

SELECT * FROM MEM_PRIMARYKEY1;

INSERT INTO MEM_PRIMARYKEY1 VALUES(2
                                , 'user02'
                                , 'pass02'
                                , '박말순'
                                , '여'
                                , NULL
                                , NULL);
                                
SELECT * FROM MEM_PRIMARYKEY1;

CREATE TABLE MEM_PRIMARYKEY2 (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) PRIMARY KEY,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
);
--> table can have only one primary key 오류 발생!!
--  PRIMARY KEY 가 한 테이블에 2개 이상이 될 수 없다.

-- 단, 두 개 이상의 컬럼을 "하나로" 묶어서 PRIMARY KEY 하나로 설정 가능함!!
CREATE TABLE MEM_PRIMARYKEY2 (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30), -- 여기까지는 컬럼들을 나열
    PRIMARY KEY(MEM_NO, MEM_ID) -- 제약조건을 나열 (테이블레벨방식)
);
--> 두 개의 컬럼을 하나로 묶어서 PRIMARY KEY 하나로 설정 (복합키)
--  복합키를 지정하고 싶다면 무조건 테이블레벨방식만 사용 가능함!!

INSERT INTO MEM_PRIMARYKEY2 VALUES(1
                                 , 'user01'
                                 , 'pass01'
                                 , '홍길동'
                                 , NULL
                                 , NULL
                                 , NULL);
                                 
INSERT INTO MEM_PRIMARYKEY2 VALUES(1
                                 , 'user02'
                                 , 'pass02'
                                 , '김갑생'
                                 , NULL
                                 , NULL
                                 , NULL);
            
INSERT INTO MEM_PRIMARYKEY2 VALUES(2
                                 , 'user02'
                                 , 'pass03'
                                 , '박말순'
                                 , NULL
                                 , NULL
                                 , NULL);
                    
INSERT INTO MEM_PRIMARYKEY2 VALUES(2
                                 , 'user02'
                                 , 'pass04'
                                 , '박말똥'
                                 , NULL
                                 , NULL
                                 , NULL);
--> unique constraint (DDL.SYS_C007089) violated 오류 발생!!
--  복합키일 경우 묶인 여러개의 컬럼값이 모두 일치해야지만 중복으로 판별이 됨!!

INSERT INTO MEM_PRIMARYKEY2 VALUES(3
                                 , NULL
                                 , 'pass05'
                                 , '고영희'
                                 , NULL
                                 , NULL
                                 , NULL);
--> cannot insert NULL into ("DDL"."MEM_PRIMARYKEY2"."MEM_ID") 오류 발생!!
--  복합키일 경우 복합키로 설정되어있는 컬럼들에는 하나라도 NULL 값이 들어갈 수 없음!!

--------------------------------------------------------------------------------

/*
    5. FOREIGN KEY (외래키) 제약조건
    
    - 해당 컬럼에 다른 테이블에 존재하는 값이 들어와야 할 경우 그 컬럼에 부여하는 제약조건
   
    - 다른 테이블 (부모 테이블) 을 "참조" 한다 라고 표현
    - 즉, 참조된 다른 테이블이 제공하고 있는 (부모 테이블이 제공하고 있는)
      컬럼값만 들어갈 수 있다!!
    - FOREIGN KEY 제약조건으로 다른 테이블 간의 "관계" 를 형성할 수 있음 (즉, JOIN 이 가능해짐)
     
    예) KH 계정의
    EMPLOYEE 테이블의 DEPT_CODE 컬럼에는 'D1' ~ 'D9' 까지의 값만 들어갔었음!!
    'D1' ~ 'D9' 까지의 값은 DEPARTMENT 테이블의 DEPT_ID 컬럼에 들어있었음!!
    => 결국 EMPLOYEE 의 DEPT_CODE 컬럼에는 DEPARTMENT 의 DEPT_ID 에 존재하는 값들만 저장 가능!!
    
    EMPLOYEE 테이블의 JOB_CODE 컬럼에는 'J1' ~ 'J7' 까지의 값만 담겨있었음!!
    'J1' ~ 'J7' 까지의 값음 JOB 테이블의 JOB_CODE 컬럼에 들어있었음!!
    => 결국 EMPLOYEE 의 JOB_CODE 컬럼에는 JOB 의 JOB_CODE 에 존재하는 값들만 저장 가능!!
    
    [ 표현법 ]
    
    - 컬럼레벨방식
    컬럼명 자료형 CONSTRAINT 제약조건명 REFERENCES 참조할부모테이블명(참조할컬럼명),
    
    - 테이블레벨방식
    CONSTRAINT 제약조건명 FOREIGN KEY(컬럼명) REFERNECES 참조할부모테이블명(참조할컬럼명)
    
    - 두 방식 모두 CONSTRAINT 제약조건명 은 생략 가능!!
      (단, 생략 시 기본적으로 SYS_C~~~ 로 제약조건명이 잡힘)
    - 두 방식 모두 (참조할컬럼명) 또한 생략 가능
      (생략 시, 기본적으로 참조할부모테이블의 PRIMARY KEY 제약조건 컬럼명으로 잡히게 됨)
*/

-- 명심할 사항 : 항상 부모테이블을 먼저 생성해야함!!

-- 부모테이블을 먼저 생성해보자!!
-- 회원 등급에 대한 데이터 (등급코드, 등급명) 를 보관하는 MEM_GRADE 테이블
CREATE TABLE MEM_GRADE (
    GRADE_CODE CHAR(2) PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEM_GRADE VALUES('G1', '일반회원');
INSERT INTO MEM_GRADE VALUES('G2', '우수회원');
INSERT INTO MEM_GRADE VALUES('G3', '특별회원');

SELECT * FROM MEM_GRADE;

-- 위에서 만든 부모테이블의 데이터를 가져다 쓸 수 있는 (참조해서 쓰는) 자식테이블 생성하기!!
-- 기존 회원 정보에 등급 정보까지 포함한 MEM 테이블
CREATE TABLE MEM (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), -- 컬럼레벨방식
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30)
    -- FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) -- 테이블레벨방식
);

INSERT INTO MEM VALUES(1
                     , 'user01'
                     , 'pass01'
                     , '홍길동'
                     , 'G1'
                     , '남'
                     , '010-1234-1234'
                     , NULL);
                     
INSERT INTO MEM VALUES(2
                     , 'user02'
                     , 'pass02'
                     , '김갑생'
                     , 'G2'
                     , NULL
                     , NULL
                     , 'user02@naver.com');
                     
INSERT INTO MEM VALUES(3
                     , 'user03'
                     , 'pass03'
                     , '박말순'
                     , 'G3'
                     , '여'
                     , NULL
                     , NULL);

INSERT INTO MEM VALUES(4
                     , 'user04'
                     , 'pass04'
                     , '이순신'
                     , 'G4'
                     , NULL
                     , NULL
                     , NULL);
--> intefeity constraint (DDL.SYS_C007098) violated - parent key not found 오류 발생!!
--  부모 테이블로부터 없는 데이터를 INSERT 하고자 할 경우
--  PARENT KEY NOT FOUND 오류 발생!!
--  MEM_GRADE 테이블에 'G4' 라는 데이터가 없음에도 불구하고
--  외래키 제약조건이 걸린 GRADE_ID 컬럼에 'G4' 라는 값을 넣으려고 해서 오류가 발생함!!

INSERT INTO MEM VALUES(4
                     , 'user04'
                     , 'pass04'
                     , '김말똥'
                     , NULL
                     , '남'
                     , NULL
                     , NULL);
--> 외래키 제약조건이 걸려있는 컬럼에는 기본적으로 NULL 값이 들어갈 수 있다!!
--  만약, NULL 값이 못들어오게 막고 싶다면 추가적으로 NOT NULL 제약조건을 걸어준다!!

SELECT * FROM MEM_GRADE; -- GRADE_CODE
SELECT * FROM MEM;       -- GRADE_ID

-- 우리 회원들의 회원번호, 아이디, 이름, 등급명 을 보고 싶다면?
-->> 오라클 전용 구문
SELECT MEM_NO, MEM_ID, MEM_NAME, GRADE_NAME
  FROM MEM, MEM_GRADE
 WHERE GRADE_ID = GRADE_CODE(+);
 
-->> ANSI 구문
SELECT MEM_NO, MEM_ID, MEM_NAME, GRADE_NAME
  FROM MEM
  LEFT JOIN MEM_GRADE ON (GRADE_ID = GRADE_CODE);

SELECT * FROM MEM_GRADE; -- G1, G2, G3
SELECT * FROM MEM;       -- G1, G2, G3, NULL

-- MEM_GRADE 테이블로부터 GRADE_CODE 가 'G1' 인 데이터를 지운다면

-- 데이터를 삭제하는 구문 : DELETE
-- [ 표현법 ]
-- DELECT FROM 테이블명 WHERE 조건식;
DELETE
  FROM MEM_GRADE
 WHERE GRADE_CODE = 'G1';
--> integrity constraint (DDL.SYS_C007098) violated - child recode found 오류 발생!!
-- 자식데이터가 있는 상황에서 부모데이터를 지우면 CHILD RECORD FOUND 오류가 발생함
-- MEM 테이블의 GRAD_ID 컬럼에서 이미 'G1' 이라는 데이터를 사용하고 있기 대문에
-- MEM_GRADE 테이블의 'G1' 데이터를 삭제할 수 없게됨!!

/*
    * 자식 테이블 생성 시 (즉, 외래키 제약조건 부여 시점에서)
      부모데이터가 삭제되었을 때 자식데이터를 어떨게 처리할 건지 "옵션" 으로 지정 가능하다!!
      
    * FOREIGN KEY 삭제 옵션
    
    - 기본적으로 외래키 제약조건 부여 시 삭제 옵션을 별도로 제시하지 않으면
      "ON DELECT RESTRICTED" 로 지정됨!! (부모데이터 삭제 불가 - 삭제 제한 옵션)
      
    1) ON DELETE SET NULL : 부모데이터 삭제 시 해당 데이터를 사용하고 있는
                            자식데이터를 모두 NULL 로 변경시키는 옵션
    2) ON DELETE CASCADE : 부모데이터 삭제 시 해당 데이터를 사용하고 있는
                           자식데이터도 같이 삭제시키는 옵션
*/

-- 1) ON DELETE SET NULL
DROP TABLE MEM;

CREATE TABLE MEM (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2),
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL -- 테이블레벨방식
);

INSERT INTO MEM VALUES(1
                     , 'user01'
                     , 'pass01'
                     , '홍길동'
                     , 'G1'
                     , '남'
                     , '010-1234-1234'
                     , NULL);
                     
INSERT INTO MEM VALUES(2
                     , 'user02'
                     , 'pass02'
                     , '김갑생'
                     , 'G2'
                     , NULL
                     , NULL
                     , 'user02@naver.com');
                     
INSERT INTO MEM VALUES(3
                     , 'user03'
                     , 'pass03'
                     , '박말순'
                     , 'G3'
                     , '여'
                     , NULL
                     , NULL);

INSERT INTO MEM VALUES(4
                     , 'user04'
                     , 'pass04'
                     , '이순신'
                     , NULL
                     , NULL
                     , NULL
                     , NULL);
                     
-- 부모테이블로부터 'G1' 지우기
DELETE
  FROM MEM_GRADE
 WHERE GRADE_CODE = 'G1';
 
SELECT * FROM MEM_GRADE;

SELECT * FROM MEM;
--> 부모 데이터가 문제 없이 삭제됨!!
--  자식테이블의 데이터 해당 부분이 그대신 NULL 로 모두 대체됨!!

-- 데이터 복구 명령어
ROLLBACK;

SELECT * FROM MEM_GRADE;

DROP TABLE MEM;

-- 2) ON DELETE CASCADE
CREATE TABLE MEM (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GRADE_ID CHAR(2),
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(30),
    UNIQUE(MEM_ID),
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE -- 테이블레벨방식
    --> 테이블레벨방식도 여러개 기술 가능!!
);

INSERT INTO MEM VALUES(1
                     , 'user01'
                     , 'pass01'
                     , '홍길동'
                     , 'G1'
                     , '남'
                     , '010-1234-1234'
                     , NULL);

INSERT INTO MEM VALUES(2
                     , 'user02'
                     , 'pass02'
                     , '김갑생'
                     , 'G2'
                     , NULL
                     , NULL
                     , 'user02@naver.com');

INSERT INTO MEM VALUES(3
                      , 'user03'
                      , 'pass03'
                      , '박말순'
                      , 'G1'
                      , '여'
                      , NULL
                      , NULL);

INSERT INTO MEM VALUES(4
                     , 'user04'
                     , 'pass04'
                     , '이순신'
                     , NULL
                     , NULL
                     , NULL
                     , NULL);
                     
-- 부모데이터 삭제해보기 (G1)
DELETE
  FROM MEM_GRADE
 WHERE GRADE_CODE = 'G1';
 
SELECT * FROM MEM_GRADE;

SELECT * FROM MEM;
--> 부모데이터가 문제 없이 잘 삭제됨!!
--  해당 자식데이터들이 행 기준으로 모두 같이 삭제됨!!

--> ON DELETE CASCADE 옵션은 잘 쓰이지도 않고, 권장하지도 않음!!

/*
    참고)
    
    - 외래키 제약조건이 걸린 컬럼은 부모테이블과 JOIN 시 연결고리 역할을 한다!!
    
    - 그런데 굳이 외래키 제약조건이 걸려있지 않더라도 JOIN 가능함!!
      단, 두 컬럼에 동일한 의미의 (비슷한 결의) 데이터들이 담겨있어야만 가능해짐!!
      
    예) KH 계정의
    EMPLOYEE 테이블의 DEPT_CODE, JOB_CODE 컬럼에는 사실 외래키 제약조건이 걸려있지 않음!!
    그런데도 JOIN 이 잘만 됬었음!!
*/

ROLLBACK;

DROP TABLE MEM;

--------------------------------------------------------------------------------

/*
    ----- 여기서부터 실행은 KH 계정에서! -----
    
    * SUBQUERY 를 이용한 테이블 생성 (CREATE)
    
    - 메인 SQL 문을 보조 역할 해주는 SELECT 문을 서브쿼리라고 함!!
    - 메인 SQL 문의 종류로는 SELECT 문 뿐만 아니라 CREATE 문도 될 수 있다!!
    
    [ 표현법 ]
    CREATE TABLE 테이블명
    AS (서브쿼리)
    
    - 줄여서 CTAS (CREATE TABLE AS SUBQUERY) 라고 부름!!(SQLD)
    - 즉, 해당 서브쿼리를 수행한 결과 (RESULT SET) 를 통해
    새로이 테이블을 생성하는 개념 (테이블을 복사 뜨겠다)
*/

-- EMPLOYEE 테이블을 복제한 새로운 테이블 생성 (EMPLOYEE_COPY)
CREATE TABLE EMPLOYEE_COPY
AS (
        SELECT *
          FROM EMPLOYEE
);

SELECT * FROM EMPLOYEE_COPY;
--> 컬럼 구조, 조회결과들의 데이터들이 잘 복사됨!!
--  단, 제약조건의 경우에는 NOT NULL 제역조건만 복사된다!!
--  (나머지 제약조건들과 DEFAULT 설정은 복사가 안됨)

-- EMPLOYEE 테이블에 있는 컬럼의 구조만 복사하고 싶을 경우?
-- (데이터값은 복사하기 싫은 경우)
CREATE TABLE EMPLOYEE_COPY2
AS (
        SELECT *
          FROM EMPLOYEE 
         WHERE 1 = 0 -- 1 = 0 는 FALSE 를 의미함!! (아무것도 조회하지 않겠다)
);

SELECT * FROM EMPLOYEE_COPY2;

-- 전체 사원들 중 급여가 300만원 이상인 사원들의 
-- 사번, 이름, 부서코드, 급여 컬럼만 복제
CREATE TABLE EMPLOYEE_COPY3
AS (
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
          FROM EMPLOYEE
         WHERE SALARY >= 3000000
);

SELECT * FROM EMPLOYEE_COPY3;

-- 전체 사원의 사번, 사원명, 급여, 연봉 조회 결과를 테이블로 생성
CREATE TABLE EMPLOYEE_COPY4
AS (
        SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 "연봉"
          FROM EMPLOYEE
);
--> must name this expression with a column alias
--> 서브쿼리의 SELECT 절에 연산식 또는 함수식이 포함된 경우
--  반드시 별칭을 부여하고 넘어가야함!! (이 경우 그 별칭이 새로 만들어진 테이블의 컬럼명이 됨)

SELECT * FROM EMPLOYEE_COPY4;

/*
    * 테이블이 다 생성된 후 뒤늦게 제약조건을 추가하고자 한다면?
    
    [ 표현법 ]
    
    ALTER TABLE 테이블명 XXXXX;
                        (변경할내용)
                        
    - PRIMARY KEY : ADD PRIMARY KEY(컬럼명);
    - FROEIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할부모테이블명(참조할컬럼명);
    - UNIQUE : ADD UNIQUE(컬럼명);
    - CHECK : ADD CHECK (컬럼에대한조건식);
    - NOT NULL : MODIFY 컬럼명 NOT NULL;    
*/

-- EMPLOYEE_COPY 테이블에 없는 PRIMARY KEY 제약조건 추가
-- (EMP_ID 컬럼)
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE_COPY 테이블에 없는 FOREIGN KEY 제약조건 추가
-- (DEPT_CODE 컬럼 <--> DEPARTMENT 테이블의 DEPT_ID 를 참조_
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);

-- (JOB_CODE 컬럼 <--> JOB 테이블의 JOB_CODE 를 참조)
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);

-- DEPARTMENT 테이블의 LOCATION_ID 컬럼에 외래키 제약조건 추가
-- (LOCATION 테이블의 LOCAL_CODE 컬럼 참조
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE);

