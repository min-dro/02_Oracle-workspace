/*
    * SQL (Structured Query Language)
    
    > 구조화된 질의 언어
    > DBMS 에서 사용되는 명령문들을 "SQL문" 내지 "쿼리문" 이라고 한다.
    
    [ 종류 ]
    DQL - Data Query Language (데이터 조회 용도)
          SELECT (데이터 조회)
    DML - Data Manipulation Language (데이터 조작 용도)
          INSERT (데이터 추가), UPDATE (데이터 수정), DELETE (데이터 삭제)
          참고) SELECT 문도 굳이 DQL 로 분류하지 않고 DML 로 간주하는 경우가 많다!!
    DDL - Data Definition Language (데이터 정의 용도)
          CREATE (데이터베이스 구조물 생성),
          ALTER (데이터베이스 구조물 수정),
          DROP (데이터베이스 구조물 삭제)
    DCL - Data Control Language (데이터 제어 용도)
          DQL, DML, DDL 을 제외한 나머지 명령문들을 모두 DCL 로 분류한다.
          GRANT (권한 부여), REVOKE (권한 뺏기)
    TCL - Transaction Control Language (트랜잭션 제어 용도)
          DCL 의 하위 분류임!!
          COMMIT (데이터 조작 결과 픽스),
          ROLLBACK (데이터 조작 결과 복구),
          SAVEPOINT (데이터 조작 흐름의 중간 저장점 잡기)
*/

/*
    < SELECT >
    
    - DQL 또는 DML 의 종류로써,
      테이블로부터 데이터를 조회하거나 검색할 때 사용되는 명령어 (데이터 추출)
      
    - RESULT SET : SELECT 문을 통해 조회된 데이터들의 결과물을 의미
    
    [ 표현법 ]
    
    SELECT 조회하고자하는컬럼명, 컬럼명, 컬럼명        -- SELECT 절 
      FROM 테이블명;                                -- FROM 절
*/

-- EMPLLOYEE 테이블의
-- 전체 사원들의 사번, 이름, 급여 컬럼만을 조회
SELECT EMP_ID, EMP_NAME, SALARY
  FROM EMPLOYEE;
  
select emp_id, emp_name, salary
  from employee;
--> SQL 명령문들은 대소문자를 가리지 않음!!
--  소문자로 써도 무방
--  단, 가독성을 위해 대문자로 써버릇 하자!!
--  참고) 자바는 대소문자를 구분했었음!!
--  empId, empName, empNo, : 낙타 표기법 (camel case)
--  오라클은 대소문자를 구분하지 않음!!
--  EMP_ID, EMP_NAME, EMP_NO : (snake case)

-- EMPLOYEE 테이블로부터
-- 전체 사원들의 모든 컬럼들을 다 조회
SELECT EMP_ID
     , EMP_NAME
     , EMP_NO
     , EMAIL
     , PHONE
     , DEPT_CODE
     , JOB_CODE
     , SAL_LEVEL
     , SALARY
     , BONUS
     , MANAGER_ID
     , HIRE_DATE
     , ENT_DATE
     , ENT_YN
  FROM EMPLOYEE;
  
SELECT *
  FROM EMPLOYEE;
--> 해당 테이블의 "모든" 컬럼을 조회하고 싶다면
--  위의 구문처럼 일일이 컬럼명들을 다 나열해도 되지만,
--  SELECT * 을 통해 구문을 축약할 수 있다!! (반드시 모든 컬럼을 조회할 경우에만 사용)

----- 실습문제 -----
-- 1. JOB 테이블의 모든 컬럼 조회
-- SELECT JOD_CODE, JOB_NAME
SELECT *
  FROM JOB;
  
-- 2. JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME
  FROM JOB;

-- 3. DEPARTMENT 테이블의 모든 컬럼 조회
-- SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
SELECT *
  FROM DEPARTMENT;

-- 4. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 입사일 컬럼만 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
  FROM EMPLOYEE;

-- 5. EMPLOYEE 테이블의 입사일, 직원명, 급여 컬럼만 조회
SELECT HIRE_DATE, EMP_NAME, SALARY
  FROM EMPLOYEE;
  
--------------------------------------------------------------------------------

