/*
    <PL/SQL>
    
    오라클 자체에 내장되어 있는 절차적 언어
    SQL문장 내에서 변수의 정의, 조건(IF), 반복(LOOP, FOR, WHILE)등을 지원하여 SQL의 단점을 보완
    다수의 SQL문을 한번에 실행가능
    
    *PL/SQL 구조
    -[선언부] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
    -실행부 : BEGIN로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
    -[예외처리부] : EXCEPTION으로 시작, 예외발생시 해결하기위한 구문을 미리 기술해둘 수 있는 부분
*/

--*간단하게 화면에 HELLO ORACLE출력
SET SERVEROUTPUT ON;

BEGIN
    --SYSTEM.OUT.PRINT("")
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

--------------------------------------------------------------------------------
/*
    1. DECLARE 선언부
        변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능하다)
        일반타입변수, 레퍼런스타입변수, ROW타입변수
        
        1_1)일반타입변수 선언및 초기화
            [표현식] 변수명 [CONSTANT] 자료형 [:=값]
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 800;
    ENAME := '최지원';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

-- &입력 숫자 '&입력' 문자,열

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/
--------------------------------------------------------------------------------
--1_2) 레퍼런스 타입 변수 선언및 초기화(어떤테이블의 어떤칼럼의 데이터타입을 참조해서 그 타입으로 지정))
--[표현식] 변수명 테이블명.컬럼명%TYPE;

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
--    EID := '300';
--    ENAME := '최지원';
--    SAL := 3000000;
    
    -- 사번이 200번인 사원의 사번, 사원명, 급여조회
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
--    WHERE EMP_ID = 200;
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    
END;
/

--------------------------------------------------------------------------------
/*
    레퍼런스타입 변수로 EID, ENAME, JCODE, SAL, DTITLE
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY) DEPARTMENT(DEPT_TITLE)등을 참조 하도록
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명, 조회 후 각 변수에 담아 출력해라
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
END;
/

--------------------------------------------------------------------------------
--1_3) ROW타입 변수 선언
-- 테이블의 한 행에대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
-- [표현식] 변수명 테이블명%ROWTYPE;

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, 0));
END;
/

--------------------------------------------------------------------------------
--2. BEGIN 실행부
-- <조건문>
-- 1)IF 조건식 THEN 실행내용 END IF; (단일 IF문)

--사번을 입력받아 해당 사원의 사번, 이름, 급여, 보너스율 출력

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    
    -- 보너스를 받지 않는 사원이라면 '보너스를 지급받지 않는 사원입니다.'
    IF BONUS = 0 
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;(IF ~ ELSE)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    
    -- 보너스를 받지 않는 사원이라면 '보너스를 지급받지 않는 사원입니다.'
    IF BONUS = 0 
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
    END IF;
END;
/

------------------------------------문제----------------------------------------
DECLARE
-- 레퍼런스타입변수(EID, ENAME, DTITLE, NCODE)
-- 참조컬럼(EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE)
-- 일반타입변수(TEAM 문자열) <= 국내팀 또는 해외팀 담을 예정
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
BEGIN
-- 사용자가 입력한 사번의 사원을 찾아 사번, 이름, 부서명, 근무국가코드, 조회후 각 변수에 대입
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &사번;
-- NCODE 값이 KO일경우 TEAM에 '국내팀' 대입
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
-- 그게 아닐경우 TEAM에 '해외팀' 대입
        ELSE TEAM := '해외팀';
    END IF;
-- 사번, 이름, 부서, 소속출력
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('소속 : ' || TEAM);
END;
/

-- 3) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2.... [ELSE 실행내용] END IF;

DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    -- 당신의 점수는 XX이고, 학점은 X입니다.
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' ||SCORE||'이고, 학점은 '|| GRADE ||'입니다.');
END;
/

--------------------------------------문제---------------------------------------
--사용자에게 입력받은 사번의 사원을 찾아 급여를 조회해서 SAL변수에 대입
--500만 이상이면 '고급'
--400만 이상이면 '중급'
--300만 이상이면 '초급'
--해당 사원의 급여등급은 XX입니다.

DECLARE
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT EMP_NAME, SALARY
    INTO ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 4000000 THEN GRADE := '중급';
    ELSIF SAL >= 3000000 THEN GRADE := '초급';
    ELSE GRADE := '미흡';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여등급은 '||GRADE||'입니다.');
END;
/

--------------------------------------------------------------------------------
--4) CASE 비교대상 WHEN 동등비교할값1 THEN 결과값1 WHEN 비교할값2 THEN 결과값2... ELSE 결과값 END;
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE 
            WHEN 'D1' THEN '인사관리부'
            WHEN 'D2' THEN '회계관리부'
            WHEN 'D3' THEN '마케팅부'
            WHEN 'D4' THEN '국내영업부'
            ELSE '해외영업부'
            END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은 ' || DNAME || '입니다.' );
END;
/

--------------------------------------------------------------------------------

-- <반복문>
/*
    1) BASIC LOOP문
    
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        *반복문을 탈출할 수 있는 구문
    END LOOP;
    
    *반복문을 탈출할 수 있는 구문(2가지)
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식;
*/

-- 1~5까지 순차적으로 1씩 증가하는 값을 출력해라
DECLARE
    I NUMBER :=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        -- IF I = 6 THEN EXIT; END IF;
        EXIT WHEN I = 6;
    END LOOP;
END;
/

--------------------------------------------------------------------------------
/*
    2) FOR LOOP문
    [표현식]
    FOR 변수 IN [REVERSE] 초기값..마지막값
    LOOP
        반복적으로 진행할 구문
    END LOOP;
*/

BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

DROP TABLE TEST;
CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

CREATE SEQUENCE SEQ_TNO
START WITH 1
INCREMENT BY 2
MAXVALUE 1000
NOCYCLE
NOCACHE;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/

--------------------------------------------------------------------------------
/*
    3) WHILE LOOP
    
    [표현식]
    WHILE 반복문이 수행될 조건
    LOOP
        반복실행할 구문
    END LOOP;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
    END LOOP;
END;
/

--------------------------------------------------------------------------------
/*
    3. 예외처리부
    예외 : 실행 중 발생하는 오류
    
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1;
        WHEN 예외명2 THEN 예외처리구문2;
        ...
        WHEN 예외명N THEN 예외처리구문N;    
    *시스템 예외 (오라클에서 미리 정의해둔 예외)
    -NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 때
    -TOO_MANY_ROWS : SELECT한 결과가 여러행일경우
    -ZERO_DIVIDE : 0으로 나눌때
    -DUP_VAL_ON_INDEX : UNIQUE제약조건에 위배되었을 때
    ...
*/
-- 사용자가 입력한 수로 나눗셈한 결과 출력
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
EXCEPTION
--  WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산을 0으로 할수 없음');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('에러남ㅋㅋ');
END;
/

--UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID= '&변경할사번'
    WHERE EMP_NAME = '노옹철';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회결과가 없습니다.');
END;
/

