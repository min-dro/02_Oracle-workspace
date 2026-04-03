/*
    < DDL - DATA DEFINITION LANGUAGE >
    
    - 데이터 정의 언어
    - 오라클 데이터를 이루는 OBEJCT (구조물) 을 새로이 생성 (CREATE) 하거나, 수정 (ALTER), 삭제 (DROP) 하는 구문들
    
    참고)
    UPDATE : 데이터 "내용" 을 수정
    DELETE : 데이터 "내용" 을 삭제
    
    ALTER : 테이블 "구조" 를 수정
    DROP : 테이블 "구조" (자체) 를 삭제
*/

/*
    1. ALTER
    
    - 객체 구조를 수정하는 구문
    
    < 테이블 수정 >
    
    ALTER TABLE 테이블명 수정할내용;
    
    - 수정할내용
    1) 컬럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제 => 제약조건은 수정은 불가함!! (수정하고 싶다면? 삭제 후 새로이 추가)
    3) 테이블명 / 컬럼명 / 제약조건명 수정
*/

-- 1) 컬럼 추가 / 수정 / 삭제

-- 1_1) 컬럼 추가 (ADD)
-- ADD 추가할컬럼명 자료형 DEFAULT 기본값
-- (단, DEFAULT 기본값 은 생략 가능)

SELECT * FROM DEPT_COPY;

-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
--> Table DEPT_COPY이(가) 변경되었습니다.

SELECT * FROM DEPT_COPY;
--> 새로운 컬럼이 만들어지고 기본적으로 NULL 값으로 채워짐

-- LNAME 컬럼 추가 (DEFAULT 지정해서)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';
--> Table DEPT_COPY(가) 변경되었습니다.

SELECT * FROM DEPT_COPY;
--> 새로운 컬럼이 만들어지고 NULL 이 아닌 DEFAULT 값으로 채워짐

-- 1_2) 컬럼 수정 (MODIFY)
-- 자료형 수정 : MODIFY 수정할컬럼명 바꿀자료형
-- DERAULT 값 수정 : 수정할컬럼명 DEFAULT 바꿀기본값

-- DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터타입을 CHAR(3) 으로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
--> Table DEPT_COPY이(가) 변경되었습니다.

-- 자료형 변경 시 주의사항
-- 현재 변경하고자 하는 컬럼에 이미 담긴 값과 완전히 다른타입으로는 변경 불가능!!
-- 예) 문자열 --> 숫자 (X)
--     문자열 사이즈 축소 (X)
--     문자열 사이즈 확대 (O)
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
--> column to be modified must be emptp to change datatype 오류 발생!!
-- 컬럼의 크기가 이미 담겨있는 값들과 아예 다른 경우 발생

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);
--> cannot decrease column length beacuse some value is too big 오류 발생!!
--  컬럼의 크기가 이미 담겨있는 값들 보다 적게 설정될 경우 발생

-- DEPT_COPY 테이블의 DEPT_TITLE 컬럼의 자료형을 VARCHAR2(40) 으로,
-- LOCATION_ID 컬럼의 자료형을 VARCHAR2(2) 로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40)
                      MODIFY LOCATION_ID VARCHAR2(2);
--> Table DEPT_COPY이(가) 변경되었습니다.
--> 한 테이블의 변경 내용이 여러개라면 위와 같이 줄줄이 바꿀내용만 연이어서 기술 가능함!!

-- LNAME 컬럼의 기본값을 '미국' 으로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';

SELECT * FROM DEPT_COPY;
--> DEFAULT 설정값이 수정되었더라도
--  이미 실제로 담기었던 컬럼값들은 변경되지 않음!!

-- 1_3) 컬럼 삭제 (DROP COLUMN)
-- DROP COLUMN 삭제할컬럼명

-- DEPT_COPY 테이블의 복사본 생성
CREATE TABLE DEPT_COPY2
AS(
        SELECT *
          FROM DEPT_COPY
);

SELECT * FROM DEPT_COPY2;

-- DEPT_COPY2 테이블의 DEPT_ID 컬럼 지우기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

SELECT * FROM DEPT_COPY2;

-- 복구
ROLLBACK;

SELECT * FROM DEPT_COPY2;
--> DDL 구문은 복구 불가능!!

-- 다른 컬럼들도 없애보기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;

ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
--> SQL command not properly ended
--  DROP COLUME 옵션은 하나씩 써야만 한다!! (두개 이상 묶어서 못씀)

ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
--> cannot drop all columns in a table
--  마지막 컬럼 삭제만 오류 발생!!
--  테이블에 최소 한개의 컬럼은 남아있어야함!!
    
SELECT * FROM DEPT_COPY2;

-- 2) 제약조건 추가 / 삭제

/*
    2_1) 제약조건 추가 (ADD)
    
    - PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    
    - FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할부모테이블명(참조할컬럼명)
    
    - UNIQUE : ADD UNIQUE(컬럼명)
    
    - CHECK : ADD CHECK(컬럼명에대한조건식)
    
    - NOT NULL : MODIFY 컬럼명 NOT NULL;
    
    => 이 때 제약조건명까지 추가하고 싶다면
       제약조건 앞에 (ADD 뒤에) CONSTRAINT 제약조건명 까지 추가하면 된다!!      
    => 제약조건명을 추가할 경우, 한 계정 내에서 중복되지 않게 이름을 추가해야함!!
    => 이미 해당 컬럼에 들어있는 값들에 대해서 알맞은 제약조건으로 추가해야함!!
*/

