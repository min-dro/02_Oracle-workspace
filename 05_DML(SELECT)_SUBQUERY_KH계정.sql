/*
    < SUBQUERY 서브쿼리 >
    
    - 하나의 주된 SQL 문 (SELECT, INSERT, UPDATE, DELETE, CREATE) 안에
      "포함된 또 하나의 SELECT 문"
    - 즉, 메인 SQL 문을 위해 보조 역할을 하는 안쪽 SELECT 문
    
    하나의 주된 SQL 문 : 메인쿼리 - 2 (서브쿼리 결과인 RESULT SET 을 가지고 실행)
    포함된 또 하나의 SELECT 문 : 서브쿼리 - 1 (항상 먼저 실행, 실행 결과로 RESULT SET 이 나옴)
*/

-- 서브쿼리 맛보기 예제
-- 간단 서브쿼리 예시 1
-- 김유하 사원과 같은 부서인 사원들
-- 1) 먼저 김유화 사원의 부서코드를 조회
SELECT DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '김유화';
--> 김유화 사원의 부서코드는 'D6' 임을 알 수 있다!!

-- 2) 부서코드가 D6 인 사원들 조회
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D6';
 
-- 위의 두 단계를 하나의 쿼리문으로 합치기
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = (
                    SELECT DEPT_CODE 
                      FROM EMPLOYEE 
                     WHERE EMP_NAME = '김유화'
);

-- 간단 서브쿼리 예시 2
-- 전체 사원들의 평균 급여보다 더 많은 급여를 받고 있는 사원들의
-- 사번, 이름, 직급코드를 조회
-- 1) 먼저 전체 사원들의 평균 급여를 구하기
SELECT AVG(SALARY)
  FROM EMPLOYEE;
--> 평균 급여는 대략 3047663 원 정도임!! (반올림해서)

-- 2) 급여가 3047663 원 보다 더 많이 받는 사원들 조회 (이상)
SELECT EMP_ID, EMP_NAME, JOB_CODE
  FROM EMPLOYEE
 WHERE SALARY >= 3047663;
 
-- 위의 두 단계를 하나의 쿼리문으로 합치기
SELECT EMP_ID, EMP_NAME, JOB_CODE
  FROM EMPLOYEE
 WHERE SALARY >= (
                    SELECT AVG(SALARY)
                      FROM EMPLOYEE
 ); -- (SQLD)
 
--------------------------------------------------------------------------------

/*
    * 서브쿼리의 종류 (구분)
    
    - 서브쿼리 부분만 실행해봤을 때 그 결과 (RESULT SET) 가 몇행 몇열이냐에 따라서 구분됨
    
    - 단일행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과가 오로지 1개일 떄 (1행 1열일 경우)
    - 다중행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과가 여러 행일 떄 (1열)
    - (단일행) 다중열 서브쿼리 : 서브쿼리를 수행한 결과가 여러 열일 때 (1행)
    - 다중행 다중열 서브쿼림 : 서브쿼리를 수행한 결과가 여러 행 여러 열일 때

    => 서브쿼리를 수행한 결과가 (RESULT SET) 몇행 몇열이냐에 따라서
       메인쿼리에서 사용할 수 있는 연산자의 종류가 매번 달라진다!!
       
    => 위의 서브쿼리들은 대부분 SELECT 문의 WHERE 절 또는 HAVING 절에서 조건식과 함꼐 쓰였음!!
    
    => FROM 절에도 서브쿼리를 사용 가능하다!!
      (SELECT 절도 서브쿼리를 쓸 수는 있는데 SELECT 절에 쓰는 것은 비권장사함)
      
    - 인라인 뷰 (INLINE VIEW) : FROM 절에 서브쿼리를 제시할 때 (위의 것들과 잘 구분)
*/

/*
    1. 단일행 (단일열) 서브쿼리 (SINGLE ROW SUBQUERY)
    
    - 서브쿼리의 조회 결과값이 오로지 1개일 때 (1행 1열일 때)
    
    - 일반적인 연산자들 사용 가능 (=, !=, <=, >, ..)
*/

