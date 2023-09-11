/*
    <SELECT>
    SELECT 가지고오고 싶은 정보 FROM 테이블
*/

-- 모든 사원의 정보를보여줘
SELECT * FROM EMPLOYEE;

-- 모든사원의 이름, 주민등록번호, 핸드폰번호 조회
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE;

-------------------실습--------------------
-- JOB테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;
-- DEPARTMENT 테이블의 모든컬럼 조회
SELECT * FROM department;
-- DEPARTMENT 테이블의 부서코드 부서명 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
-- EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY FROM employee;

-- <컬럼값을 통한 산술연산>
-- SELECT절 컴럼명 작성부분에 산술연산을 할 수 있다.

-- EMPLOYEE 테이블의 사원명, 사원의 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY * 12
FROM employee;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉, 보너스 포함연봉 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + (SALARY * BONUS)) * 12
FROM employee;
-- 산술연산 과정중에 NULL데이터가 포함되어 있다면 무조건 결과값은 NULL

-- 사원명, 입사일, 근무일수를 조회
-- 코드실행당시의 날짜를 표시하는상수 : SYSDATE [년/월/일/시/분/초]
-- DATE - DATE 의 결과값은 일로 표시된다.
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

-- 현재 시스템의 날짜및 시간을 조회
SELECT SYSDATE
FROM DUAL;
-- DUAL : 오라클에서 제공해주는 가상데이터테이블(더미테이터)

/*
    <컬럼명에 별칭 지정하기>
    산술연산을 하게되면 컬럼명이 지저분 해진다. 이때 컬럼명으로 별칭을 부여해서 깔끔하게 보여줄 수 있다.
    [표현법]
    컬럼명 별칭 / 컬럼명 as 별칭 / 컬럼명 "별칭" / 컬럼명 as "별칭"
    별칭에 띄어쓰기 또는 특수문자가 포함될때는  더블쿼테이션("")을 붙여줍니다.
*/

-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉, 보너스 포함연봉 조회
SELECT EMP_NAME 사원명, SALARY as 급여, BONUS "보너스", SALARY * 12 "연봉(원)",
(SALARY + (SALARY * BONUS)) * 12 as "총 소득"
FROM employee;

/*
    <리터럴>
    임의로 지정한 문자열('')
    조회된 RESULT SET의 모든 행에 반복적으로 출력
*/

-- EMPLOYEE 테이블의 사번, 사원명, 급여
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS "단위"
FROM employee;

/*
    <연결연산자 : ||>
    여러 컬럼값들을 마치 하나의 컬럼처럼 연결할 수 있다.
*/

-- 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY
FROM employee;

-- XX의 월급은 XX원입니다.
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' AS "급여정보"
FROM employee;

/*
    <DISTINCT>
    중복제거 - 컬럼에 표시된 값들을 한번씩만 조회하고자 할 때 사용
*/

-- EMPLOYEE 직급코드 조회
SELECT DISTINCT JOB_CODE 
FROM EMPLOYEE;

-- EMPLOYEE의 부서코드를 전부 조회(중복제거)
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE
-- 위처럼 작성하면 에러가 발생한다. DISTINCT는 한번만 사용이 가능하다.
SELECT DISTINCT JOB_CODE, DEPT_CODE
-- 위처럼 사용시 (JOB_CODE, DEPT_CODE) 쌍으로 묶어서 중복을 제거한 값을 보여준다.
FROM employee;

-- =============================================================================

/*
    <WHERE 절>
    조회하고자하는 테이블로부터 특정 조건에 만족하는 데이터만을 조회할 때 사용
    조건식에서도 다양한 연산자 사용이 가능
    [표현법]
    SELECT 컴럼,컬럼,컬럼연산
    FROM 테이블
    WHERE 조건;
    
    >>비교연산자<<
    >, <, >=, <=    대소비교
    =               양쪽이 같다.
    !=, ^=, <>      양쪽이 다르다.
*/

-- EMPLOYEE 에서 부서코드가 'D9'인 사원들만 조회(모든컬럼)
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드 조회
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌사원들의 사번, 사원명,부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE != 'D1';

