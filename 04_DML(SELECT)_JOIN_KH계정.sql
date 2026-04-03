/*
    < JOIN >
    
    - 테이블을 "엮겠다" (JOIN)
    - 두 개 이상의 테이블에서 데이터를 함께 "조회" 하고자 할 때 사용되는 구문
    - 조회 결과는 하나의 결과물 (RESULT SET) 으로 나옴
    
    * 관계형 데이터베이스에서는
      "최소한" 의 데이터로 각각의 테이블에 데이터를 "쪼개서" 보관하고 있음!!
      > 데이터의 "중복을 최소화하기 위해서 최대한 쪼개는 것!! (테이블을 쪼개는 과정 - 정규화)
      
    * 즉, JOIN 구문을 통해서 여러개의 테이블 간 "관계" 를 맺어서 같이 조회해야함!!
      > 단, 무작정 JOIN 을 해서 조회를 하는 건 아니고
        테이블 간의 "연결고리" 에 해당하는 컬럼을 찾아서 매칭시켜서 조회해야함!!
        
    * JOIN 은 크게 "오라클 전용 구문" 과 "ANSI (미국국립표준협회) 구문" 으로 문법이 나뉜다.
    
    - 오라클 전용 구문 : 오라클 DBMS 에서만 사용가능
    - ANSI 구문 : 오라클 포함 다른 DBMS 에서도 모두 사용 가능(SQLD나옴)
        
                오라클 전용 구문           |               ANSI 구문
    ==================================================================================
                    등가 조인             |                 내부 조인
                  (EQUAL JOIN)           |               (INNER JOIN)
    ----------------------------------------------------------------------------------
                    포괄 조인             |                 외부 조인
                  (LEFT JOIN)            |            (LEFT OUTER JOIN)
                 (RIGNT JOIN)            |           (RIGHT OUTER JOIN)
                                         |            (FULL OUTER JOIN)
                                         |        => 오라클 전용 구문에서는 불가
    ----------------------------------------------------------------------------------
                카테시안 곱               |                 교차 조인
            (CARTESIAN PRODUCT)          |               (CROSS JOIN)
    -----------------------------------------------------------------------------------
                                자체조인 (SELF JOIN)
                            비등기 조인 (NON EQUAL JOIN)
*/

-- JOIN 을 배워야 하는 이유
-- EMPLOYEE 테이블로부터 전체 사원들의
-- 사번, 사원명, 부서코드, 부서명까지 알아내고 싶다면
SELECT EMP_ID, EMP_NAME, DEPT_CODE
  FROM EMPLOYEE;
--> EMPLOYEE 테이블로는 부서코드까지만 알아낼 수 있음

-- DEPARTMENT 테이블을 통해 부서명까지 알아내보기
SELECT DEPT_ID, DEPT_TITLE
  FROM DEPARTMENT;
-- EMPLOYEE 테이블의 DEPT_CODE 컬럼, DEPARTMENT 테이블의 DEPT_ID 컬럼에 담긴 값들이 유사!! (연결고리로 활용 가능)  
--> 두번 조회를 하는 대신 EMPLOYEE, DEPARTMENT 테이블을 JOIN 하면 한번에 조회로 알아낼 수 있음!!

-- EMPLOYEE 테이블로부터 전체 사원들의
-- 사번, 사원명, 직급코드, 직급명까지 알아내고자 한다면?
SELECT EMP_ID, EMP_NAME, JOB_CODE
  FROM EMPLOYEE;

-- 추가적으로 JOB 테이블을 통해 직급명까지 알아내보기
SELECT JOB_CODE, JOB_NAME
  FROM JOB;
-- EMPLOYEE 테이블의 JOB_CODE 컬럼, JOB 테이블의 JOB_CODE 컬럼에 담긴 값들이 유사!! (연결고리로 활용 가능)
--> 이왕이면 한번에 조회하고싶음!! 이럴 때 사용하는 것이 JOIN!!