-- 전 직원의 평균 급여보다 더 작게 받는 사원들의 사원명, 직급코드 조회
-- 1) 먼저 평균급여 구하기
SELECT AVG(SALARY)
  FROM EMPLOYEE;
  
-- 2) 그 평균 급여보다 적게받는 사원을 구하기 (미만)
SELECT EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY < (
                    SELECT AVG(SALARY)
                    FROM EMPLOYEE -- 결과값이 1행 1열
 );
--> 항상 서브쿼리 () 로 묶어서 표현함!!

-- 최저 급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
-- 1) 먼저 최저 급여 알아내기
SELECT MIN(SALARY)
  FROM EMPLOYEE;
--> 최저 급여는 1380000원

-- 2) 그 최저 급여를 받는 사원의 정보 구하기
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
  FROM EMPLOYEE
 WHERE SALARY = (
                    SELECT MIN(SALARY)
                      FROM EMPLOYEE -- 결과값 1행 1열
 );
 
-- 이주환 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
-- 1) 이주환 사원의 급여 먼저 구하기
SELECT SALARY
  FROM EMPLOYEE
 WHERE EMP_NAME = '이주환';
--> 2550000 원

-- 2) 그 급여보다 더 많이 받는 사원들의 정보 구하기 (초과)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > (
                    SELECT SALARY
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '이주환' -- 결과가 1행 1열
 );
 
-- 이주환 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서명, 급여 조회
-->> 오라클 전용 구분
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '미정'), SALARY
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID(+) -- 연결고리에 대한 조건
   AND SALARY > ( 
                    SELECT SALARY
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '이주환'
 ); -- 추가적인 조건
 
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '미정'), SALARY
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE SALARY > (
                    SELECT SALARY
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '이주환'
 );
--> 조인, 그동안 배운 연산자, 함수식 등 다양하게 조합 후 사용 가능!!

-- 최한선 사원과 같은 부서의 사원들의 사번, 이름, 전화번호, 직급명 조회
-- 단, 본인은 제외하고 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE -- 연결고리에 대한 조건
   AND DEPT_CODE = (
                        SELECT DEPT_CODE
                          FROM EMPLOYEE
                         WHERE EMP_NAME = '최한선'
   )
   AND EMP_NAME != '최한선'; -- 추가적인 조건
 
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '최한선'
 )
   AND EMP_NAME != '최한선';
   
-- 부서별 급여 합이 가장 큰 부서 하나만을 조회 (부서코드, 부서명, 급여합)
-- 1) 부서별 급여 합 먼저 구하기
SELECT DEPT_CODE, SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
--> DEPT_CODE 컬럼을 기준으로 각 부서 별 급여 합 먼저 구함

-- 2) 그 중에서도 급여 합이 가장 큰 값만 뽑기
SELECT MAX(SUM(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
--> 17700000 원 정도 나옴

-- 3) 해당 급여액의 부서의 정보를 구하기
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
  FROM EMPLOYEE 
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (
                        SELECT MAX(SUM(SALARY))
                          FROM EMPLOYEE
                         GROUP BY DEPT_CODE
 );
 
 -------------------------------------------------------------------------------
 
 /*
    2. 다중행 (단일열) 서브쿼리 (MULTI ROW SUBQUERY)
    
    - 서브쿼리의 조회 결과값이 여러행 1열 짜리일 때
    
    * 사용 가능한 연산자 종류
    
    - IN (서브쿼리) : 여러개의 결과값 중에서 한개라도 일치할 경우
      NOT IN (서브쿼리) : "없으면" 이라는 의미
      
    - > ANY (서브쿼리) : 여러개의 결과값 중에서 "하나라도" 클 경우
                        즉, 여러개의 결과값 중에서 가장 작은값보다 클 경우
      < ANY (서브쿼리) : 여러개의 결고값 중에서 "하나라도" 작을 경우
                        즉, 여러개의 결과값 중에서 가장 큰 값보다 작을 경우
                        
    - > ALL (서브쿼리) : 여러개의 결과값의 "모든" 값보다 클 경우
                        즉, 여러개의 결과값 중에서 가장 큰 값보다 클 경우
        ALL (서브쿼리) : 여러개의 결과값의 "모든" 값보다 작을 경우
                        즉, 여러개의 결과값 중에서 가장 작은값보다 작을 경우
                        
    <=, >= 또한 ANY, ALL에서 사용 기능함!!
*/

--각 부서뱔 최고급여를 받는 사원의 이름, 직급코드, 급여 조회
-- 1) 각 부서별 최고급여들을 먼저 구하기
SELECT MAX(SALARY)
  FROM EMPLOYEE
  GROUP BY DEPT_CODE;
