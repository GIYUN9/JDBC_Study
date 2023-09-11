/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환한다.
    
    - 단일행 함수 : N개의 값을 읽어들여서 N개의 결과값을 리턴(매행마다 함수실행 및 결과반환)
    - 그룹함수 : N개의 값을 읽어들여서 1개의 결과값을 리턴(그룹을 지어서 그룹별로 함수실행 및 결과반환)
    
    >> SELECT절에 단일행함수와 그룹함수를 함께 사용하지 못한다.
    -> 결과 행의 갯수가 다르기 때문에 
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절 WHERE절 ORDER BY절 GROUP BY절 HAVING절
*/

-- =========================================<단일행함수>=========================
/*
    <문자 처리 함수>
    
    *LENGTH / LENGTHB => 결과값으로 NUMBER타입 반환
    -> LENGTH(컬럼 | '문자열값') : 해당문자열의 글자수를 반환
    -> LENGTHB(컬럼 | '문자열값') : 해당문자열의 바이트수를 반환
    
    '최' '너' 'ㄱ' 'ㄹ' 글자당 3BYTE
    영문자, 특수문자, 숫자 글자당 1BYTE
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE
WHERE LENGTH(EMAIL) = 15;
--------------------------------------------------------------------------------

/*
    *INSTR
    문자열로부터 특정문자의 시작위치를 찾아서 반환
    
    [표현법]
    INSTR(컬럼 | '문자열값', '찾고자하는 문자', ['찾을 위치의 시작값'.[순번]] )    

    '찾을 위치의 시작값'
    1, 2, 3 : 앞쪽부터 특정 위치를 지정할 수 있다.
    -1, -2, -3 : 뒤쪽부터 특정 위치를 지정할 수 있다.
*/

SELECT INSTR('AABAACAABBAA' ,'B') FROM DUAL; -- 앞쪽에 첫 B는 3번째 위치에 있다고 나온다.
-- 기본값은 시작위1, 순번1
SELECT INSTR('AABAACAABBAA' ,'B', 1) FROM DUAL;
SELECT INSTR('AABAACAABBAA' ,'B', -1) FROM DUAL; -- 뒤에서 부터 찾지만 위치값을 읽을 때는 앞쪽부터 읽는다
SELECT INSTR('AABAACAABBAA' ,'B', 1, 2) FROM DUAL; -- 두번째로 검색되는 B의 위치를 나타내준다.

SELECT EMAIL, INSTR(EMAIL, '@') - 1 AS "아이디길이"
FROM EMPLOYEE;

-- 이메일의 _위치값 조회
SELECT EMAIL, INSTR(EMAIL, '_', 1, 1)
FROM EMPLOYEE;
--------------------------------------------------------------------------------

/*
    *SUBSTR / 자주쓰임
    문자열에서 특정 문자열을 추출해서 반환
    
    [표현법]
    SUBSTR(STRING, POSITION, [LENGTH])  =>결과값이 CHARACTER타입
    - STRING : 문자타입컬럼 OR '문자열값'
    - POSITION : 문자열을 추출할 시작위치 값
    - LENGTH : 추출할 문자의 길이(생략시 끝가지)
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;

-- 주민등록번호에서 성별을 나타내는 문자를 추출해서 , 이름, 주민등록번호, 성별문자 출력
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) AS "성별"
FROM EMPLOYEE;

-- 여자사원들만 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) AS "성별"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1)= '2' OR SUBSTR(EMP_NO, 8, 1)= '4';
-- == WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4);

-- 남자사원들만 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) AS "성별"
FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO, 8, 1)= '1' OR SUBSTR(EMP_NO, 8, 1)= '3';
WHERE SUBSTR(EMP_NO, 8, 1) IN (1, 3)
--추가 이름순
ORDER BY 1;

-- 함수 중첩사용
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) AS "아이디"
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    *LPAD / RPAD
    문자열을 조회하면서 통일감있게 조회하고자 할때 사용
    
    [표현법]
    LPAD / RPAD(STRING, 최종적으로 반환할 문자의 길이,[덧붙이고자 하는 문자]) => 결과값은 CHARCTER
    
    문자열에 덧붙이고자 하는 문자를 왼쪽/오른쪽 에 붙여서 최종적으로 N길이 만큼 문자열을 반환
*/