--> JOIN 을 통해서 "연결고리" 에 해당하는 컬럼을 찾아서
--  제대로 매칭시키면 마치 하나의 테이블로부터 조회할 수 있는 효과를 준다!!
-- (마치 하나의 결과물로 조회 가능해짐)

--------------------------------------------------------------------------------

/*
    1. 등가 조인 (EQUAL JOIN) / 내부 조인 (INNER JOIN)
    
    - 연결고리에 해당하는 컬럼값이 "일치" 하는 행들만 조인되서 조회하겠다.
    - 즉, 일치하지 않는 값들은 조회해서 제외하겠다.
*/

-->> 오라클 전용 구문
--   FROM 절에 조회하고자 하는 (테이블명들을 나열 (, 로)
--   WHERE 절에 매칭시킬 컬럼명 (연결고리) 에 대한 조건식을 기술

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 같이 조회
-- 1) 연결고리 컬럼명이 서로 다른 경우
-- EMPLOYEE 테이블의 DEPT_CODE, DEPARTMENT 테이블의 DEPT_ID
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID;
--> DEPT_CODE 가 NULL 이었던 2명의 사원 데이터는 누락됨!!
--  (DEPARTMENT 테이블의 DEPT_ID 컬럼 중 NULL 값과 일치하는 값을 못찾아서 누락)
--> DEPT_ID 가 D3, D4, D7 이었던 3개의 부서명 데이터는 누락됨!!
--  (EMPLOYEE 테이블의 DEPT_CODE 컬럼 중 D3, D4, D7 값과 일치하는 값을 못찾아서 누락)

-- 사번, 사원명, 직급코드, 직급명
-- 2) 연결고리 컬럼명이 서로 같은 경우
-- EMPLOYEE 테이블의 JOB_CODE, JOB 테이블의 JOB_CODE
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE JOB_CODE = JOB_CODE;
--> 오류 발생
--  AMBIGUOUSLY : 애매모호한
--  어느 테이블의 JOB_CODE 컬럼과 또 다른 어느 테이블의 JOB_CODE 컬럼을 지정하는지 애매모호
--> 해결 방법
--  확실히 어느 테이블의 컬럼명인지 다 일일이 명시하면 됨!!

-- 방법1) 테이블명을 이용하는 방법
-- 테이블명.컬럼명
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
 
-- 방법2) 테이블에 별칭을 부여 후 그 별칭을 이용하는 방법
-- (사실 테이블에도 별칭을 붙일 수 있음)
-- 별칭.컬럼명
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE;
 
-->> ANSI 구문
--   FROM 절에 기준이 되는 테이블명을 하나만 기술한 뒤
--   그 뒤에 JOIN 절에서 같이 조회하고자 하는 테이블명과 연결고리에 대한 조건식을 같이 기술
--   (USING 구문 / ON 구문)

-- 사번, 사원명, 부서코드, 부서명
-- 1) 연결고리 컬럼명이 서로 다른 경우
-- EMPLOYEE 테이블의 DEPT_CODE, DEPARTMENT 테이블의 DEPT_ID
-- => 무조건 ON 구문만 사용 가능!!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
  FROM EMPLOYEE -- 기준테이블명
 /* INNER */ JOIN /*조인할테이블명*/DEPARTMENT ON (/*연결고리에대한조건식*/DEPT_CODE = DEPT_ID);
--> INNER 생략 가능!!

-- 사원, 사원명, 직급코드, 직급명
-- 2) 연결고리 컬럼명이 서로 같은 경우
-- EMPLOYEE 테이블의 JOB_CODE, JOB_CODE
-- => ON 구문, USING 구문 모두 사용 가능!!

-- 2_1) ON 구문 이용
-- AMBIGUOUSLY 오류가 발생할 수 있기 때문에
-- 테이블명이든 별칭이든 간에 확실히 명시해 줘야 한다!!
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
  FROM EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
  