--> (2890000, 3660000, 8000000, 3760000, 3900000, 2490000, 2550000)

-- 2) 위의 급여액들을 받는 사원들 조회
SELECT EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY IN (2890000, 3660000, 8000000, 3760000, 3900000, 2490000, 2550000);
 
-- 위의 두 쿼리를 합치기
SELECT EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY IN (
                    SELECT MAX(SALARY)
                      FROM EMPLOYEE
                    GROUP BY DEPT_CODE -- 결과가 7행 1일
 );
 
-- 이재영 또는 유종규 사원과 같은 부서인 사원들 조회 (사원명, 부서코드, 급여_
-- 1) 이재영, 유종규 사원의 부서코드 먼저 구하기
SELECT DEPT_CODE
  FROM EMPLOYEE
-- WHERE EMP_NAME= '이재영' OR EMP_NAME = '유종규';
 WHERE EMP_NAME IN ('이재영', '유종규');
--> ('D5', 'D8')

-- 2) 위의 두 부서에 소속된 사원들 구하기
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE IN ('D5', 'D8');
 
-- 위의 두 쿼리를 합치기
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE IN (
                        SELECT DEPT_CODE
                          FROM EMPLOYEE
                         WHERE EMP_NAME IN ('이재영', '유종규') -- 결과값이 2행 1열
);

-- 사원 < 대리 < 과장 < 차장 < 부장
-- 대리직급임에도 불구하고 과장직급의 급여보다 더 많이 받는 직원들 조회 (사번, 이름, 직급명, 급여)
-- 1) 과장 직급들의 급여 먼저 조회
SELECT SALARY
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
   AND J.JOB_NAME = '과장'; -- 추가적인 조건
-->(2200000, 2500000, 3760000)

-- 2) 위의 급여들보다 높은 급여를 받는 직원들 조회
--    (그냥 과장보다만 급여 많이 받으면 조회)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
   AND SALARY > ANY (2200000, 2500000, 3760000); -- 추가적인 조건
--> 최소값인 220 만원 보다 많이받으면 무조건 조회되고 있음!! (하나라도 클 경우)

-- 3) 위의 쿼리들을 하나로 합치기 + 대리들만 골라내기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
   AND SALARY > ANY (
                        SELECT SALARY
                          FROM EMPLOYEE E, JOB J
                         WHERE E.JOB_CODE = J.JOB_CODE
                           AND JOB_NAME = '과장' -- 결과가 3행 1열
   )
   AND JOB_NAME = '대리'; -- 추가적인 조건
--> 시간 날 때 ANSI 구문으로도 바꿔보기!!

-- 사원 < 대리 < 과장 < 차장 < 부장
-- 과장직급임에도 불구하고 모든 차장직급의 급여보다도 더 많이 받는 직원들 조회 (사번, 이름, 직급명, 급여)
-- 1) 차장직급들의 급여 먼저 조회
SELECT SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE JOB_NAME = '차장';
--> (2800000, 1550000, 2490000, 2480000)

-- 2) 위의 모든 급여보다도 더 많이 받는 사람들만 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE SALARY > ALL (2800000, 1550000, 2490000, 2480000);
 