-- 20만큼의 길이중 EMALL컬럼 값은 오른쪽으로 정렬하고 나머지 부분은 공백으로 채워서 조회
SELECT EMP_NAME, LPAD(EMAIL, 20)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '*')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '*')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20)
FROM EMPLOYEE;

-- 910524-1XXXXXX 조회
SELECT RPAD('910524-1',14,'*')
FROM DUAL;

-- == SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
--SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') + 1), 14, '*')
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '*******'
FROM EMPLOYEE;

/*
    *LTRIM / RTRIM
    문자열에서 특정 문자를 제거한 나머지 반환
    
    [표현법]
    LTRIM / RTRIM (STRING, [제거하고싶은 문자들]) => 결과값은 CHARACTER
    문자열의 왼쪽 혹은 오른쪽에서 제거하고자하는 문자들을 찾아서 제거한 나머지 문자열을 반환
*/

SELECT LTRIM('  K   H   ') FROM DUAL;
SELECT RTRIM('  K   H   ') FROM DUAL;
SELECT LTRIM('123123KH123', '123') FROM DUAL;
SELECT LTRIM('ACABAACCKHAC', 'ABC') FROM DUAL; --(토큰별로 검사)


SELECT RTRIM('56438546318KH85418', '0123456789') FROM DUAL;

/*
    *TRIM
    문자열의 앞/뒤 양쪽에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    
    [표현식]
    TRIM([[]제거하고하는 문자들 FROM]STRING)
*/


SELECT TRIM('   K  H    ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZKHZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZKHZZZ') FROM DUAL; -- LTRIM 유사
SELECT TRIM(TRAILING 'Z' FROM 'ZZKHZZZ') FROM DUAL; -- RTRIM 유사
SELECT TRIM(BOTH 'Z' FROM 'ZZKHZZZ') FROM DUAL; -- 양쪽을 동시에 지워줌, 생략시 기본값

/*
    *LOWER / UPPER / INITCAP
    
    [표현법]
    LOWER / UPPER / INITCAP(STIRNG) => 결과값은 CHARCTER
    LOWER : 모든 문자를 소문자로 변경한 문자열 반환
    UPPER : 모든 문자를 대문자로 변경한 문자열 반환
    INITCAP : 띄어쓰기 기준으로 첫 글자를 대문자로 변경한 문자열 반환
*/

SELECT LOWER('Welcome To My World') FROM DUAL;
SELECT UPPER('Welcome To My World') FROM DUAL;
SELECT INITCAP('Welcome To My World') FROM DUAL;

--------------------------------------------------------------------------------

/*
    *CONCAT
    문자열 두개 전달받아 하나로 합친 후 반환 => 결과값 CHARCTER
    
    [표현법]
    CONCAT(STRING,STRING)
*/

SELECT CONCAT ('가나다', 'ABC') FROM DUAL;
SELECT '가나다' || 'ABC' FROM DUAL;

/*
    *REPLACE
    특정 문자열을 다른 문자열로 대체하여 반환
    
    [표현법]
    REPLACE(STRING, 찾아낼문자열, 대체할문자열)
*/

SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'KH.or.kr', 'naver.com')
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 숫자 처리 함수 >
    
    *ABS
    숫자의 절대값을 구해주는 함수
    
    ABS(NUMBER) => 결과는 NUMBER
*/

SELECT ABS(-10) FROM DUAL;
SELECT ABS(-5.7) FROM DUAL;

--------------------------------------------------------------------------------

