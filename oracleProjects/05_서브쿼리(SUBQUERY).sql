/*
    *서브쿼리 (SUBQUERY)
    -하나의 SQL문 안에 포함된 또 다른 SELECT문
    -메인 SQL문을 위해 보조 역할을 하는 쿼리문
*/

--간단한 서브쿼리 예시1.
--노옹철 사원과 같은 부서에 속한 사원들 조회
--1) 노옹철 사원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

--2) 부서코드가 D9인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 위의 두 단계를 하나의 쿼리문으로!
SELECT EMP_NAME
FROM EMPLOYEE
-- WHERE DEPT_CODE = 노옹철사원의 부서코드
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');

--간단한 서브쿼리 예시2
--전 직원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회
--1) 전 직원의 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE; -- 3047663

--2)3047663보다 더 많은 급여를 받는 사원들의 사번, 이름 ,직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

--두 단계를 하나로 합해보자!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY))
                    FROM EMPLOYEE);
                    
/*
    *서브쿼리의 구분
    서브쿼리를 수행한 결과값이 몇행 몇열로 나오냐에 따라서 분류됨
    
    - 단일행 서브쿼리 : 서브쿼리의 조회 결과값의 갯수가 오로지 1개일 때
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행일 때(여러행 한열)
    - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 한 행이지만 컬럼이 여러개일 때(한행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 여러컬럼일 때 (여러행 여러열)
    
    >> 서브쿼리의 종류가 뭐냐에 따라서 서브쿼리 앞에 붙는 연산자가 달라짐
*/                              

/*
    1. 단일행 서브쿼리
    서브쿼리의 조회 결과값의 갯수가 오로지 1개일 떄(한행 한열)
    일반 비교연산자 사용 가능
    = != > <= ...
*/

--1) 전 직원의 평균 급여보다 급여를 더 적게받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                    FROM EMPLOYEE);
                    
--2)최저급여를 받는 사원의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
--WHERE SALARY = 모든직원중 최저급여
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
--3)노옹철 사원의 급여보다 많이 받는 사원들의 사번, 이름, 부서코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE SALARY > 노옹철 사원의 급여;
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
                
--4)노옹철 사원의 급여보다 많이 받는 사원들의 사번, 이름, 부서명, 급여조회
--오라클구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND SALARY > (SELECT SALARY
                                        FROM EMPLOYEE
                                        WHERE EMP_NAME = '노옹철');
                                        
--ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
                                        
--GROUP_BY 복습
--4) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합
--4_1) 부서별 급여합중에서 가장 큰 값 하나만 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17700000

--4_2)부서별 급여합이 17700000인 부서의 부서코드 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

--위 두 쿼리를 합해보자
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                        GROUP BY DEPT_CODE);

--'전지연'사원과 같은 부서의 사람들의 사번, 사원명, 전화번호, 입사일, 부서명을 조회
-- 단, 전지연사원은 제외
--> 오라클구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
    AND DEPT_CODE = (SELECT DEPT_CODE
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '전지연')
    AND EMP_NAME != '전지연';
--> ANSI구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '전지연')
    AND EMP_NAME != '전지연';

--------------------------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리
    서브쿼리를 수행한 결과값이 여러행일 때 (컬럼은 한개)

     IN (서브쿼리) : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 조회
     > ANY (서브쿼리) : 여러개의 결과값 중에서 한개라도 클경우
     < ANY (서브쿼리) : 여러개의 결과값 중에서 한개라도 작을경우 조회
        비교대상 > ANY ((서브쿼리의 결과값 =) 값1, 값2, 값3)
        비교대상 > 값1 OR  비교대상 > 값2 OR 비교대상 > 값3
        
     > ALL (서브쿼리) : 여러개의 모든 결과값들 보다 클경우
     < ALL (서브쿼리) : 여러개의 모든 결과값들 보다 작을 경우
        비교대상 > ALL ((서브쿼리의 결과값 =) 값1, 값2, 값3)
        비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
*/

--1) 유재식 또는 윤은해 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여
--1_1) 유재식 또는 윤은해 사원의 직급코드
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('윤은해','유재식'); -- J3, J7

--1_2) J3,J7의 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3','J7');

--두 쿼리를 서브쿼리를 통해 합해보자
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME 
                    IN ('윤은해','유재식'));
                    
--2) 대리 직급임에도 과장 직급 급여들 중 최소 급여보다 많이 받는 직원들 조회
--(사번, 이름, 직급, 급여)
--2_1) 과장 직급 급여들 -- 100, 200, 300
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장'; -- 3760000, 2200000, 2500000

--2_2)대리직급이면서 위의 결과값 보다 하나라도 큰 사원 조회 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE 
    AND SALARY > ANY (2200000, 2500000, 3760000);
    
--두 쿼리를 합해주자
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE 
    AND SALARY > ANY (SELECT SALARY
                        FROM EMPLOYEE
                        JOIN JOB USING (JOB_CODE)
                        WHERE JOB_NAME = '과장')
    AND JOB_NAME = '대리';
    
--단일행으로 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE 
    AND SALARY > ANY (SELECT MIN(SALARY)
                        FROM EMPLOYEE
                        JOIN JOB USING (JOB_CODE)
                        WHERE JOB_NAME = '과장')
    AND JOB_NAME = '대리';

-------------------------------------------------------------------------