-- 2_2) USING 구문 이용
-- ON 구문은 연결고리에 대한 조건식을 내가 직접 기술하는 구문임!!
-- USING 구문은 내부적으로 "동등비교" 를 수행해주는 구문임!! (그래서 연결고리 컬럼명이 동일한 경우만 사용 가능)
-- => 동일한 컬럼명 하나만 써주면 알아서 동등비교 후에 매칭시켜줌
--    (AMBIGUOUSLY 오류도 에초에 발생 안함)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE); -- 내부적으로 EMPLOYEE.JOB_CODE = JOB.JOB_CODE 를 수행 (동등비교)
  
-- 참고) 특이케이스
-- 연결고리 컬럼명이 동일한 경우 "NATURAL JOIN (자연 조인)" 도 가능
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
NATURAL JOIN JOB;
--> 두개의 테이블명만 제시하고, 연결고리에 대한 조건식은 기술 X
--  운 좋게도 두 개의 테이블에 일치하는 컬럼이 유의하게 한개씩 존재 (이 경우 그 컬럼을 가지고 자동으로 내부조만 해줌)

-- 연결고리에 대한 조건식 뿐만 아니라 추가적인 조건식도 제시 가능함!!

-- 직급이 "대리" 인 사원들의 사번, 이름, 급여, 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건식
   AND JOB_NAME = '대리'; -- 추가적인 조건식
   
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
  FROM EMPLOYEE
--   JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
  JOIN JOB J USING (JOB_CODE) -- 연결고리에 대한 조건식
 WHERE JOB_NAME = '대리'; -- 추가적인 조건식
 
 ----- <실습문제> -----
-- 1. 부서가 "인사관리부" 인 사원들의 사번, 사원명, 보너스 조회
-->> 오라클 전용 구문
SELECT EMP_NO 사번, EMP_NAME 사원명, BONUS 보너스
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID
   AND DEPT_TITLE = '인사관리부';

-->> ANSI 구문
SELECT EMP_NO 사번, EMP_NAME 사원명, BONUS 보너스
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE DEPT_TITLE = '인사관리부';
 
-- 2. 부서가 "총무부" 가 아닌 사원들의 사원명, 급여, 입사일 조회
-->> 오라클 전용 구문
SELECT EMP_NAME 사원명, SALARY 급여, HIRE_DATE 입사일
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID -- 연결고리에 대한 조건
   AND DEPT_TITLE != '총무부' -- 추가적인 조건
UNION
SELECT EMP_NAME 사원명, SALARY 급여, HIRE_DATE
  FROM EMPLOYEE
 WHERE DEPT_CODE IS NULL;
   
-->> ANSI 구문
SELECT EMP_NAME 사원명, SALARY 급여, HIRE_DATE 입사일
  FROM EMPLOYEE
 INNER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE DEPT_TITLE ^= '총무부';
-- 마찬가지로 UNION 을 통해 부서코드가 NULL 인 사람들도 포함시켜서 조회 가능!!

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서명
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID -- 연결고리에 대한 조건
   AND BONUS IS NOT NULL; -- 추가적인 조건

-->> ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서명
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE BONUS IS NOT NULL
 ORDER BY EMP_ID;
--> JOIN 시 언제든지 ORDER BY 도 적용 가능!!
 
-- 4. 아래의 두 테이블을 참고해서 
-- 부서코드, 부서명, 지역코드, 지역명 (LOCAL_NAME) 조회
SELECT * FROM DEPARTMENT; -- DEPT_ID, DEPT_TITLE, LOCATION_ID
SELECT * FROM LOCATION;   -- LOCAL_CODE, NATIONAL_CODE, LOCAL_NAME

-->> 오라클 전용 구문
SELECT DEPT_ID 부서코드, DEPT_TITLE 부서명, LOCATION_ID 지역코드, LOCAL_NAME 지역명
  FROM DEPARTMENT, LOCATION
 WHERE LOCATION_ID = LOCAL_CODE; -- 연결고리에 대한 조건

-->> ANSI 구문
SELECT DEPT_ID 부서코드, DEPT_TITLE 부서명, LOCATION_ID 지역코드, LOCAL_NAME 지역명
  FROM DEPARTMENT
  JOIN LOCATION ON (LOCATION_ID= LOCAL_CODE);
  