-- 월급이 400만원 이상인 사원들의 사원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-----------------------실습문제---------------------
-- 1. 급여가 300만원 이상인 사원명, 급여, 입사일, 연봉조회
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY * 12 AS "연봉"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME, SALARY, SALARY * 12 AS "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE SALARY * 12 >= 50000000;

-- WHERE 연봉 >= 50000000; -> 에러난다 이유는 실행순서가 FORM- WHERE- SELECT이기 때문
-- 3. 직급코드가 'J3'가 아닌사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

-- 4. 급여가 350만원 이상 600만원 이하인 모든 사원의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

-- =============================================================================

/*
    <AND, OR 연산자>
    조건을 여러개 연결할 때 사용한다.
    [표현법]
    조건A AND 조건B -> 조건A와 조건B를 모두 만족하는 값만 가지고 온다.
    조건A OR 조건B -> 조건A와 조건B중 하나라도 만족하는 값은 가지고 온다.
    
    <BETWEEN AND>
    조건식에 사용되는 구문
    몇이상 몇이하인 범위에 대한 조건을 제시할 때 사용하는 연산자(이상, 이하만 가능)
    [표현법]
    비교대상 커럼 BETWEEN 하한값 AND 상한값
*/

-- 급여가 350만원 이상 600만원 이하인 모든 사원의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 급여가 350만원 미만 600만원 초과인 모든 사원의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
WHERE SALARY < 3500000 OR SALARY > 6000000;
-- NOT : 논리 부정 연산자
-- 컬럼명 앞 또는 BETWEEN앞에 선언가능

-- 입사일이 '90/01/01' ~ '01/01/01' 사원을 전체조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01'; -- DATE타입도 비교연산이가능하다.

-- BETWEEN 사용
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- =============================================================================

/*
    <LIKE>
    비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족할 경우 조회
    
    [표현법]
    비교대상컬럼 LIKE '특정패턴'; 일치하는 것, LIKE를 만족하는 것
    
    특정패턴을 제시할 때 와일드카드라는 특정패턴이 정의되어있다.
    '%' : 포함문자 검색(0글자이상 전부 조회)
    EX) 비교대상컬럼 LIKE '문자%' : 비교대상컬럼값 중에서 해당문자로 시작하는 것들만 조회
    비교대상컬럼 LIKE '%문자' : 비교대상컬럼값 중에서 해당문자로 끝나는 것들만 조회
    비교대상컬럼 LIKE '%문자%' : 비교대상컬럼값 중에서 해당문자가 포함된 값 조회
    
    '_' : 1글자를 대체해서 검색
    EX) 비교대상컬럼 LIKE '_문자' : 비교대상컬럼값의 문자앞에 아무글자나 한글자가 있는값을 조회
    비교대상컬럼 LIKE '___문자' : 비교대상컬럼값의 문자앞에 아무글자나 세글자가 있는값을 조회
    비교대상컬럼 LIKE '_문자_' : 비교대상컬럼값의 문자앞에 아무글자나 뒤에 아무글자나 한글자 있는 값 조회   
*/

-- 사원들중 성이 전씨인 사원들의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- 사원들중 이름에 하가 포함된 사원들의 사원명, 사번, 전화번호 조회
SELECT EMP_NAME, EMP_ID, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 사원들중 이름 중간글자가 하인 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

-- 전화번호의 3번째 자리가 1인 사원들의 사번, 사원명, 전화번호, 이메일 조회
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- 이메일 중 _앞글자가 3글자인 사원들의 사번, 이름, 이메일을 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
-- WHERE EMAIL LIKE ''; -> 와일드카드문자때문에 정상출력 되지 않음
-- 와일드카드문자와 일반문자의 구분이 필요하다.
-- 데이터값으로 취급하고 싶은 와일드카드 문자앞에 나만의 탈출법을 제시해서 탈출시킨다.
-- ESCAPE OPTION 을 등록해서 사용해야함
WHERE EMAIL LIKE '___\_%' ESCAPE '\'; 

-- 위 사원들이 아닌 그 외의 사원들을 조회하고 싶다 컬럼은 동일
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE NOT EMAIL LIKE '___\_%' ESCAPE '\'; 


