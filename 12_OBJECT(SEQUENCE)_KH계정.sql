/*
    < SEQUENCE 시퀀스 >
    
    - 자동으로 번호를 발생시켜주는 역할을 하는 객체
    - 정수값을 자동으로 "순차적으로" 발생시켜줌 (생성해줌)
    
    예) 회원번호, 사번, 게시글 번호 등
        PRIMARY KEY 역할을 할 정수값을 "채번" 할 때 많이 사용한다.
        
    1. 시퀀스 객체 생성 구문
    
    [ 표현법 ]
    
    CREATE SEQUENCE 시퀀스명
    START WITH 시작수          => 처음 발생시킬 시작값 지정
    INCREMENT BY 증가값        => 몇 씩 증가시킬건지 결정
    MAXVALUE 최대값            => 최대값 지정
    MINVALUE 최소값            => 최소값 지정
    CYCLE/NOCYCLE             => 값 순환 여부 지정
    CACHE 바이트크기/NOCACHE   => 캐시메모리 사용 여부 지정
                                 CASHE_SIZE 기본값은 20BYTE
    
    - 위의 옵션들은 모두 생략 가능함!!
    
    * 캐시메모리
    - 미리 앞으로 발생될 정수값을 생성해서 저장해두는 공간
    - 매번 호출할 때 마다 새로이 번호를 생성해서 주는 것 보다
      캐시메모리라는 공간에 미리 생성된 번호를 저장해두고 바로 꺼내다 주면 훨씬 속도가 빨라짐!!
    - 단, 해당 계정의 접속이 끊기고 나서 재접속 후에는
      기존 캐시메모리에 저장된 정수값들이 날아가고 없어짐!!
*/

/*
    참고) 오라클의 접두사 - 명명규칙 관련
    
    - 테이블명 : TB_XXX
    - 뷰명 : VW_XXX
    - 시퀀스명 : SEQ_XXX
*/

CREATE SEQUENCE SEQ_TEST;
--> Sequence SEQ_TEST이(가) 생성되었습니다.

-- 시퀀스가 제대로 만들어졌는지 확인해보기
-- 1. 접속 탭에서 직접 확인해보기
-- 2. USER_SEQUENCES 라는 데이터 딕셔너리를 통해서도 확인 가능
-- USER_SEQUENCES : 현재 접속한 이 계정이 가지고 있는 시퀀스들에 대한 정보들이 저장되는 데이터 딕셔너리
SELECT *
  FROM USER_SEQUENCES;

-- 옵션을 생략한 경우
-- START WITH 값은 1, MINVALUE 값도 1, MAXVALUE 값은 999999..., INCREMENT BY 값은 1
-- NOCYCLE, CAHCHE 20BYTE 가 기본값임!!

-- 이번에는 옵션을 조합해서 생성해보기
-- 한 계정 내에서 동일한 이름의 시퀀스는 중복 존재 불가!!
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
--> Sequence _EMPNO이(가) 생성되었습니다.

--------------------------------------------------------------------------------

/*
    2. 시퀀스 사용 방법
    
    - 시퀀스명.CURRVAL
      CURRENT VALUE 의 약자 (현재의 값)
      현재 시퀀스의 값
      마지막으로 성공적으로 발생된 NEXTVAL 값이 저장되는 변수
      
    - 시퀀스명.NEXTVAL
      NEXT VALUE 의 약자 (다음의 값)
      다음 번호를 발생시켜주는 구문 (즉, 번호를 하나 뽑아달라 라는 뜻)
      기존의 시퀀스 값에서 INCREMENT BY 만큼 증가된 값을 리턴
      즉, 시퀀스명.CURRVAL + INCREMENT BY 값
*/

-- 위에서 생성한 시퀀스의 번호값을 발생시키고, 단순히 출력해보고 싶음!!
-- (DUAL 테이블을 통해 정수를 간단히 출력해보자)
SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL;
--> sequence SEQ_EMPNO.CURRVAL is not yet defined in this session 오류 발생!!
--> 시퀀스 객체 생성 (CREATE) 후 단 한번이라도 NEXTVAL 을 수행하지 않았다면
--  CURRVAL 구문을 수행할 수 없다!!
--> CURRVAL 은 마지막으로 성공적으로 수행된 NEXTVAL 값을 담는 변수임!!
--  (NEXTVAL 구문이 한번이라도 실행되기 전에는 CURRVAL 이라는 변수가 아직 정의 되지 않음)

SELECT SEQ_EMPNO.NEXTVAL
  FROM DUAL; -- 300
--> NEXTVAL 로 최초 번호 발생 시 START WITH 값부터 발생된다!!
--  300 이라는 정수값이 발생되고 나서 CURRVAL 이라는 변수에 담기는 것 까지 진행됨!!

SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL; -- 300
  
SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL;
--> 다음 NEXTVAL 구문이 실행되기 전까지는 계속 CURRVAL 은 300일 것임!!

SELECT SEQ_EMPNO.NEXTVAL
  FROM DUAL; -- 305
--> 현재 CURRVAL 값 300 _ INCREMENT BY 값인 5 = 305 가 발생됨!!
--  이렇게 발생된 305 가 CURRVAL 이라는 변수에 담기는 것 까지 수행됨!!

SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL; -- 305
  
-- 데이터 딕셔너리를 통해 시퀀스 정보를 재확인
SELECT * 
  FROM USER_SEQUENCES;
--> LAST_NUMBER 속성값 : 310 을 가리키고 있음!!
--                      현재 시점에서 NEXTVAL 을 수행할 경우의 예상 값

SELECT SEQ_EMPNO.NEXTVAL
  FROM DUAL; -- 310