-- 위의 4번 문제에서..
-- 아시아 지역에 위치한 부서만 보고싶다면?
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
  FROM DEPARTMENT
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
 WHERE LOCAL_NAME LIKE '%ASIA%';
 
--> 등가 조인 / 내부 조인
--  "일치" 하는 행들만 조회하는 개념!!
--  일치하는 행들은 애초에 조회되지 않음!!

--------------------------------------------------------------------------------

/*
    2. 포괄 조인 / 외부 조인 (OUTER JOIN)
    
    - 테이블 간의 JOIN 시 일치하지 않는 행들도 포함시켜서 조회 가능
    - 단, 단드시 LEFT / RIGHT 를 지정해야함!! (기준이 되는 테이블을 지정해야 함)
*/

-- EMPLOYEE 테이블로부터
-- "전체" 사원들의 사원명, 급여, 부서명 조회
-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--> EMPLOYEE 테이블오부터 DEPT_CODE 가 NULL 인 두명의 사원 조회 X
--  DEPARTMENT 테이블로부터 DEPT_ID 가 D3, D4, D7 인 부서명 조회 X

-- 1) LEFT OUTER JOIN
-- 두 테이블 중 "왼편" 에 기술된 테이블을 기준으로 하여 JOIN
-- 즉, 뭐가 되었든 간에 왼편에 기술된 테이블의 데이터는 누락 없이 무조건 조회되겠다.
-- (일치하는걸 찾지 못하더라도)

-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE 
  LEFT /* OUTER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--> EMPLOYEE 테이블을 기준으로 조회했기 때문에
--  EMPLOYEE 에 존재하는 데이터는 뭐가 되었든 간에 무조건 조회
--  (일치하는걸 찾지 못하더라도)

-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID(+);
--> 내가 기준으로 삼을 테이블의 컬럼명이 아닌 "반대" 테이블의 컬럼명 뒤에 (+) 를 붙여준다!!

-- 2) RIGHT OUTER JOIN
-- 두 테이블 중 "오른편" 에 기술된 테이블을 기준으로 조인
-- 즉, 뭐가 되었든간에 오른편에 기술된 테이블의 데이터는 무조건 조회
-- (일치하는 것을 찾지 못하더라도)

-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE 
 RIGHT /* OUTER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
--> 우선 일치하는 행들을 조회 후,
--  기준 테이블인 DEPARTMENT 테이블 (오른편 테이블) 의 누락된 정보가 더해져서 조회됨!!

-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE(+) = DEPT_ID;

SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_ID = DEPT_CODE(+);
--> 방향은 상관없고 무조건 기준이 되는 컬럼 반댓방향 컬럼에 (+) 를 기술!!
--  마찬가지로 테이블 명 기술 순서 또한 상관 없음!!

-- RIGHT OUTER JOIN 을 이용해서
-- "전체" 사원들의 이름, 급여, 부서명을 보고싶다면?
-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM DEPARTMENT
 RIGHT OUTER JOIN EMPLOYEE ON (DEPT_CODE = DEPT_ID);
  
-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_ID(+) = DEPT_CODE;
--> 마찬가지로 방향, 기술 순서와 상관 없이 기준을 정확하게 찝고, 그 반댓방향에 (+) 붙이기!!

-- 3) FULL OUTER JOIN
-- 두 테이블이 가진 모든 행을 조회할 수 있도록 조인
-- 즉, 일치하는 것들을 찾고, 양쪽 테이블에서 누락된 데이터를 각각 붙여서 조회!!
-- 단, 오라클 전용 구문에서 절대 불가!!

-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE
  FULL /* OUTER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
  
-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE(+) = DEPT_ID(+);
--> only one outer-joined table 오류 발생!!

-- 포괄 조인 / 외부 조인
-- 왼쪽 기준일 경우 : 일치하는 것 + 왼쪽테이블에서 누락된 데이터
-- 오른쪽 기준일 경우 : 일치하는 것 + 오른쪽테이블에서 누락된 데이터
-- FULL 기준일 경우 : 일치하는 것 + 왼쪽테이블에서 누락된 데이터 + 오른쪽테이블에서 누락된 데이터
-- (단, ANSI 만 가능)

--------------------------------------------------------------------------------

/*
    3. 카테시안 곱 / 교차 조인
    
    - 모든 테이블의 각 행들이 서로서로 맵핑된 데이터가 조회된 (곱집합)
    - 즉, 두 테이블의 모든 행들이 모두 곱해진 행들의 조합이 다 출력됨
    
    - 주로, 내가 JOIN 구문 작성 시 실수할 경우 발생한다 (오라클 전용 구문)
    - 내가 필요로 하지 않는 방대한 데이터를 출력한다. (과부하 위험)
      그래서 대놓고 실무에서 사용될 일은 극히 드물다!!
*/

