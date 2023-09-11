--1. JOB 테이블의 모든 정보 조회
SELECT * FROM JOB;

--2. JOB 테이블의 직급 이름 조회
SELECT JOB_NAME FROM JOB;

--3. DEPARTMENT 테이블의 모든 정보 조회
SELECT * FROM department;

--4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;

--5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;

--6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
SELECT EMP_NAME, SALARY*12 AS "연봉", (SALARY + (SALARY * NVL(BONUS, 0))) *12 AS "총수령액", 
    (((SALARY + (SALARY * NVL(BONUS, 0))) *12) - ((SALARY*12)*0.03)) AS "실수령액"
FROM EMPLOYEE;

--7. EMPLOYEE테이블에서 SAL_LEVEL이 S1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE
FROM EMPLOYEE
WHERE SAL_LEVEL = 'S1'
JOIN 
-- 모르겠습니다.

--8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
SELECT EMP_NAME, SALARY, (((SALARY + (SALARY * NVL(BONUS, 0))) *12) - ((SALARY*12)*0.03)) AS "실수령액"
    ,HIRE_DATE
FROM EMPLOYEE
WHERE (((SALARY + (SALARY * NVL(BONUS, 0))) *12) - ((SALARY*12)*0.03)) >= 50000000;

--9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';

--10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중
-- 고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5') AND HIRE_DATE > '02/01/01';

--11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01';

--12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

--13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

--14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고
-- 고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\' AND DEPT_CODE IN ('D9', 'D6')
    AND HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '00/12/01'
    AND SALARY >= 2700000;
    
--15. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 1,6)
FROM EMPLOYEE;

--16. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME, SUBSTR(EMP_NO, 1,7) || '*******'
FROM EMPLOYEE;

--17. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME, FLOOR(ABS(HIRE_DATE - SYSDATE)) AS "근무일수1",
        FLOOR(ABS(HIRE_DATE - SYSDATE)) AS "근무일수2"
FROM EMPLOYEE;

--18. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = 1;

--19. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE FLOOR(ABS(HIRE_DATE - SYSDATE)) >= 365*12;

--20. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME, TO_CHAR(SALARY, '99,999,999')
FROM EMPLOYEE;

--21. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
-- (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며
-- 나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)

/* EMPLOYEE 테이블 EMP_NO의 값중 **9565같은 95월 65일은 존재 X 변경후 커밋 */
SELECT EMP_NAME, DEPT_CODE, SUBSTR(EMP_NO, 1,2) || '년 ' 
        || SUBSTR(EMP_NO, 3, 2) || '월 '
        || SUBSTR(EMP_NO, 5, 2) || '일' AS "생년월일"
        , FLOOR((SYSDATE-TO_DATE(SUBSTR(EMP_NO,1,6)))/365) AS "나이(만)"
FROM EMPLOYEE;

--22. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부, D6면 기획부, D9면 영업부로 처리
-- (단, 부서코드 오름차순으로 정렬)
SELECT EMP_NAME, CASE 
            WHEN DEPT_CODE = 'D5' THEN '총무부'
            WHEN DEPT_CODE = 'D6' THEN '기획부'
            WHEN DEPT_CODE = 'D9' THEN '영업부'
            ELSE '기타'
            END
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6','D9');

-- 23. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리,
-- 주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_NAME, SUBSTR(EMP_NO,1,6), SUBSTR(EMP_NO,8,7), SUBSTR(EMP_NO,1,6) + SUBSTR(EMP_NO,8,7)
FROM EMPLOYEE
WHERE EMP_ID = 201;

--24. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM((SALARY+(SALARY*BONUS))*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--25. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
-- 전체 직원 수, 2001년, 2002년, 2003년, 2004년
SELECT TO_CHAR(HIRE_DATE, 'YYYY') AS 입사년도, COUNT(*)
FROM EMPLOYEE
GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
ORDER BY 1;