/*
    <컬럼값을 통한 산술연산>
    
    - 조회하고자 하는 컬럼값을 나열하는 SELECT 절에 숫자 형태의 컬럼값들에 대해
      산술연산자 (+/*) 를 기술하여 결과를 조회할 수 도 있다.
*/

--  EMPLOYEE 테이블롤부터 직원명, 월급, 연봉 (= 월급 * 12)
SELECT EMP_NAME, SALARY, SALARY * 12
  FROM EMPLOYEE;
--> EMPLOYEE 테이블에 연봉 컬럼을 안만든 이유
--  왜? 월급은 유동적인 값임!! 월급에 따라서 연봉 또한 유동적으로 바뀜
--  만약 연봉컬럼까지 있었다면, 매년 월급이 오를 때 월급 칼럼값을 수정함과 동시에
--  일일이 매번 연봉컬럼값까지 다 수정을 해줘야함!!
--> 이 때, 연봉을 나타내는 컬럼을 만들 구는 있고, 만든다고 한다면 연봉 컬럼을 "파생 컬럼" 이라고 한다.
--  설계 측면에서 파생 컬럼은 되도록 만들지 말 것!!

--  EMPLOYEE 테이블로부터 직원명, 월급, 보너스, 보너스가 포함된 연봉 (= ((월급 * 보너스) + 월급) * 12)
SELECT EMP_NAME
     , SALARY
     , BONUS
     , ((SALARY * BONUS) + SALARY) * 12
  FROM EMPLOYEE;
--> 산술 연산 과정에서 NULL 값이 존재할 경우 그 산술 연산 결과 마저도 NULL 로 나옴!!

--  EMPLOYEE 테이블로부터 직원명, 입사일, 근무일수 (= 오늘날짜 - 입사일)
--  DATE 타입(날짜 타입 - 년, 월, 일, 시, 분, 초) 끼리도 산술 연산이 가능!!
--  오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
  FROM EMPLOYEE;
--> 결과값은 일 수 단위로 출력됨!!
--  값이 지저분하게 실수로 나오는 이유는 DATE 타입 안에 포함되어있는 시, 분, 초 에 대한 연산까지 함꼐 수행하기 때문

--------------------------------------------------------------------------------

/*
    < 컬럼명에 별칭 지정하기 >
    
    - 조회 시 컬럼명에 별칭 (ALIAS, 별명) 을 붙여줄 수 있다.
    
    [ 표현법 ]
    
    SELECT 컬럼명 AS 별칭
         , 컬럼명 AS "별칭"
         , 컬럼명 별칭
         , 컬럼명 "별칭"
      FROM 테이블명;
      
    - 단, AS 를 붙이든 안붙이든 간에
      별칭 안에 특수문자나 띄어쓰기가 포함된 경우에는 반드시 "" (쌍따옴표) 로 묶어서 표기해야함!!
    - 별칭을 너무 길게 붙이면 오류남!! 주의!!
*/

--  EMPLOYEE 테이블로부터 직원명, 급여(월), 보너스, 총 소득(보너스를 포함한 연봉)
SELECT EMP_NAME AS 직원명
     , SALARY AS "급여(월)"
     , BONUS "보너스"
     , ((BONUS * SALARY) + SALARY) * 12 AS "총 소득"
  FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 리터럴 >
    
    - 리터럴은 "값" 을 의미함 (값을 고급지게 부르는 단어가 리터럴)
    
    - SELECT 절에 일반 리터럴을 대놓고 제시하여 실제 그 테이블에 존재하는 데이터 처럼 조회가 가능하다.    
*/

--  EMPLOYEE 테이블로부터 사번, 사원명, 급여, 단위(원) 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' 단위
  FROM EMPLOYEE;
--> 오라클에서는 문자와 문자열의 차이가 없음!!
--  (한글자 짜리든 여러글자 짜리든 간에 문자열타입으로 동일해서 취급함)
--  참고로 오라클에서의 문자열은 '' (홑따옴표) 로 감싸서 표현함!!
--> SELECT 절에 제시한 리터럴 값은
--  조회 결과인 RESULT SET 의 모든 행에 반복적으로 출력됨

--------------------------------------------------------------------------------