-- 사원명, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT;
--> 23 * 9 = 207 개 행 조회

-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE
 CROSS JOIN DEPARTMENT;
 
--------------------------------------------------------------------------------

/*
    4. 비등가 조인 (NOT EQUAL JOIN)
    
    - 연결고리에 대한 조건식에 '=' (동등비교 연산자, 등호) 를 사용하지 않는 조인문
    - 일치하지 않는 것들에 대해 조인하겠다가 아닌 <, > (부등호)를 이용해서 "범위" 에 포함되는 경우 조인
*/

-- EMPLOYEE 테이블로부터 사원명, 급여
SELECT EMP_NAME, SALARY
  FROM EMPLOYEE;
  
-- SAL_GRADE 테이블 조회
SELECT * 
  FROM SAL_GRADE;
--> 사실 EMPLOYEE 테이블의 SAL_LEVEL 컬럼 (파생 컬럼) 은 없어도 무방함!!
--  (사실 없는게 더 권장사항임)
--  왜? SALARY 급여는 유동적인 값인데, SALARY 값이 변할 때마다 SAL_LEVEL 컬럼값도
--  그에 따라 매번 변경해줘야함!!
--  데이터 변경도 귀찮고, 변경하는 과정에서 실수할 경우 데이터 불일치 현상이 발생 가능!!

-- 지금부터 EMPLOYEE 테이블의 SAL_LEVEL 컬럼이 없다는 가정하에 비등가 조인 연습해보기!!

-- 사원명, 급여, 급여등급 (SAL_GRADE 테이블의 컬럼으로)
-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL "예측값", EMPLOYEE.SAL_LEVEL "정답"
  FROM EMPLOYEE, SAL_GRADE
-- WHERE (MIN_SAL <= SALARY) AND (SALARY <= MAX_SAL); -- 연결고리에 대한 조건
 WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;
 
-->> ANSI 구문
SELECT EMP_NAME, SALARY, SAL_GRADE.SAL_LEVEL "예측값", EMPLOYEE.SAL_LEVEL "정답"
  FROM EMPLOYEE
  JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);
--> ANSI 구문 형식으로 비등가 조인을 하고 싶다면 무조건 ON 구문만 사용 가능!!
--  왜? USING 구문은 내부적으로 "동등 비교" 만 수행해줌!!
--  비등가 조인은 내가 직접 범위를 맞춰서 복잡한 조건식을 기술하는 개념이기 때문!!

-- 비등가 조인 예시)
-- 인터넷 쇼핑몰
-- 회원 정보 테이블 / 회원별 구매 내역을 담는 테이블 / 구매금액에 따른 구간별 회원등급 테이블

--------------------------------------------------------------------------------

/*
    5. 자체 조인 (SELF JOIN)
    
    - 같은 테이블을 다시 한번 조인하는 경우
    - 즉, 자기 자신의 테이블과 다시 조언을 맺는 경우
    - AMBIGUOUSLY 오류 주의!!
*/

-- 우선 사수의 사번을 통해 해당 사수의 정보를 알아내보자
SELECT EMP_ID "사원의 사번"
     , EMP_NAME "사원의 이름"
     , SALARY "사원의 급여"
     , MANAGER_ID "사수의 사번"
  FROM EMPLOYEE;
  