/*
    3. 다중열 서브쿼리
    결과값은 한 행이지만 나열된 컬럼수가 여러개일 경우
*/

--1) 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회
--(사원명, 부서코드, 직급코드, 입사일)
--> 단일행 서브쿼리로 가능은 함
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유') -- 하이유사원의 부서코드
    AND JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유'); -- 하이유사원의 직급코드
-- 다중열 서브쿼리로 작성
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '하이유');

--박나라 사원과 같은 직급코드, 같은 사수를 가지고있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회
--1) 박나라 사원의 직급코드, 사수코드를 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라'; --J7	207

--1_2) J7	207의 결과값을 가진 사람들의 사번, 사원명, 직급코드, 사수번호 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                    FROM EMPLOYEE
                                    WHERE EMP_NAME = '박나라')
    AND EMP_NAME != '박나라';
    
--------------------------------------------------------------------------
/*
    4.다중행 다중열 서브쿼리
    서브쿼리의 조회 결과값이 여러행 여러열일경우
*/

-- 1) 각 직급별 최소급여를 받는 사원조회(사번, 사원명, 직급코드, 급여)
--> 각 직급별 최소급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;
/*
J2	3700000
J7	1380000
J3	3400000
J6	2000000
J5	2200000
J1	8000000
J4	1550000
*/
-- 1) 각 직급별 최소급여를 받는 사원조회(사번, 사원명, 직급코드, 급여)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
    OR JOB_CODE = 'J7' AND SALARY = 1380000
    OR JOB_CODE = 'J3' AND SALARY = 3400000
 --   ...
;

--서브쿼리로 적용
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY JOB_CODE);
--2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

--------------------------------------------------------------------------------
/*
    5. 인라인 뷰
    FROM절에 서브쿼리를 작성한 것
    서브쿼리를 수행한 결과를 마치 테이블처럼 사용
*/

--사원들의 사번, 이름, 보너스포함연봉, 부서코드 조회
--단, 보너스포함 연봉은 NULL이 되면 안된다.
--단, 보너스 포함연봉이 3000만원 이상인 사원들만 조회해보자
SELECT ROWNUM, EMP_ID, EMP_NAME, ((SALARY+(SALARY*NVL(BONUS,0))) * 12) AS "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE  ((SALARY+(SALARY*NVL(BONUS,0))) * 12) >= 30000000
ORDER BY 연봉 DESC;

--> 인라인뷰를 주로 사용하는 예 >> TOP-N분석 : 상위 몇개만 조회
-- 전직원중 급여가 가장높은 5명만 조회
--*ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE  ROWNUM <= 5
ORDER BY SALARY DESC;

--> ORDER BY절이 수행된 걸과를 가지고 ROWNUM부여후 5명만 추리기
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

--가장 최근에 입사한 사원 5명 조회(사원명, 급여, 입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC) E
WHERE ROWNUM <= 5;

-- 각 부서별 평균급여가 높은 3개의 부서조회
-- 부서코드, 평균급여를 나타내자
SELECT DEPT_CODE, FLOOR(평균급여)
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "평균급여"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY 2 DESC)
WHERE ROWNUM <= 3;

--------------------------------------------------------------------------------

/*
    *순위를 매기는 함수 (WINDOW FUNCTION)
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
    RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위계산
                            (공동 순위)
    DANSE_RANK() OVER(정렬기준) : 동일한 순위가 있다고 해도 그 다음 등수를 무조건 1씩 증가시킴
    
    -무조건 SELECT절에서만 사용이 가능하다.
*/
-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE;
-->공동 19등 2명 그 뒤의 등수는 21등으로 하나 건너 뛴 것을 할수있다.


SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE;
--> 19등이 공동이지만 그 뒤에 20등이바로 나오는 것을 알 수 있다.

SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "순위"
        FROM EMPLOYEE)
WHERE 순위 <= 5;

------------------------------------문제----------------------------------------
--1) ROWNUM을 활용하여 급여가 가장 높은 5명을 조회하고 싶었으나, 제대로 조회가 되지 않는다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--문제점을 서술하고 (원인) : 코드가 실행되는 순서상 정렬이 되기전에 5명이 이미 추려진다
--수정코드 (조치):
SELECT E.EMP_NAME, E.salary 
FROM (SELECT EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--2) 부서별 평균급여가 270만원을 초과하는 부서들에 대해
-- (부서코드, 부서별 총 급여합, 부서별 평균 급여, 부서별 사원수)를 조회
SELECT DEPT_CODE, SUM(SALARY) AS "총합", FLOOR(AVG(SALARY)) AS "평균", COUNT(*) AS 인원수
FROM EMPLOYEE
WHERE SALARY > 2700000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;

--문제점을 서술하고 (원인) : 부서별 평균 급여가 270만원을 초과하는 조건은 HAVING절로 기술해야한다.
--수정코드 (조치):
SELECT DEPT_CODE, SUM(SALARY) AS "총합", FLOOR(AVG(SALARY)) AS "평균", COUNT(*) AS 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) > 2700000
ORDER BY DEPT_CODE ASC;

-- 또는

SELECT *
FROM(SELECT DEPT_CODE, SUM(SALARY) AS "총합", FLOOR(AVG(SALARY)) AS "평균", COUNT(*) AS 인원수
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY DEPT_CODE ASC)
WHERE 평균 >= 2700000;