/*
    < DISTINCT >
    
    - 조회하고자 하는 컬럼의 중복된 값을 딱 한번씩만 조회하고 싶을 때 사용
    
    - 즉, 중복 제거의 역할
      (실제 데이터를 지우겠다가 아닌 조회 시에 편의상 한번씩만 보여주겠다)
    
    [ 표현법 ]
    
    SELECT DISTINCT 컬럼명
      FROM 테이블명;
      
    - 단 해당 컬럼명 앞에 기술하되,
    SELECT 절에서는 DISTINCT 구문을 단 한번만 사용 가능함!!
*/

--  EMPLOYEE 테이블로부터 부서코드를 조회
SELECT DISTINCT DEPT_CODE
  FROM EMPLOYEE;
  
--  EMPLOYEE 테이블로부터 직급코드를 조회
SELECT DISTINCT JOB_CODE
  FROM EMPLOYEE; -- 7개조회

--  EMPLOYEE 테이블로부터 부서코드, 직급코드를 조회
SELECT DISTINCT DEPT_CODE, JOB_CODE
  FROM EMPLOYEE;
--> DISTINCT 를 한번만 쓸 수 있는 이유라고 한다면
--  만약 두번 이상 쓰게 될 경우 각 컬럼별 중복 제거 결과의 갯수가 다르게 나올 것임!!
--  7행, 5행, 6행, ..
--  오라클에서는 테이블이든, RESULT SET 이든 간에 항상 오와 열이 맞아야함!!
--  행의 갯수가 서로 안맞아서 삐뚤빼뚤한 경우를 방지하기 위해 문법 상 막아둔 것!!
--> DISTINCT 를 한번만 쓰면 뒤에 나열한 여러개의 컬럼값들을 세트로 묶어서 중복 판별을 해줌!!

--------------------------------------------------------------------------------

/*
    < WHERE 절 >
    
    - SELECT 문 내부에서 조회하고자 하는 테이블에
    "특정 조건" 을 제시해서 그 조건에 만족되는 행들만을 조회하고자 할 때 기술하는 구문
    
    [ 표현법 ]
    
    SELECT 조회하고자하는, 컬럼명, ..
      FROM 테이블명
    WHERE 조건식; -- 연산 결과가 TRUE 아니면 FALSE 로 나오는 식
    
    - SELECT 문의 필수 구성 절 : SELECT 절, FROM 절
      (WHERE 절이 없다고 해서 SELECT 문에 오류가 나지는 않음)
      
    * SELECT 문의 각 절의 실행 순서
    FROM 절 --> WHERE 절 --> SELECT 절(SQLD 시험에 잘 나옴)
*/

/*
    - WHERE 절의 조건식에는 다양한 연산자들 사용 가능!!
    
    < 비교 연산자 >
    
    >, <, >=, <= : 크고 작음을 비교
    = : 일치함을 비교 (자바에서의 동등비교는 ==) :
    !=, ^=, <> : 일치하지 않음을 비교(SQLD에 나옴)
*/

--  EMPLOYEE 테이블로부터
--  급여가 400만원 이상인 사원들의 모든 컬럼을 조회
SELECT *
  FROM EMPLOYEE
 WHERE SALARY >= 4000000; -- 2명

--  EMPLOYEE 테이블로부터
--  부서코드가 D9 인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9'; -- 3명

--  EMPLOYEE 테이블로부터
--  부서코드가 D9 가 아닌 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
-- WHERE DEPT_CORE != 'D9'; -- 18명
-- WHERE DEPT_CORE ^= 'D9'; -- 18명
 WHERE DEPT_CODE ^= 'D9'; -- 18명

--> 총 사원은 23명인데, D9 부서인 사람 3명, 아닌 사람이 18 명 조회됨
--  나머지 2명은? 부서코드가 NULL 인 2명을 의미함!!

--> 비교 연산 시 NULL 값은 제외하고 연산됨!!(SQLD 시험에 나옴)

----- 실습문제 -----
-- 1. EMPLOYEE 테이블로부터
-- 급여가 300만원 이상인 사원들의 이름, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
  FROM EMPLOYEE
 WHERE SALARY >= 3000000;
 
-- 2. EMPLOYEE 테이블로부터
-- 직급코드가 J2 인 사원들의 이름, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS
  FROM EMPLOYEE
 WHERE JOB_CODE = 'J2';
 