-- 3) 위의 두 단계를 합치기 + 과장 직급들만 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
 WHERE SALARY > ALL (
                        SELECT SALARY
                          FROM EMPLOYEE
                          JOIN JOB USING (JOB_CODE)
                         WHERE JOB_NAME = '차장' -- 결과가 4행 1열
 )
   AND JOB_NAME = '과장';
--> 오라클 전용 구문으로 바꿔보기

--------------------------------------------------------------------------------

/*
    3. (단일행) 다중열 서브쿼리
    
    - 조회 결과값은 한 행이지만 나열된 컬럼 수가 여러개일 떄
    - 단일행 단일열 서브쿼리로 여러개로 대체할 수 있다!!
*/

-- 이남훈 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회
-- 1) 이남훈 사원의 부서코드와 직급코드를 먼저 조회
SELECT DEPT_CODE, JOB_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '이남훈'; -- 'D5' / 'J7'
 
-- 2) 부서코드가 D5 이면서 직습코드가 J7 인 사원들 조회
--    (이름, 부서코드, 직급코드, 입사일)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
   AND JOB_CODE = 'J7';
   
-- 위의 두개를 하나의 쿼리문으로 합치기
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE DEPT_CODE = (
                        SELECT DEPT_CODE
                          FROM EMPLOYEE
                         WHERE EMP_NAME = '이남훈' -- 결과는 1행 1열
)
   AND JOB_CODE = (
                        SELECT JOB_CODE
                          FROM EMPLOYEE
                         WHERE EMP_NAME = '이남훈' -- 결과는 1행 1열
    );
--> 단일행 단일열 서브쿼리가 2개 들어간 꼴!!

-- 단일행 다중열 서브쿼리 버전으로
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE (DEPT_CORE, JOB_CODE) - (
                                    SELECT DEPT_CODE, JOP_CODE
                                      FROM EMPLOYEE
                                     WHERE EMP_NAME = '이남훈' -- 결과는 2행 1열
 );
--> (컬럼명들) = (서브쿼리) 로 한번에 일괄 동등비교가 가능해짐!!
--  단, (서브쿼리) 대신 (값들의 나열) 은 불가하다!! (문법적을 불가)
--> 앞쪽 컬럼명들과 서브쿼리 SELECT 절의 컬럼명 나열 순서가 일치해야 정확히 비교가 됨!!

-- 김규민 사원과 같은 부거코드, 같은 직급코드를 가진 사원들 조회
-- (사번, 이름, 직급코드, 사수사번)
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
  FROM EMPLOYEE
 WHERE (DEPT_CODE, JOB_CODE) = (
                                    SELECT DEPT_CODE, JOB_CODE
                                      FROM EMPLOYEE
                                     WHERE EMP_NAME = '김규민' -- 결과는 1행 2열
 );
 
-- 안성훈 사원과 직급코드, 같은 사수 사번을 가진 사원들 (사번, 이름, 직급코드, 사수 사번)
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
  FROM EMPLOYEE
 WHERE (JOB_CODE, MANAGER_ID) = (
                                    SELECT JOB_CODE, MANAGER_ID
                                      FROM EMPLOYEE
                                     WHERE EMP_NAME = '안성훈'
 );
--> 이번에는 우연의 일치로 겹치는 사람이 없음!!

--------------------------------------------------------------------------------

/*
    4. 다중행 다중열 서브쿼리
    
    - 서브쿼리 조회 결과가 여러행 여러열일 경우
    - 단일행 다중열 서브쿼리의 연장선
*/

-- 각 직급별 최소 급여를 받는 사원들 조회
-- 사번, 이름, 직급코드, 급여

-- 1) 먼저 각 직급별 최소 급여 구하기
SELECT JOB_CODE, MIN(SALARY)
  FROM EMPLOYEE
 GROUP BY JOB_CODE;
/*
    J2 3700000
    J7 1380000
    J3 3400000
    J6 2000000
    J5 2200000
    J1 8000000
    J4 1550000
*/