/*
    *MOD
    %연산자와 동일 - 두 수를 나눈 나머지 값을 반환
    
    MOD(NUMBER, NUMBER) => 결과값은 NUMBER
*/

SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;

--------------------------------------------------------------------------------

/*
    *ROUND
    반올림한 결과를 반환
    
    [표현법]
    ROUND(NUMBER, [위치]) => 결과값은 NUMBER타입
*/

SELECT ROUND(123.456) FROM DUAL; --[위치] 값 명시 없으면 1의 자리에서
SELECT ROUND(123.456, 1) FROM DUAL; --소수점 첫째자리
SELECT ROUND(123.456, -1) FROM DUAL; -- 십의자리

/*
    *CEIL
    올림처리를 위한 함수
    
    <표현법>
    CEIL(NUMBER)
*/

SELECT CEIL(123.456) FROM DUAL;

/*
    *FLOOR
    버림처리 함수
    
    <표현법>
    FLOOR(NUMBER)
*/

SELECT FLOOR(123.952) FROM DUAL;

/*
    *TRUNC
    버림처리 함수
    
    <표현법>
    TRUNC(NUMBER, [위치])
*/

SELECT TRUNC(123.952) FROM DUAL;
SELECT TRUNC(123.952, 1) FROM DUAL;
SELECT TRUNC(123.952, -1) FROM DUAL;

/*
    <날짜 처리 함수>
*/

-- SYSDATE : 시스템의 현재 날짜 및 시간 반환
SELECT SYSDATE FROM DUAL;

-- *MONTHS_BETWEEN : 두 날짜 사이의 개월수 -> 결과값은 NUMBER
-- 사원명, 입사일, 근무일수
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE),
CEIL (MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' AS "근속개월"
FROM EMPLOYEE;

-- *ADD_MONTHS : 특정 날짜에 NUMBER개월수를 더해서 반환
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;

-- 근로자 테이블에서 사원명, 입사일, 입사후 3개월 후의 날짜 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3) AS "정규직 전환일"
FROM EMPLOYEE;

--*NEXT_DAY(DATE, 요일(문자 | 숫자)) : 특정날짜 이후 가장 가까운 요일의 날짜를 반환
-- 반환값은 DATE

SELECT NEXT_DAY(SYSDATE, '토요일') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '토요일') FROM DUAL;
-- 1: 일, 2: 월요일 ............. 7:토요일
SELECT NEXT_DAY(SYSDATE, 7) FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 한국어로 설정되어있어서 에러

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- *LAST_DAY(DATE) : 해당월의 마지막 날짜 구해서 반환
--> 결과값은 DATE
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 사원테이블에서 사원명, 입사일, 입사달의 마지막날짜, 입사달의 근무일수
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE)-HIRE_DATE AS "이번달 근무일수"
FROM EMPLOYEE;

/*
    *EXTRACT : 특정 날짜로 부터 년도|월|일 값을 추출해서 반환하는 함수
    
    <표현법>
    EXTRACT (YEAR FROM DATE) : 연도만 추출
    EXTRACT (MONTH FROM DATE) : 월만 추출
    EXTRACT (DAY FROM DATE) : 일만큼 추출
    => 결과는 NUMBER
*/
-- 사원명, 입사년도, 입사월, 입사일을 조회
SELECT EMP_NAME,
EXTRACT (YEAR FROM HIRE_DATE) AS "입사년도",
EXTRACT (MONTH FROM HIRE_DATE) AS "입사월",
EXTRACT (DAY FROM HIRE_DATE) AS "입사일"
FROM EMPLOYEE
-- ORDER BY 입사년도, 입사월, 입사일;
ORDER BY 2,3,4;

--==============================================================================

/*
    <형변환 함수>
    *TO_CHAR : 숫자 타입 또는 날짜 타입의 값을 문자타입으로 변환시켜주는 함수
    
    <표현법>
    TO_CHAR(숫자|날짜, [포맷]) => 리턴은 CHARACTER
*/