SELECT * FROM EMPLOYEE E; -- 사원에 대한 정보 도출용
SELECT * FROM EMPLOYEE M; -- 사수에 대한 정보 도출용 (사수도 우리 회사의 직원이기 때문에 EMPLOYEE 테이블에 정보가 있으므로)
                          -- : EMP_ID 컬럼을 연결고리로 삼겠음!!
                          
-- 사원의 사번, 사원명, 사원의 부서코드, 사원의 급여
-- 사수의 사번, 사수명, 사수의 부서코드, 사수의 급여
-- 단, 사수가 없더라도 "전체" 사원들의 정보를 다 보고싶음!! (포괄 조인)
-->> 오라클 전용 구문
SELECT E.EMP_ID "사원의 사번"
     , E.EMP_NAME "사원명"
     , E.DEPT_CODE "사원의 부서코드"
     , E.SALARY "사원의 급여"
     , M.EMP_ID "사수의 사번"
     , M.EMP_NAME "사수명"
     , M.DEPT_CODE "사수의 부서코드"
     , M.SALARY "사수의 급여"
  FROM EMPLOYEE E, EMPLOYEE M
 WHERE E.MANAGER_ID = M.EMP_ID(+);
 
-->> ANSI 구문
SELECT E.EMP_ID "사원의 사번"
     , E.EMP_NAME "사원명"
     , NVL(E.DEPT_CODE, '없음') "사원의 부서코드"
     , E.SALARY "사원의 급여"
     , NVL(M.EMP_ID, '없음') "사수의 사번"
     , NVL(M.EMP_NAME, '없음') "사수명"
     , NVL(M.DEPT_CODE, '없음') "사수의 부서코드"
     , NVL(M.SALARY, 0) "사수의 급여"
  FROM EMPLOYEE E 
  LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID)
 ORDER BY "사원의 사번";
--> 사원의 부서코드 뿐만 아니라 부서명도 보고싶다면?
--  사수 또한 부서코드 뿐만 아니라 부서명까지 보고싶다면?

-- 사원의 사번, 사원명, 사원의 부서코드, 사원의 부서명, 사원의 급여
-- 사수의 사번, 사수명, 사수의 부서코드, 사수의 부서명, 사수의 급여
-->> 오라클 전용 구분
SELECT E.EMP_ID "사원의 사번"
     , E.EMP_NAME "사원명"
     , E.DEPT_CODE "사원의 부서코드"
     , D1.DEPT_TITLE "사원의 부서명"
     , E.SALARY "사원의 급여"
     , M.EMP_ID "사수의 사번"
     , M.EMP_NAME "사수명"
     , M.DEPT_CODE "사수의 부서코드"
     , D2.DEPT_TITLE "사수의 부서명"
     , M.SALARY "사수의 급여"
  FROM EMPLOYEE E, EMPLOYEE M, DEPARTMENT D1, DEPARTMENT D2
 WHERE E.DEPT_CODE = D1.DEPT_ID(+) -- E 와 D1 을 조인
   AND M.DEPT_CODE = D2.DEPT_ID(+) -- M 과 D2 를 조인
   AND E.MANAGER_ID = M.EMP_ID(+); -- E 와 M 을 조인
--> 3개 이상의 테이블 조인 시에는 포괄 조인의 경우 연결고리에 대한 조건을
--  전반적으로 모두 다 포괄시키는 조건을 정확하게 제시해야 한다!!

-->> ANSI 구문
SELECT E.EMP_ID "사원의 사번"
     , E.EMP_NAME "사원명"
     , E.DEPT_CODE "사원의 부서코드"
     , D1.DEPT_TITLE "사원의 부서명"
     , E.SALARY "사원의 급여"
     , M.EMP_ID "사수의 사번"
     , M.EMP_NAME "사수명"
     , M.DEPT_CODE "사수의 부서코드"
     , D2.DEPT_TITLE "사수의 부서명"
     , M.SALARY "사수의 급여"
  FROM EMPLOYEE E
  LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID)
  LEFT JOIN DEPARTMENT D1 ON (E.DEPT_CODE = D1.DEPT_ID)
  LEFT JOIN DEPARTMENT D2 ON (M.DEPT_CODE = D2.DEPT_ID);