--> 이 시점 기준으로 CURRVAL 은 310 이 담겨있을 것!!

SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL; -- 310

SELECT *
  FROM USER_SEQUENCES;
--> 이 시점 기준으로 LAST_NUMBER 는 315

SELECT SEQ_EMPNO.NEXTVAL
  FROM DUAL;
--> sequence SEQ_EMPNO.NEXTVAL exceed MAXVALUE and cannot be instantiated 오류 발생!!
--> 지정한 MAXVALUE 값인 310 을 초과했기 때문에 번호 발생이 불가해짐!!

-- 퀴즈)
-- 이 시점에서 CURRVAL 을 출력한다면?
--> "마지막" 으로 "성공적으로" (오류 없이 수행되었다) 수행된 NEXTVAL 값이 담기므로
--  310 이 담겨있고, 출력된다!!
SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL; -- 310
  
--------------------------------------------------------------------------------
  
/*
    3. 시퀀스 변경
    
    [ 표현법 ]
    
    ALTER SEQUENCE 시퀀스명
    INCREMENT BY 증가값        => 몇 씩 증가시킬건지 변경
    MAXVALUE 최대값            => 최대값 변경
    MINVALUE 최소값            => 최솟값 변경
    CYCLE/NOCYCLE             => 값의 순환 여부 변경
    CAHCE 바이트크기/NOCACHE   => 캐시메모리 사용 여부 변경
    
    - 모든 옵션은 생략 가능 (생략 시 기본값으로 변경됨)
    - START WITH 는 변경 불가!!
      정 바꾸고 싶다면 해당 시퀀스 객체를 삭제했다가 (DROP) 다시 생성 (CREATE) 해야 함
*/

-- SEQ_EMPNO 을 변경
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;
--> Sequence SEQ_EMPNO이(가) 변경되었습니다.

-- 데이터 딕셔너리로 재확인
SELECT * 
  FROM USER_SEQUENCES;
--> 잘 변경이 되었고, 특히 INCREMENT BY 값이 5 에서 10 으로 변경되면서
-- 그에 따라 LAST_NUMBER 값이 315 에서 320 을 가리키고 있게됨!!

SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL; -- 310
  
SELECT SEQ_EMPNO.NEXTVAL
  FROM DUAL; -- 320
  
--> 이 시점 기준으로 SEQ_EMPNO.CURRVAL 을 수행하면 320 이 나옴!!
--> 이 시점 기준으로 데이터 딕셔너리의 LAST_NUMBER 는 330 을 가리킴!!

-- 주의할 점
-- 시퀀스명.NEXTVAL 은 못되돌림!! 후진이 안됨!!

-- SEQUENCE 를 삭제하고 싶다면?
-- [ 표현법 ]
-- DROP SEQUENCE 시퀀스명;
DROP SEQUENCE SEQ_EMPNO;
--> Sequence SEQ_EMPNO이(가) 삭제되었습니다/

SELECT SEQ_EMPNO.CURRVAL
  FROM DUAL;
--> sequence does not exist 오류 발생!!
--  없는 시퀀스로 CURRVAL 이나 NEXTVAL 을 수행할 수 없게 됨!!

----- 시퀀스가 사용되는 예시 -----

-- EMPLOYEE 테이블에 사원 정보를 추가하는 기능 구현 중...

-- 사원이 매번 추가될 때 마다
-- 사번 (EMP_ID) 을 새롭게 발생시키는 시퀀스를 생성해보기
CREATE SEQUENCE SEQ_EID
START WITH 300;
--> Sequence SEQ_EID이(가) 생성되었습니다.

-- 사원이 추가될 때마다 실행할 INSERT 문
INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , '홍길동'
                          , '991111-1234321'
                          , 'user02@naver.com'
                          , '01045678912'
                          , NULL
                          , 'J7'
                          , 'S5'
                          , 2000000
                          , NULL
                          , 201
                          , SYSDATE
                          , NULL
                          , DEFAULT);
--> 1 행 이(가) 삽입되었습니다.

INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , '고영희'
                          , '970103-2987654'
                          , 'user01@gmail.com'
                          , '010178901234'
                          , NULL
                          , 'J7'
                          , 'S5'
                          , 2000000
                          , NULL
                          , 201
                          , SYSDATE
                          , NULL
                          , DEFAULT);
--> 1행 이(가) 삽입되었습니다.

INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , '박말순'
                          , '890319-1789012'
                          , 'user03@gmail.com'
                          , NULL
                          , NULL
                          , 'J7'
                          , 'S5'
                          , 2900000
                          , NULL
                          , 201
                          , SYSDATE
                          , NULL
                          , DEFAULT);
--> 1 행 이(가) 삽입되었습니다.    

--> 주로 SEQUENCE 는 INSERT 문 내부에서
--  컬럼값을 자동 발생시켜서 넣고자 할 때 많이 쓰임!!
--  예) 사번, 학번, 게시글번호 등등 (주로 PRIMARY KEY 와 엮어서 쓰임)

-- 위의 과정들에서 가원이 추가될 때 마다 실행되는
-- INSERT 구문의 규칙을 찾아보자면...
INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , SYSDATE
                          , NULL
                          , DEFAULT);
--> 언제 누가 입사할 지 모르기 떄문에,
--  실제 입사할 사원의 인적사항 부분 이름 ~ 사수사번 까지는 ? 로 구멍을 뚫어둠!!
--> 실제 누군가가 입사하면 그 정보에 맞게 ? 부분만 채워서 실행기키면 됨!!
--  (우리는 이 ? 부분을 키보드로 직접 입력해서 넣어 줄 예정)

--> JDBC 시간에 이런 식으로 활용할 예정!!