-- 3. EMPLOYEE 테이블로부터
-- 현재 재직중인 사원들의 사번, 이름, 입사일 조회
-- 힌트) ENT_YN 컬럼값 주의!!
SELECT EMP_ID, EMP_NAME, HIRE_DATE
  FROM EMPLOYEE
 WHERE ENT_YN = 'N';
 
-- 4. EMPLOYEE 테이블로부터
-- 연봉 (= 급여 * 12) 이 5000만원 이상인 사원들의 이름, 급여, 연봉, 입사일 조회
SELECT EMP_NAME, SALARY, SALARY * 12 "연봉", HIRE_DATE
  FROM EMPLOYEE
 WHERE (SALARY * 12) >= 50000000;
-- WHERE 연봉 >= 50000000; -- 불가!!
--> SELECT 절에서 부여한 별칭을 WHERE 절에서 사용할 수 없다.
-- 왜? WHERE 절이 SELECT 절 보다 먼저 실행되기 때문임!!

--------------------------------------------------------------------------------

/*
    < 논리 연산자 >
    
    - 여러개의 조건식을 하나로 엮을 때 사용
    
    [ 종류 ]
    
    - AND : ~ 이면서, 그리고, ~ 이고 (자바에서는 &&)
    - OR : 또는, ~ 이거나 (자바에서는 ||)
    
    - AND 연산자가 OR 연산자보다 우선순위가 더 높다!! (다른 언어들도 마찬가지)
*/

-- EMPLOYEE 테이블로부터
-- 부서코드가 D9 이면서 급여가 500만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9' AND (SALARY >= 5000000);
 
-- EMPLOYEE 테이블로부터
-- 부서코드가 D6 이거나 급여가 300만원 이상인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE (DEPT_CODE = 'D6') OR (SALARY >= 3000000);
 
-- EMPLOYEE 테이블로부터
-- 급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALARY, JOB_CODE
  FROM EMPLOYEE
 WHERE (3500000 <= SALARY) AND (SALARY <= 6000000);
 
--------------------------------------------------------------------------------

/*
    < BETWEEN AND >
    
    - 몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 사용
    
    [ 표현법 ]
    
    비교대상컬럼명 BETWEEN 하한값 AND 상한값
    
    - 해석은 하한값 이상 상한겂 이하로 해주면 됨!!
*/

-- EMPLOYEE 테이블로부터
-- 급여가 350만원 이상이고 600만원 이하인 사원들의 이름, 사번, 급여, 직급코드 조회
SELECT EMP_NAME, EMP_ID, SALART, JOB_CODE
  FROM EMPLOYEE
-- WHERE (3500000 <= SALARY) AND (SALARY <= 6000000);
 WHERE SALARY BETWEEN 3500000 AND 6000000;
 
-- EMPLOYEE 테이블로부터
-- 급여가 350만원 미만이거나 600만원 초과인 사원들의 이름, 세번, 급여, 직급코드 조회
SELECT EMP_NAME, SALARY, JOB_CODE
  FROM EMPLOYEE
-- WHERE (3500000 > SALARY) OR (SALARY > 6000000);
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
 WHERE SALARY NOT BETWEEN 3500000 AND 6000000; 
--> NOT 은 논리부정연산자임!! (자바로 따지면 !)
--  위치는 컬럼명 앞이든 뒤는 상관 없이 사용 가능!!

-- EMPLOYEE 테이블로부터
-- 입사일이 '90/01/01' ~ '03/01/01' 인 사원들의 모든 컬럼 조회
SELECT *
  FROM EMPLOYEE
-- WHERE ('90/01/01' <= HIRE_DATE) AND HIRE_DATE <= '03/01/01';
 WHERE HIRE_DATE BETWEEN '90/01/01' AND '03/01/01';
--> 날짜 간의 대소비교 연산이 가능하고, 그에 따라 이상, 이하 조건이라면 BETWEEN AND 연산시 또한 활용 가능!!

-- EMPLOYEE 테이블로부터
-- 입사일이 '90/01/01' ~ '03/01/01' 사이가 아닌 사원들의 모든 컬럼 조회
SELECT *
  FROM EMPLOYEE
 WHERE /* NOT */ HIRE_DATE NOT BETWEEN '90/01/01' AND '03/01/01';
 