-- 2) 위의 목록들 중에 일치하는 사원들
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
/*
 WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
    OR (JOB_CODE, SALARY) = ('J7', 1380000)
    OR (JOB_CODE, SALARY) = ('J3', 3400000)
    OR (JOB_CODE, SALARY) = ('J6', 2000000)
    OR (JOB_CODE, SALARY) = ('J5', 2200000)
    OR (JOB_CODE, SALARY) = ('J1', 8000000)
    OR (JOB_CODE, SALARY) = ('J4', 1550000)
*/
--> 컬럼값 여러개를 한번에 묶어서 리터럴들과 동등비교 불가!! (문번에 맞지 않음!!)
WHERE (JOB_CODE, SALARY) IN (('J2', 3700000),
                             ('J7', 1380000),
                             ('J3', 3400000),
                             ('J6', 2000000),
                             ('J5', 2200000),
                             ('J1', 8000000),
                             ('J4', 1550000));
--> IN 연산자는 가능함 (한번에 묶어서 동등비교)

-- 다중행 다중열 서브쿼리 버전으로 바꾸면
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) IN (
                                SELECT JOB_CODE, MIN(SALARY)
                                  FROM EMPLOYEE
                                 GROUP BY JOB_CODE -- 결과가 7행 2열
 );
 
-- 각 부서별 최고 급여를 받는 사원들의 사번, 이름, 부서코드, 급여 조회,
-- 1) 먼저 각 부서별 최고 급여를 구하기
SELECT DEPT_CODE, MAX(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 /*
    NULL 2890000
    D1      3660000
    D9      8000000
    D5      3760000
    D6      3900000
    D2      2490000
    D8      2550000
*/

-- 2) 위의 목록에 해당하는 사원들만 조회
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, '미정'), SALARY
  FROM EMPLOYEE
 WHERE (NVL(DEPT_CODE, '미정'), SALARY) IN (
                                    SELECT NVL(DEPT_CODE, '미정'), MAX(SALARY)
                                      FROM EMPLOYEE
                                     GROUP BY DEPT_CODE -- 결과가 7행 2열
 );
--> IN 연산자는 내부적으로 동등비교를 해주기 때문에 (=) NULL 에 대한 비교 불가!!
--  해결방법 : NVL 함수를 적극 이용!!

--------------------------------------------------------------------------------

/*
    (결이 좀 다름)
    5. 인라인 뷰 (INLINE VIEW)
    
    - FROM 절에 서브쿼리를 데시하는 것 테이블명 대신에
    - 서브쿼리를 수행한 결과 (RESULT SET) 를 테이블 대신에 이용하겠다.
      즉, 서브쿼리를 수행한 결과로부터 조회하겠다.
    - 주로, SELECT 문을 이루고 있는 각 절의 실행 순서를 내맘대로 바꾸고 싶을 때 사용!!
    
    [ 표현법 ]
    FROM 테이블명
    FROM (SELECT 문)
*/

-- 보너스 포함 연봉이 3000만원 이상인 사원들의 사번, 이름, 보너스포함연봉, 부서코드를 조회
-->> 인라인뷰를 안쓸 경우
SELECT EMP_ID
     , EMP_NAME
     , ((SALARY * NVL(BONUS, 0)) + SALARY) * 12 "보너스 포함 연봉"
     , DEPT_CODE
  FROM EMPLOYEE
 WHERE ((SALARY * NVL(BONUS, 0)) + SALARY) * 12 >= 30000000;
--> WHERE 절이 SELECT 절 보다 먼저 실행되기 때문에 WHERE 절에서 별칭을 사용할 수 없음!!
--  (WHERE 절이 길어질 수 밖에 없음!! 불편하고 귀찮음!!)

-->> 인라인뷰를 쓸 경우
SELECT EMP_ID, EMP_NAME, "보너스 포함 연봉", DEPT_CODE
  FROM (
            SELECT EMP_ID
                 , EMP_NAME
                 , ((SALARY * NVL(BONUS, 0)) + SALARY) * 12 "보너스 포함 연봉"
                 , DEPT_CODE
              FROM EMPLOYEE -- 실행 결과로 RESULT SET 이 하나 나왔음!!
  )
 WHERE "보너스 포함 연봉" >= 30000000;
