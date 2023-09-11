/*
    <VIEW 뷰>
    
    SELECT문(쿼리문)을 저장해둘수 있는 객체
    (자주 쓰는 긴 SELECT문을 저장해두면 그 긴 SELECT문을 매번 다시 기술할 필요가 없다.)
    임시테이블 같은 존재(실제 데이터가 담겨있는 건 아님! -> 논리적인 테이블)
*/

--한국에서 근무하는사원 들의 사번, 이름, 부서명,급여, 근무국가명 조회
SELECT EMP_ID,EMP_NAME,DEPT_TITLE,SALARY,NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE)
    WHERE NATIONAL_NAME = '한국';
    
--러시아에서 근무하는사원 들의 사번, 이름, 부서명,급여, 근무국가명 조회
SELECT EMP_ID,EMP_NAME,DEPT_TITLE,SALARY,NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE)
    WHERE NATIONAL_NAME = '러시아';
    
--일본에서 근무하는사원 들의 사번, 이름, 부서명,급여, 근무국가명 조회
SELECT EMP_ID,EMP_NAME,DEPT_TITLE,SALARY,NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE)
    WHERE NATIONAL_NAME = '일본';
    
--------------------------------------------------------------------------------

/*
    1. VIEW 생성방법
    
    [표현식]
    CREATE VIEW 뷰명
    AS (서브쿼리);
*/

--TB_
--VW_

CREATE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID,EMP_NAME,DEPT_TITLE,SALARY,NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE));
    
-- GRANT CREATE VIEW TO KH;

SELECT * FROM VW_EMPLOYEE;

-- 아래와 같은 맥락
SELECT * FROM (SELECT EMP_ID,EMP_NAME,DEPT_TITLE,SALARY,NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE));

-- 뷰는 논리적인 가상테이블! 실질적으로 데이터를 저장하고 있지는 않다.
--'한국','러시아','일본'에 근무하는사라

SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

SELECT * FROM USER_VIEWS; -- 뷰 목록조회

CREATE OR REPLACE VIEW VW_EMPLOYEE -- 대체(수정)
AS (SELECT EMP_ID,EMP_NAME,DEPT_TITLE,SALARY,NATIONAL_NAME, BONUS
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
    JOIN NATIONAL USING (NATIONAL_CODE));

--------------------------------------------------------------------------------
/*
    *뷰컬럼에 별칭부여
    서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어있을 경우 반드시 별칭을 지정해야한다.
    
*/

--아래와 같은 방식으로도 부여할 수 있다.
--단 모든 컬럼의 이름을 나열해야한다.
CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 이름, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
        DECODE(SUBSTR(EMP_NO,8,1), '1','남', '2', '여'),
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

SELECT * 
FROM VW_EMP_JOB
WHERE 근무년수 >=20 ;

--뷰를 삭제하고 싶을 때
DROP VIEW VW_EMP_JOB;

--------------------------------------------------------------------------------
--생성된 뷰를 통해서 DML(INSERT, UPDATEM DELETE)사용가능
--뷰를 통해서 조작하게되면 실제 데이터가 담겨있는 베이스테이블에 반영됨

CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
    FROM JOB;

SELECT * FROM VW_JOB; -- 논리테이블(실제 데이터가 담겨있지 않음)
SELECT * FROM JOB;

--뷰를 통해서 INSERT
INSERT INTO VW_JOB VALUES('J8','인턴');

--뷰를 통해서 UPDATE
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

--------------------------------------------------------------------------------
/*
    *DML 명령어로 조작이 불가능한 경우가 더 많다. (거의 사용X)
    
    1)뷰에 정의되어있지 않은 컬럼을 조작하려고 하는 경우
    2)뷰에 정의되어있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL제약조건이 지정되어 있는 경우
    3)산술연산식 또는 함수식으로 정의가 되어있는 경우
    4)그룹함수나 GROUP BY 절이 포함된 경우
    5)DISTINCT구문이 포함된 경우
    6)JOIN을 이용해서 여러 테이블을 연결시켜놓은 경우
    
    이러한 다양한 조건에서 DML이 안되는 경우가 많아서
    대부분 뷰는 조회를 목적으로 생성한다. 그냥 뷰를 통한 DML을 안쓰는게 좋다
*/

/*
    *VIEW 옵션
    
    [상세표현식]
    CREATE [OR REPLACE] [FORCE|(NOFROCE)] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE : 기존에 동일한 뷰가 있을 경우 갱신하고, 존재하지 않을 경우 새로 생성시킨다.
    2) FORCE | NOFORCE
        > FROCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성되도록 한다.
        > NOFORCE : 서브쿼리에 기술된 테이블이 존재하는 테이블 이어야하만 뷰가 생성되게 하는 옵션(기본값)
    3) WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML이 가능하도록
    4) WITH READ ONLY : 뷰에 대해 조회만 가능하도록
*/

--2) FORCE | NOFORCE
CREATE OR REPLACE NOFORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT;

--서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 우선은 생성되게 한다.
CREATE OR REPLACE FORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT;

SELECT * FROM VW_EMP;

--TT테이블을 생성했 때 사용가능
CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(30)
);

SELECT * FROM VW_EMP;

--3) WITH CHECK OPTION : 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정시 오류발생
--WITH CHECK OPTION 안쓰고
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000;
    
SELECT * FROM VW_EMP;

--200번 사원의 급여를 200만원으로 변경(서브쿼리에 조건에 맞지 않는 변경)
UPDATE VW_EMP
SET SALARY = 2000000
WHERE EMP_ID = 200;

ROLLBACK;

CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000
WITH CHECK OPTION;

SELECT * FROM VW_EMP;

UPDATE VW_EMP
SET SALARY = 2000000
WHERE EMP_ID = 200;

--4) WITH READ ONLY : 뷰에 대해 조회만 가능하도록
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
    WITH READ ONLY;
    
SELECT * FROM VW_EMP;

DELETE
FROM VW_EMP
WHERE EMP_ID = 200;