--------------------------------------------------------------------------------

/*
    < LIKE '특정 패턴' >
    
    - 비교하려는 컬럼값이 내가 지경한 '특정 패턴' 에 만족될 경우 조회
    
    [ 표현법 ]
    
    비교대상컬럼명 LIKE '특정 패턴'
    
    - '특정 패턴' 에는 와일드 카드인 '%', '_' 을 가지고 제시 가능!!
        
    '%' : 0 글자 이상
          비교대상컬럼명 LIKE '문자%'
          - 컬럼값 중에 '문자' 로 시작되는 것들을 모두 조회하겠다
          비교대상컬럼명 LIKE '%문자'
          - 컬럼값 중에 '문자' 로 끝나는 것들을 모두 조화하겠다
          비교대상컬럼명 LIKE '%문자'
          - 컬럼값 중에 '문자' 가 포함되는 것들을 모두 조회하겠다
            (특히 '%문자%' 패턴은 검색 기능 구현 시 많이 쓰임)
                
    '_' : 딱 1글자
          비교대상컬럼명 LIKE '_문자'
          - 컬럼값 중에 '문자' 앞에 무조건 1글자가 있을 경우
          비교대상컬럼명 LIKE '문자_'
          - 컬럼값 중에 '문자' 뒤에 무조건 1글자가 있을 경우
          비교대상컬럼명 LIKE '__문자'
          - 컬럼값 중에 '문자' 앞에 무조건 2글자가 있을 경우
*/

-- EMPLOYEE 테이블로부터
-- 성이 정씨인 사원들의 이름, 급여 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '정%';
 
-- EMPLOYEE 테이블로부터
-- 이름 중에 '민' 이 포함된 사원들의 이름, 주민번호, 부서코드 조회
SELECT EMP_NAME, EMP_NO, DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '%민%';
 
-- EMPLOYEE 테이블로부터
-- 전화번호 4번째 자리가 9 로 시작하는 사원들의 사번, 사원명, 전화번호, 이메일 조회
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
  FROM EMPLOYEE
 WHERE PHONE LIKE '___9%';
 
-- EMPLOYEE 테이블로부터
-- 이름 가운데 글자가 '경; 인 사원들의 모든 컬럼 조회
SELECT *
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '_경_';
 
-- 그 외의 사원들
SELECT *
  FROM EMPLOYEE
 WHERE /* NOT */ EMP_NAME NOt LIKE '_경_';
 
----- 실습문제 -----
-- 1. EMPLOYEE 테이블로부터
-- 이름이 '현' 으로 끝나는 사원들의 이름, 입시일 조회
SELECT EMP_NAME, HIRE_DATE
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '%현';
--> '__현' 도 가능함!!

-- 2. EMPLOYEE 테이블로부터
-- 전화번호 처음 3글자가 '010' 이 아닌 사원들의 이름, 전화번호 조회
SELECT EMP_NAME, PHONE
  FROM EMPLOYEE
 WHERE /* NOT */ PHONE NOT LIKE '010%';

-- 3. DEPARTMENT 테이블로부터
-- 해외영업과 관련된 부서들의 모든 컬럼을 조회
SELECT *
  FROM DEPARTMENT
 WHERE DEPT_TITLE LIKE '%해외영업%';
--> '해외영업%' 도 가능함!!

--------------------------------------------------------------------------------

/*
    < IS NULL >
    
    - NULL 과 일치하는지를 비교하는 연산자
    
    [ 사용법 ]
    
    비교대상컬럼명 IS NULL : 해당 컬럼값이 NULL 인 경우 조회
    비교대상컬럼명 IS NOT NULL : 해당 컬럼값이 NULL 이 아닌 경우 조회
*/

-- EMPLOYEE 테이블로부터 전체 사원들을 조회
SELECT *
  FROM EMPLOYEE; -- 23명
  
-- EMPLOYEE 테이블로부터
-- 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스 조회
-- 보너스를 받지 않는다 - BONUS 컬럼값이 NULL
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
  FROM EMPLOYEE
 WHERE BONUS = NULL;
--> NULL 은 비교연산 불가!! (아무것도 조회 안됨)

SELECT EMP_ID, EMP_NAME, SALARY, BONUS
  FROM EMPLOYEE
 WHERE BONUS IS NULL; -- 14명
 