--> FROM 절의 서브쿼리 (인라인 뷰) 에서
--  이미 컬럼에 별칭을 부여하고 조회를 시작하기 때문에 바깥쪽 WHERE 절에서 해당 별칭을 이용할 수 있게 됨!!

-->> 인라인 뷰를 주로 사용하는 예시
--   TOP-N 분석 : 데이터베이스 상의 데이터들 중 "최상위 몇개의 자료" 를 보기 위해 사용하는 기법
--   예) 가장 키가 큰 3명
--       가장 급여가 높은 5명
--       근속 년수가 가장 긴 10명
--       가장 최근에 올라온 게시글 5개
--       ...

-- 전 직원 중 급여가 가장 높은 상위 5명
-- ROWNUM : 오라클에서 기본적으로 제공해주는 가상의 컬럼명
--          조회된 순서대로 1 에서 부터 순번을 부여해줌!!
SELECT ROWNUM, EMP_NAME, SALARY       -- 3
  FROM EMPLOYEE                       -- 1
 WHERE ROWNUM <= 5                    -- 2
 ORDER BY SALARY DESC;                -- 4
--> TOP-N 분석의 핵심은 ORDER BY 절로 먼저 정렬 후 ROWNUM 으로 위에서부터 N 개를 잘라내야함!!
--> 인라인 뷰를 쓰지 않으면 ORDER BY 절이 가장 마지막에 실행되기 때문에 제대로된 TOP-N 분석을 할 수 없게됨!!

-- 즉, ORDER BY 절이 가장 먼저 실행되게끔 하는게 TOP-N 분석의 핵심!!
-- ORDER BY 로 정렬한 RESULT SET 을 가지고 메인 쿼리에서 상위 N 개만 추려내기
SELECT ROWNUM "순번", EMP_NAME "사원명", SALARY "급여"  -- 5
  FROM(
        SELECT *                                      -- 2
          FROM EMPLOYEE                               -- 1
         ORDER BY SALARY DESC                         -- 3              
 )
 WHERE ROWNUM <= 5;                                   -- 4
--> 핵심은 ORDER BY 절이 WHERE 절 보다 먼저 실행되게 유도하는 것!!

-- 인라인 뷰 사용 시 주의할점
-- SELECT ROWNUM, EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, ...
-- SELECT ROWNUM, *
SELECT ROWNUM, E.* -- E.EMP_ID, E.EMP_NAME. E.EMP_NO, E.EMAIL, E.PHONE, ...
  FROM (
            SELECT *
              FROM EMPLOYEE
             ORDER BY SALARY DESC
  ) E
 WHERE ROWNUM <= 5;
--> SELECT 절의 * 은 SELECT * 단독으로만 쓸 수 있다!!
--  즉, 다른 컬럼명 또는 리터럴 또는 함수 또는 연산식 등과 붙여서 같이 쓸 수 없다!!
--> 인라인 뷰에도 별칭 부여 가능!!
--  별칭 부여 후 별칭.컬럼명 제시 가능, 별칭.* 을 제시 시 해당 RESULT SET 의 모든 컬럼을 다 조회하겠다. 의미

-- 각 부서별 평균 급여가 가능 높은 3개의 부서의 부서코드, 평균 급여 조회
SELECT ROWNUM, DEPT_CODE, "평균 급여"
  FROM (
            SELECT DEPT_CODE, AVG(SALARY) "평균 급여"
              FROM EMPLOYEE
             GROUP BY DEPT_CODE
             ORDER BY AVG(SALARY) DESC
  )
 WHERE ROWNUM <= 3;
--> 바깥쪽 SELECT 절에서 AVG(SALARY) 라고 하는 순간 실제 FROM 절에 제시된 테이블 또는 인라인뷰 내에서
--  SALARY 라는 이름의 컬럼을 찾고, 거기에 대해 함수식을 적용하려고 하는 것!! (SALARY : invalid identifier 오류 발생)
--> 인라인 뷰 안에 함수식이 포함되어있다면 컬럼에 별칭을 반드시 붙여줘야 한다