--- 숫자타입 -> 문자타입
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5칸의 공간 확보, 오른쪽 정렬, 빈칸 공백
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 위와동일하지만 빈칸을 0으로 채움
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재설정된 나라의 로컬 화폐의 단위
SELECT TO_CHAR(1234, '$99999') FROM DUAL; -- 달러표시

SELECT TO_CHAR(1234, 'L99,999') FROM DUAL;

-- 사원명, 월급, 연봉, 조회
SELECT EMP_NAME, TO_CHAR(SALARY,'L9,999,999') AS "월급",
TO_CHAR(SALARY * 12,'L999,999,999') AS "연봉"
FROM EMPLOYEE;

-- 날짜타입 => 문자타입
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS AM') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') FROM DUAL; -- AM/PM 둘다 형식에 맞춰서 나옴.
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') FROM DUAL; --24시간으로 표현
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

--사원들의 이름, 입사날짜 (000년 00월 00일)조회
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"')
FROM EMPLOYEE;

--년도와 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'),
        TO_CHAR(SYSDATE, 'YY'),
        TO_CHAR(SYSDATE, 'RRRR'),
        TO_CHAR(SYSDATE, 'RR'),
        TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;


-- 월과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'MM'),
        TO_CHAR(SYSDATE, 'MON'),
        TO_CHAR(SYSDATE, 'MONTH'),
        TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

-- 일에대한 포맷
SELECT TO_CHAR(SYSDATE, 'DD'),
        TO_CHAR(SYSDATE, 'DDD'), --오늘이 이번년도의 몇번째 일수
        TO_CHAR(SYSDATE, 'D') -- 요일데이터 이번주의 D번째 날
FROM DUAL;

-- 요일에대한 포맷
SELECT  TO_CHAR(SYSDATE, 'DAY'),
        TO_CHAR(SYSDATE, 'DY')
FROM DUAL;

--==============================================================================

/*
    *TO_DATE : 숫자타입 또는 문자타입을 날짜타입으로 변경하는 함수
    
    TO_DATE(숫자 | 문자, [포맷]) => 결과 DATE
*/

SELECT TO_DATE(20100101) FROM DUAL;
SELECT TO_DATE(500101) FROM DUAL; -- 50년 미만은 자동으로 20XX으로 설정 50이상은 19XX설정

SELECT TO_DATE(070101) FROM DUAL; --숫자는 0으로 시작하면 안됨
SELECT TO_DATE('070101') FROM DUAL;

-- SELECT TO_DATE('041030 143000') -- 포맷을 정해줘야 시,분,초를 표시할 수 있다.
--SELECT TO_DATE('041030 143000', 'YYMMDD HH24MISS')
SELECT TO_DATE('140630', 'YYMMDD'),
        TO_DATE('980630', 'YYMMDD'),
        TO_DATE('980630', 'RRMMDD') -- 50년 미만은 자동으로 20XX으로 설정 50이상은 19XX설정
FROM DUAL;
--==============================================================================

/*
    *TO_NUMBER : 문자타입의 데이터를 숫자타입으로 변환시켜주는 함수
    
    <표현법>
    TO_NUMBER(문자, [포맷]) => 결과는 NUMBER
*/

SELECT TO_NUMBER('05123456789') FROM DUAL;

SELECT '100000' + '55000' FROM DUAL;
SELECT '100000' + '55,000' FROM DUAL;
SELECT TO_NUMBER('100,000', '999,999') + TO_NUMBER('55,000', '99,999')
FROM DUAL;

/*
    <NULL 처리 함수>
    
*/

-- *NVL(컬럼, 해당컬럼이 NULL일 경우 부여줄 값)
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

-- 전 사원의 이름, 보너스 포함 연봉
SELECT EMP_NAME, (SALARY + (SALARY * NVL(BONUS, 0))) *12 AS "연봉"
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음')
FROM EMPLOYEE;