-- 반대로 보너스를 받는 사원들
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
  FROM EMPLOYEE
 WHERE BONUS IS NOT NULL; -- 9명
 
-- EMPLOYEE 테이블로부터
-- 사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
  FROM EMPLOYEE
 WHERE MANAGER_ID IS NULL;
 
-- EMPLOYEE 테이블로부터
-- 사수도 없고 부서배치도 받지 않은 사원들의 모든 컬럼을 조회
SELECT * 
  FROM EMPLOYEE
 WHERE (MANAGER_ID IS NULL) AND (DEPT_CODE IS NULL);

-- EMPLOYEE 테이블로부터
-- 부서배치를 받지는 않았지만 보너스는 받는 사원들의 사원명, 보너스, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE
  FROM EMPLOYEE
 WHERE (DEPT_CODE IS NULL) AND (BONUS IS NOT NULL);
 
-- 3. EMPLOYEE 테이블로부터
-- 현재 재직중인 사원들의 사번, 이름, 입사일 조회
-- 힌트) ENT_YN 컬럼값 주의!!
SELECT EMP_ID, EMP_NAME, HIRE_DATE
  FROM EMPLOYEE
 WHERE ENT_YN = 'N';
 
-- 사실 아래의 방법으로도 풀이 가능
SELECT EMP_ID, EMP_NAME, HIRE_DATE
  FROM EMPLOYEE
 WHERE ENT_DATE IS NULL;
 
--------------------------------------------------------------------------------

/*
    < IN >
    
    - 비교 대상 컬럼 값에 낸가 제시한 "목록들" 중에서
      일치하는 값이 있는지 내부적으로 "동등비교" 해주는 연산자
      
    [ 표현법 ]
    
    비교대상칼럼명 IN (값, 값, 값, ...)
*/

-- EMPLOYEE 테이블로부터
-- 부서코드가 D6 이거나 D8 이거나 D5 인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
-- WHERE (DEPT_CODE = 'D6') OR (DEPT_CODE = 'D8') OR (DEPT_CODE = 'D5');
 WHERE DEPT_CODE IN ('D6', 'D8', 'D5');
--> IN 연산자는 주로 동일한 비교대상컬럼에 대해서 "동등비교" 연산식이 OR 연산자로 계속 엮어 있을 때 쓰면 좋다!!

-- 그 외의 사원들
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE /* NOT */ DEPT_CODE NOT IN ('D6', 'D8', 'D5');
--> IN 연산자는 내부적으로 - 에 의해서 동등비교가 일어나기 때문에
--  마찬가지로 NULL 은 연산의 대상이 대상이 되지 않음!!

--  그 외의 사원들 (부서 배치 미정인 사원들까지 포함)
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE (DEPT_CODE NOT IN ('D6', 'D8', 'D5')) OR (DEPT_CODE IS NULL);
 
--------------------------------------------------------------------------------

/*
    < 연결 연산자 (||) >
    
    - 여러 컬럼값들을 마지 하나의 컬럼인 것 처럼 연결시켜주는 연산자
    - 컬럼값들을 하나의 문자열로 이어줌!!
    - 또한, 컬럼값과 일반 리터럴 (값) 또한 연결 가능하다.
    
    - 자바로 따지면
    System.out.println("num : " + num);
*/

SELECT EMP_ID || EMP_NAME || SALARY AS "연결됨"
  FROM EMPLOYEE;
  
-- XXX번 XXX사원의 월급은 XXXXXXX원 입니다.
SELECT EMP_ID || '번 ' || EMP_NAME || '사원의 월급은 ' || SALARY || '원 입니다.' AS 급여정보
  FROM EMPLOYEE;
  
--------------------------------------------------------------------------------

/*
    < 연산자 우선순위 >
    
    0. ()
    1. 산술연산자
    2. 연결연산자
    3. 비교연산자
    4. IS NULL, LIKE, IN
    5. BETWEEN AND
    6. NOT
    7. AND (논리 연산자)
    8. OR (논리 연산자)
*/

-- 예)
-- EMPLOYEE 테이블로부터
-- 급여가 300만원 이하이고 부서코드가 D5 이거나 D6 인 사원들의 전체 컬럼 조회
SELECT *
  FROM EMPLOYEE