--> 보너스 포함 연봉이 가장 높은 상위 5명
SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0), ((SALARY * NVL(BONUS, 0)) + SALARY) * 12
  FROM(
            SELECT EMP_ID, EMP_NAME, SALARY, BONUS, ((SALARY * NVL(BONUS, 0)) + SALARY) * 12
              FROM EMPLOYEE
             ORDER BY ((SALARY * NVL(BONUS, 0)) + SALARY) * 12 DESC
  )
 WHERE ROWNUM <= 5;
--> 인라인 뷰 안에 연산식이 포함되어있다면 컬럼에 별칭을 붙이지 않아도 괜찮음!!
--  하지만 가독성 측면에서는 마찬가지로 별칭을 붙여서 쓰는게 훨씬 이득임!!

-- 가장 최근에 입사한 사원 5명 조회 (사원명, 급여, 입사일)
SELECT ROWNUM, E.* -- EMP_NAME, SALARY, HIRE_DATE
  FROM (
            SELECT EMP_NAME, SALARY, HIRE_DATE
              FROM EMPLOYEE
             ORDER BY HIRE_DATE DESC
  ) E
 WHERE ROWNUM <= 5;
  
--> 인라인 뷰가 많이 쓰이는 예시 : TOP-N 분석, 게시판

--------------------------------------------------------------------------------

/*
   * 순위를 매기는 함수(SQLD)
   
   - RANK() OVER(매개변수)
   : 공동 1위가 3명이라고 한다면 그 다음 순위가 4위
   
   - DENSE_RANK OVER(매개변수)
   : 공동 1위가 3명이더라도 그 다음 순위는 2위
   
   => 매개변수 정렬기준에는 ORDER BY 절을 적는다!!
      SELECT 절의 함수 호출 구문 전에 ORDER BY 절에 먼저 실행되는 원리!!
   
   => 순위를 매기는 함수를 WINDOW FUNCTION 이라고 부른다!!
      단, WINDOW FUNCTION 은 SELECT 절 에서만 이용 가능함!!
*/

-- 사원들의 급여가 높은 순대로 매겨서 사원명, 급여, 순위 조회
SELECT ROWNUM, EMP_NAME, SALARY
  FROM EMPLOYEE
 ORDER BY SALARY DESC;
-- ROWNUM 을 이용해서 등수를 매기고 싶으면 위에서 배운대로 ORDER BY 절이 먼저 실행되게끔 인라인 뷰를 이용!!

-- RANK() OVER(정렬기준) 이용
SELECT RANK() OVER(ORDER BY SALARY DESC), EMP_NAME, SALARY
  FROM EMPLOYEE;
--> 공동 19위 2명, 그 다음 순위는 21위

-- DENSC_RANK() OVER(정렬기준) 이용
SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC), EMP_NAME, SALARY
  FROM EMPLOYEE;
--> 공동 19위 2명, 그 다음 순위는 20위

-- 순위를 매기는 함수를 이용해도 TOP-N 분석이 가능할 것 같다!!
-- 급여가 가장 높은 5명만 조회
SELECT EMP_NAME
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC); "순위"
  FROM EMPLOYEE
  WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;
--> window functions are not allowed here 오류 발생!!
--  순위를 구해주는 윈도우 함수를 WHERE 절에 기술해서 오류남!!
--  (윈도우 함수 계열은 무조건 SELECT 절에서만 사용 가능)

-- 인라인 뷰를 이용하면 바로 해결 가능함!!
SELECT *
  FROM (
            SELECT EMP_NAME
                 , SALARY
                 , RANK() OVER(ORDER BY SALARY DESC) "순위"
              FROM EMPLOYEE
  )
 WHERE 순위 <= 5;
--> 결론 : 어찌되었든 간에 TOP-N 분석을 하려면 무조건 인라인 뷰를 써야 한다!!