-- DEPT_COPY 테이블에
-- DEPT_ID 컬럼레 PRIMARY KEY 제약조건 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID);

-- DEPT_TITLE 컬럼에 UNIQUE 제약조건 추가
-- LNAME 컬럼에 NOT NULL 제약조건 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
                      MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;
--> 제약조건 추가는 한번에 가능!!

-- 주의할 점
--> 제약조건명은 한 계정 내에서 중복 불가!!
ALTER TABLE DEPARTMENT ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE);
--> name already used byt an existing constraint
--  아무리 다른 테이블이더라도 한 계정 내에서는 제약조건명 중복 불가!!

--> 이미 해당 컬럼에 들어있는 값들 기준으로 제약조건을 추가해야함!!
ALTER TABLE DEPT_COPY MODIFY CNAME NOT NULL;
--> cannot enable (KH.) - null values found
--  이미 NULL 값들이 존재하기 때문에 NOT NULL 제약조건 추가 불가!!

ALTER TABLE DEPT_COPY ADD UNIQUE(LOCATION_ID);
--> cannot vaildate (KH.SYS_C007151 - duplicate keys found
-- 이미 중복된 값들이 존재하기 때문에 UNIQUE 제약조건 추가 불가

-- 예) DEPT_COPY 테이블에 PRIMARY KEY 제약조건 추가 불가
--     왜? 한 테이블 당 PRIMARY KEY 제약조건은 오직 한개여야함!!

/*
    2_2) 제약조건 삭제 (DROP CONSTRAINT)
    
    - PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK : DROP CONSTRAINT 제약조건명
    
    - NOT NULL : MODIFY 컬럼명 NULL
*/

-- DCOPY_PK 제약조건 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

-- DEPT_COPY 테이블로부터
-- DCOPY_UQ 제약조건 삭제
-- DCOPY_NN 제약조건 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_UQ
                      MODIFY LNAME NULL;
                      
-- NOT NULL 제약조건 삭제 시에도 사실 제약조건명으로 삭제 가능!!
ALTER TABLE DEPT_COPY DROP CONSTRAINT SYS C007142;

-- 3) 컬럼명 / 제약조건명 / 테이블명 수정 (RENAME)

-- 3_1) 컬럼명 수정
-- RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 주의할 점
ALTER TABLE DEPT_COPY RENAME COLUMN LNAME TO CNAME;
--> duplicate column name
--  한 테이블 내에서 중복된 컬럼명으로 수정 불가!!

-- 3_2) 제약조건명 수정
-- RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007266 TO DCOPY_LID_NN;

-- 주의할 점
--> 한 계정 내에서 중복된 제약조건명으로 수정 불가!!

-- 3_3) 테이블명 수정
-- RENAME TO 바꿀테이블명
-- (이미 앞에 ALTER TABLE 테이블명 이 기술되어있기 때문)
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

SELECT * FROM DEPT_COPY;
--> table or view does not exist

SELECT * FROM DEPT_TEST;
--> 바뀐 테이블명으로 잘 조회됨!!

-- 주의사항
-- 한 계정 내에 이미 존재하는 테이블명으로 변경 불가!!

--------------------------------------------------------------------------------

/*
    2. DROP
    
    - 오라클 객체 (구조물) 을 삭제하는 구문
    
    - 테이브을 삭제하고 싶다면?
    DROP TABLE 테이블명;
    
    - 계정을 삭제하고 싶다면?
    DROP USER 계정명;
    
    ...
*/

-- DEPT_TEST 테이블 삭제
DROP TABLE DEPT_TEST;
--> Table DEPT_TEST이(가) 삭제되었습니다.

SELECT * FROM DEPT_TEST;
--> table or view does not exist

ROLLBACK;

SELECT * FROM DEPT_TEST;
--> DROP 구문 또한 ROLLBACK 불가!!

-- DELETE FROM 테이블명; 과의 차이점
--> 테이블 구조는 그대로 두고, 그 안에 들은 데이터들도 함께)
--  SELECT 문으로 조회 가능 (단, 공집합으로 나옴)

-- DELETE FROM 테이블명; 은
--> 테이블 구조 자체를 날려버리겠다. (그 안에 들은 데이터들도 함께)
--  SELECT 문으로 조회 불가 (TABLE OR VIEW DOES NOT EXIST)

-- DROP TABLE 시 주의사항
--> 어딘가에서 참조되고있는 "부모테이블" 은 삭제되지 않는다. (외래키 이슈)
--> 만약에 삭제하고 싶다면?
-- 1. 자식테이블을 먼저 삭제한 후 부모테이블을 삭제하는 방법
-- DROP TABLE 자식테이블명;
-- DROP TABLE 부모테이블명;

-- 참고)
-- 항상 CREATE 시에는 부모테이블을 먼저 생성해야함!!
-- 항상 DROP 시에는 자식테이블을 먼저 삭제해야함!!

-- 2. 부모테이블만 삭제하되, 맞물려있는 제약조건을 같이 삭제하는 방법
-- (자식테이블과 자식데이터도 살아있을 것!!)
-- DROP TABLE 부모테이블명 CASCADE CONSTRAINT;

--> ALTER, DROP 은 최대한 안쓰는 것이 제일 좋음!!
--  그러기 위해서는 테이블을 생성하기 전에 설계부터 제대로 하고 들어가면 됨!!