--> 3 개 이상의 테이블들도 조인 가능하다!!
--  ANSI 구문의 경우 JOIN 절 작성 순서가 중요함!!

--------------------------------------------------------------------------------

/*
    < 다중 JOIN > 
    
    - 3 개 이상의 테이블들도 조인 하는 것
    - ANSI 구문의 경우 JOIN 절 작성 순서가 중요!!
    - 테이블 N 개를 조인하면 연결고리에 대한 조건식이 N - 1 개 나옴
*/

-- 사번, 사원명, 부서명, 직급명, 근무지역명
SELECT * FROM EMPLOYEE;    -- DEPT_CODE    JOB_CODE
SELECT * FROM DEPARTMENT;  -- DEPT_ID                 LOCATION_ID
SELECT * FROM JOB;         --              JOB_CODE
SELECT * FROM LOCATION;    --                         LOCAL_CODE

-->> 오라클 전용 구문
SELECT E.EMP_ID "사번"
     , E.EMP_NAME "사원명"
     , D.DEPT_TITLE "부서명"
     , J.JOB_NAME "직급명"
     , L.LOCAL_NAME "근무지역명"
  FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L
 WHERE E.DEPT_CODE = D.DEPT_ID(+)
   AND E.JOB_CODE = J.JOB_CODE
   AND D.LOCATION_ID = L.LOCAL_CODE(+);
   
-->> ANSI 구문
SELECT E.EMP_ID "사번"
     , E.EMP_NAME "사원명"
     , D.DEPT_TITLE "부서명"
     , J.JOB_NAME "직급명"
     , L.LOCAL_NAME "근무지역명"
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J USING (JOB_CODE) -- JOIN JOB J ON (E.JOB_CODE= J.JOB_CODE);
  LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
   
-- 사원명, 부서명, 직급명, 근무지역명, 극무국가명, 급여등급
SELECT * FROM EMPLOYEE;     -- DEPT_CODE    JOB_CODE                                        SALARY
SELECT * FROM DEPARTMENT;   -- DEPT_ID                  LOCATION_ID
SELECT * FROM JOB;          --              JOB_CODE
SELECT * FROM LOCATION;     --                          LOCAL_CODE      NATIONAL_CODE
SELECT * FROM NATIONAL;     --                                          NATIONAL_CODE                
SELECT * FROM SAL_GRADE;    --                                                          MIN_SAL / MAX_SAL    

-->> 오라클 전용 구문
SELECT E.EMP_NAME "사원명"
     , D.DEPT_TITLE "부서명"
     , J.JOB_NAME "직급명"
     , L.LOCAL_NAME "근무지역명"
     , N.NATIONAL_NAME "근무국가명"
     , S.SAL_LEVEL "급여등급"
  FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
  WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE
    AND D.LOCATION_ID = L.LOCAL_CODE(+)
    AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
    AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

-->> ANSI 구문
SELECT E.EMP_NAME "사원명"
     , D.DEPT_TITLE "부서명"
     , J.JOB_NAME "직급명"
     , L.LOCAL_NAME "근무지역명"
     , N.NATIONAL_NAME "근무국가명"
     , S.SAL_LEVEL "급여등급"
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J USING (JOB_CODE)
  LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
  LEFT JOIN NATIONAL N USING (NATIONAL_CODE)
  JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
  
--> 테이블을 잘개 쪼갤수록 데이터 중복이 최소화 됨!! (데이터 무결성이 보장됨)
--  테이블을 잘개 쪼갤수록 조인은 필수!! (조인해야하는 테이블 갯수가 늘어남)
--  조인할 테이블의 갯수가 많아질수록 SELECT 문의 성능은 오히려 떨어짐!!
--  테이블을 잘개 쪼갤수록 SELECT 문의 성능을 떨어진다 / 오히려 INSERT, UPDATE, DELETE 문의 성능은 올라간다.