-- ====================================실습=====================================
-- 1. 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 2. 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

-- 3. 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2400000; 

-- 4. 부서테이블에서 해외영업부인 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

-- =============================================================================
/*
    <IN 절>
    WHERE절에서 비교대상 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는지 검사
    
    [표현법]
    비교대상컬럼 IN ('값1', '값2'..)
*/

-- 부서코드가 D6이거나 D8이거나 D5인 부서원들의 이름, 부서코드, 급여를 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6', 'D8', 'D5');
-- =============================================================================
/*
    <IS NULL & IS NOT NULL>
    컬럼값에 NULL이 있을 경우 NULL값을 비교하기 위해서 사용하는 연산자   
*/
-- 보너스를 받지않은 사원들의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- 보너스를 받고 있는 사원들의 사번, 이름, 급여, 보너스
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- 사수가 없는 사원들의 사원명 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서배치를 아직 받지 않았고 보너스를 받는 사원들의 이름, 보너스, 부서코드
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

/*
    <연산자 우선순위>
    1. 산술연산자
    2. 연결연산자(||)
    3. 비교연산자
    4. IS NULL / LIKE / IN
    5. BETWEEN a AND b
    6. NOT
    7. AND
    8. OR
*/

-- 직급코드가 J7이거나 J2인 사원중에 급여가 200만원 이상인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE IN ('J7', 'J2') AND SALARY >= 2000000;

-- =================================실습========================================
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명,사번,부서코드 조회
SELECT EMP_NAME, EMP_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 2. 연봉(보너스 미포함)이 3000만원 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE (SALARY * 12) >= 30000000 AND BONUS IS NULL;


-- 3. 입사일이 '95/01/01/' 이상이고 부서배치를 받지 않은 사원들의 사번, 사원명, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NULL;

-- 4. 급여가 200만원 이상이고 500만원이하인 사원 중 입사일이 '01/01/01' 이상이고 보너스를 받지 않은
-- 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
SELECT EMP_ID,EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE (SALARY BETWEEN 2000000 AND 5000000) AND HIRE_DATE >= '01/01/01' AND BONUS IS NULL;

-- 5.보너스를 포함 연봉이 NULL이 아니고 이름에 '하'가 포함된 사원들의 사번, 사원명, 급여, 보너스포함 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY, (SALARY + (SALARY * BONUS)) * 12
FROM EMPLOYEE
WHERE SALARY IS NOT NULL AND BONUS IS NOT NULL AND EMP_NAME LIKE '%하%';

-- =============================================================================

-- 부서가 없는 사원의 사원번호, 이름, 급여를 조회
SELECT EMP_ID "사원번호", EMP_NAME AS 이름, SALARY AS "급여"
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL ;

/*
    <ORDER BY 절>
    SELECT문 가장 마지막줄에 작성, 실행순서 또한 마지막에실행
    
    [표현법]
    SELECT 조회할 컬럼들, ., ., . + 연산 AS 별칭
    FROM 조회할 테이블
    WHERE 조건식
    ORDER BY 정렬기준의 컴럼명 | 별칭 | 순서 [ASC | DESC] [NULLS FIRST | NULLS LAST]    
    
    ASC : 오름차순 [NULLS LAST]
    DESC : 내림차순 [NULLS FIRST]
    
    NULLS FIRST : NULL값을 조회할 테이블에서 앞쪽에 위치 시킬 꺼야
    NULLS LAST : NULL값을 조회할 테이블에서 뒤쪽에 위치 시킬 꺼야
*/

SELECT *
FROM employee
--ORDER BY BONUS; -- 정렬방식을 명시하지 않았을 때 오름차순 정렬[기본값]해서 가지고온다.
--ORDER BY BONUS ASC NULLS FIRST;
--ORDER BY BONUS DESC NULLS FIRST;
ORDER BY BONUS DESC, SALARY ASC;

-- 전 사원의 사원명, 연봉을 조회(연봉별 내림차순 정렬)
SELECT EMP_NAME, SALARY * 12 AS "연봉"
FROM EMPLOYEE
ORDER BY 2 DESC;