--*NVL2 (컬럼, 반환값1, 반환값2)
-- 반환값1 : 해당컬럼이 존재할 경우 보여줄 값
-- 반환값2 : 해당컬럼이 NULL일 경우 부여줄 값
SELECT EMP_NAME, BONUS, NVL2(BONUS, 'O', 'X')
FROM EMPLOYEE;

SELECT EMP_NAME, NVL2(DEPT_CODE, '배정완료', '미배정')
FROM EMPLOYEE;

-- *NULLIF(비교대상1, 비교대상2)
-- 두 비교대상의 값이 일치하면 NULL 아니면 비교대상1 반환
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;

--------------------------------------------------------------------------------

/*
    <선택함수>
    *DECODE(비교하고자하는 대상(컬럼,|산술연산|함수식), 비교값1, 결과값1 , 비교값2, 결과값2 ..... 결과값N)
    자바의SWITCH문과 비슷
*/

-- 사번, 사원명, 주민번호, 성별
SELECT EMP_ID, EMP_NAME, EMP_NO,
    DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여') AS "성별"
FROM EMPLOYEE;

-- 직원의 급여조회시 각직급별로 인상해서 조회
-- J7인 사원은 급여를 10%인상해서 (SALARY * 1.1)
-- J6인 사원은 급여를 15%인상해서 (SALARY * 1.15)
-- J5인 사원은 급여를 20%인상해서 (SALARY * 1.2)
-- 그외 사원들은 급여를 5%인상(SALARY * 1.05)

-- 사원명 직급코드, 기존급여, 인상된금액
SELECT EMP_NAME, DEPT_CODE, SALARY AS 인상전,
DECODE(JOB_CODE,
    'J7',SALARY * 1.1,
    'J6',SALARY * 1.15,
    'J5',SALARY * 1.2,
        SALARY * 1.05) AS 인상후
FROM EMPLOYEE;


/*
    *CASE WHEN THEN
    
    CASE WHEN 조건식1 THEN 결과값 1
        WHEN 조건식2 THEN 결과값 2
        ...
        ELSE 결과값N
    END
    
    자바에서 IF ELSE같은 느낌이다
*/

SELECT EMP_NAME, SALARY,
        CASE WHEN SALARY >= 5000000 THEN '고급'
        WHEN SALARY >= 3500000 THEN '중급'
        ELSE '초급'
        END
FROM EMPLOYEE;

-----------------------------------< 그룹함수 >----------------------------------

-- 1. SUM(숫자타입컬럼) : 해당컬럼 값들의 총 합계를 구해서 반환해주는 함수

--EMPLOYEE테이블의 전사원 총급여
SELECT SUM(SALARY)
FROM EMPLOYEE;

--남자사원들의 총급여합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8, 1) IN(1,3);

--부서코드가 D5인 사원들의 총연봉 (보너스 제외)
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 2. AVG(NUMBER) : 해당 컬럼값들의 평균값을 구해서 반환
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- 3. MIN(모든 타입 가능) : 해당 컬럼값 중 가장 작은값 구해서 반환
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

-- 4. MAX(모든 타입 가능) : 해당컬러값들 중에 가장 큰 값을 구해서 반환
SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

-- 5. COUNT(*|컬럼|DISTINCT 컬럼) : 해당 조건에 맞는 행의 갯수를 세서 반환
--COUNT(*) : 조회된 결과에 모든 행의 갯수를 세서 반환
--COUNT(컬럼) : 제시한 해당 컬럼값이 NULL이 아닌것만 행의 갯수를 세서 반환
--COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복을 제거한 후에 행의 갯수를 세서 반환

--전체 사원 수
SELECT COUNT(*)
FROM EMPLOYEE;

--여자 사원수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2','4');

--보너스를 받는 사원수
SELECT COUNT(BONUS) -- 컬럼값을 넣으면 존재하는 행의 숫자만 세준다.
FROM EMPLOYEE;

--부서배치를 받은 사원 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;