WHERE (SALARY <= 3000000) AND ((DEPT_CODE = 'D5') OR (DEPT_CODE = 'D6'));
--> 항상 AND 와 OR 의 연산 우선순위 주의하기!!

--------------------------------------------------------------------------------

/*
    < ORDER BY 절 >
    
    - SELECT 문 가장 마지막에 기입하는 구문일 뿐만 아니라
      실행 순서 또한 가장 마지막인 구문
      
    - 조회된 결과를 "최종적으로" 오름차순 또는 내림차순으로 "정렬" 해주는 역할
    
    [ 표현법 ]
    
    SELECT 조회할컬럼명, 컬럼명, ...
      FROM 테이블명
     WHERE 조건식
     ORDER BY [정렬기준컬럼명/별칭/컬럼순번] [ASC / DESC] [NULLS FIRST / NULLS LAST];
                                          (생략가능)             (생략가능)
     
    - ASC : ASCENDING 의 약자, 오름차순 정렬 (생략 시 기본값)
    - DESC : DESCENDING 의 약자, 내림차순 정렬
    
    - NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL 이 있을 경우
                    NULL 값들을 위에 배치하겠다. (생략 시 DESC 의 기본값)    
    - NULLS LAST : 정렬하고자 하는 컬럼값에 NULL 이 있을 겨웅
                   NULL 값들을 아래에 배치하겠다. (생략 시 ASC 의 기본값)
*/

SELECT *
  FROM EMPLOYEE
-- ORDER BY SALARY ASC; - 급여 기준으로 오름차순 정렬
-- ORDER BY SALARY DESC; -- 급여 기준으로 내림차순 정렬
 ORDER BY SALARY;
--> ASC 또는 DESC 생략 시 기본값이 ASC (오름차순)

SELECT *
  FROM EMPLOYEE
 ORDER BY EMAIL /* ASC */;
--> 문자열에 대해 오름차순 정렬은 사진순임!! (ABC 순, 가나다 순)

SELECT *
  FROM EMPLOYEE
-- ORDER BY HIRE_DATE /* ASC */;
 ORDER BY HIRE_DATE DESC;
--> 날짜에 대해 내림차순 정렬은 최신순임!!

SELECT EMP_ID 사번
     , EMP_NAME 사원명
     , SALARY 급여
  FROM EMPLOYEE
-- ORDER BY EMP_NAME DESC;
-- ORDER BY 사원명 DESC;
-- ORDER BY SALARY /* ASC */;
 ORDER BY 급여 /* ASC */;
--> ORDER BY 절이 SELECT 절 보다 더 이후에 실행되기 때문에 별칭 사용 가능!!
 
--        1       2         3        4        5
SELECT EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, SALARY
  FROM EMPLOYEE
-- ORDER BY EMP_NAME DESC;
-- ORDER BY 2 DESC;
-- ORDER BY SALARY /* ASC */;
 ORDER BY 5 /* ASC */;
--> SELECT 절에 기술한 컬럼의 순번 (1부터 셈) 을 통해서도 정렬 기준을 잡을 수 있다!!
--  단, 가독성 측면에서 권장하는 방법은 아님!!

SELECT *
  FROM EMPLOYEE
-- ORDER BY BONUS /* ABC */; -- ASC 의 기본값은 NULLS LAST
 ORDER BY BONUS DESC; -- DESC 의 기본값은 NULLS FIRST
--> 왜? 오라클에서 NULL 값은 가장 큰 값으로 취급됨!!

SELECT *
  FROM EMPLOYEE
-- ORDER BY BONUS /* ASC */ NULLS FIRST;
 ORDER BY BONUS DESC NULLS LAST;

SELECT EMP_NAME, SALARY * 12 "연봉"
  FROM EMPLOYEE
 ORDER BY SALARY * 12 DESC;
--> 정렬기준 자리에 컬럼을 통한 수식도 가능함!!

SELECT *
  FROM EMPLOYEE
 ORDER BY BONUS DESC, SALARY ASC;
--> 정렬 기준을 여러 개 제시할 수 있다!! (, 로 나열)
--  첫번째로 제시한 정렬기준의 컬럼값들이 동일한 경우, 두번째 정렬기준으로 그 안에서 다시 정렬해줌!!
