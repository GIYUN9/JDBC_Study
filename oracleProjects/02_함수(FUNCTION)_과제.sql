--검색하고자 하는 내용
-- JOB_CODE가 J7이거나 J6이면서 SALARY값이 200만원 이상이고
-- BONUS가 있고 여자이며 이메일주소는 _앞에 3글자만 있는 사원의
-- 이름, 주민등록번호, 직급코드, 부서코드, 급여, 보너스를 조회하고 싶다.
-- 정상적으로 조회가 된다면 실행결과는 2개의 행만 조회가 되어야 한다.

-- 위의 내용대로 작성한 SQL문은 아래와 같다.
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE JOB_CODE = 'J7' OR JOB_CODE = 'J6' AND SALARY > 2000000
 AND EMAIL LIKE '____%' AND BONUS IS NULL;
 
-- 위 SQL문 실행시 원하는 결과가 제대로 조회되지 않는다. 어떤 문제점들이 있는지
-- 모두 찾아서 서술하고, 조치하여 완벽한 SQL문을 작성해보자

-- 수정
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\' AND BONUS IS NOT NULL AND SUBSTR(EMP_NO, 8, 1) IN (2, 4) AND
JOB_CODE IN ('J7' ,'J6') AND SALARY >= 2000000;
-- BONUS IS NULL 에서 IS NOT NULL로 변경, EMAIL _앞에 부분에 '\' ESCAPE 추가, 여자사원 EMP_NO의 8번째 자리 2또는 4 추가
-- 우선순위 맞춰서 WHERE문 정렬