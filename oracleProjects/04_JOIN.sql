/*
    <JOIN>
    두개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는구문
    조회 결과는 하나의 결과물(RESULT SET)로 나옴
    
    관계형 데이터베이스에서는 최소한의 데이터를 각각의 데이블에 담고 있음
    (중복저장을 최소화 하기위해서 최대한 쪼개서 관리함)
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간 "관계"를 맺는 방법
    (무작정 다 조회를 해오는게 아니라 각 테이블간 연결고리로써의 데이터를 매칭시켜서 조회해야됨!)
    
    JOIN은 크게 "오라클 전용 문구" 과 "ANSI 구문"(ANSI == 미국국립표준협회)
    
    [JOIN 용어정리]
    
              오라클전용구문              |             ANSI구문
-------------------------------------------------------------------------
            등가조인                 |              내부조인
          (EQUAL JOIN)              |       (INNER JOIN) => JOIN USING/ON
--------------------------------------------------------------------------
            포괄조인                 |       왼쪽 외부 조인 (LEFT OUTER JOIN)
         (LEFT OUTER)               |       오른쪽 외부 조인(RIGHT OUTER JOIN)
         (RIGHT OUTER)              |       전체 외부 조인(FULL OUTER JOIN)
----------------------------------------------------------------------------
        자체조인 (SELF JOIN)         |              JOIN ON
    비등가 조인(NON EAUAL JOIN)      |              
----------------------------------------------------------------------------
*/

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_NO, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- 부서명을 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

/*
    1. 등가조인 (EQUAL JOIN)/ 내부조인(INNER JOIN)
    연결시키는 컬럼의 값이 일치하는 행들만 조회(== 일치하는 값이 없는 행은 조회 제외)
*/

--> 오라클 전용구문
-- FROM절에 조회하고자하는 테이블들을 나열(, 구분)
-- WHERE 절에 매칭시킬 컬럼에 대한 조건을 제시함

--1) 연결할 두 컬럼명이 다른경우(EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID)
-- 사번, 사원명, 부서코드, 부서명을 같이 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- NULL, D3, D4, D7데이터는 한쪽테이블에만 존재하기 때문에 제외된 걸 알 수 있다.
-- 일치하는 값이 없는 행은 조회에서 제외된 것을 확인할 수 있다.

--2) 연결할 두 컬럼명이 같은경우(EMPLOYEE : JOB_CODE / JOB : JOB_CODE)
-- 사번, 사원명, 직급코드, 직급명
--*테이블명 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

--*별칭 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-------------------->> ANSI 구문
-- FROM 절에 기준이 되는 테이블 하나 기술
-- JOIN절에 같이 조인하고자 하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 기술
-- JOIN USING / JOIN ON

--1) 연결한 두컬럼명이 다른 경우(EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID)
--JOIN ON만 가능

-- 사번, 사원명, 부서코드, 부서명을 같이 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_TITLE
FROM EMPLOYEE
/* INNER */ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--2) 연결할 두 컬럼명이 같은경우(EMPLOYEE : JOB_CODE / JOB : JOB_CODE)
--사번, 사원명, 직급코드, 직급명
--SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
--FROM EMPLOYEE E
--JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);
-- JOIN USING 경우에는 연결하는 컬럼명이 같을 때만 사용가능
--추가적인 조건도 제시
--직급이 대리인 사원의 사번, 이름, 직급명, 급여를 조회
--오라클구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';

--ANSI구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리';

----------------------------문제--------------------------
--1.부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회
--> 오라클 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
AND DEPT_TITLE = '인사관리부';
--> ANSI구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

--2.DEPARTMENT와 LOCATION 테이블을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--> 오라클 구문
SELECT *
FROM DEPARTMENT;
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT D, LOCATION L
WHERE LOCATION_ID = LOCAL_CODE;
--> ANSI구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

--3.보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--> 오라클구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL;
--> ANSI구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID) 
WHERE BONUS IS NOT NULL;
--4. 부서가 총무부가 아닌 사원들의 사원명, 급여 조회
--오라클 구문
SELECT EMP_NAME, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE != '총무부';
--ANSI 구문
SELECT EMP_NAME, SALARY
FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '총무부';

-----------------------------------------------------------------------------
/*
    2. 포괄조인 / 외부조인 (OUTER JOIN)
    두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜 조회 가능
    단, 반드시 LEFT/RIGHT를 지정해야된다.(기준이되는 테이블)
*/

--외부조인과 비교할만한 내부조인
--사원명, 부서명, 급여, 연봉
--부서배치를 받지 않았던 2명의 사원정보가 누락됨

--1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN
--오라클 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

--ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--2) RIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
--오라클 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

--ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--3)FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회할 수 있다(오라클X)
--ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--------------------------------------------------------------------------
/*
    3. 비등가 조인(NON EQUAL JOIN)
    매칭시킬 컬럼에 대한 조건 작성시 '='를 사용하지 않는 조인문
    ANSI구문으로는 JOIN ON만 사용가능
*/
--사원명, 급여, 급여레벨 조회
SELECT *
FROM EMPLOYEE;

--> 오라클구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
--WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;
--> ANSI구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY >= MIN_SAL AND SALARY <= MAX_SAL);

--------------------------------------------------------------------
/*
    4.자체조인 (SELF JOIN)
    같은 테이블을 다시한번 조인하는 경우
*/

-- 전체사원의 사원사번, 사원명, 사원부서코드, --> EMPLOYEE E
--           사수사번, 사수명, 사수부서코드 --> EMPLOYEE M
--> 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;
--> ANSI
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

---------------------------------------------------------------

/*
    <다중 JOIN>
    2개 이상의 테이블을 가지고 JOIN할때
*/

-- 사번, 사원명, 부서명, 직급명
--> 오라클구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID 
AND E.JOB_CODE = J.JOB_CODE;
--> ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

--사번, 사원명, 부서명, 지역명
SELECT * FROM EMPLOYEE; -- DEPT_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID   LOCATION_ID
SELECT * FROM LOCATION;  --            LOCAL_CODE

--> 오라클구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID 
    AND LOCATION_ID = LOCAL_CODE;
    
-->ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-------------------------------문제-------------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회 (EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL)
--오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
    AND D.LOCATION_ID = L.LOCAL_CODE
    AND L.NATIONAL_CODE = N.NATIONAL_CODE;
--ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE);

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
-- (EMPLOYEE, DEPARTMENT, JOB ,LOCATION, NATIONAL, SAL_GRADE)
--오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND D.LOCATION_ID = L.LOCAL_CODE
    AND L.NATIONAL_CODE = N.NATIONAL_CODE
    AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;
    
--ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);