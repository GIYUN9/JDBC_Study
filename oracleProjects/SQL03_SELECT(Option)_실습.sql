-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 
-- 표시하도록 한다.
SELECT STUDENT_NAME AS "학생 이름", STUDENT_ADDRESS AS "주소지"
FROM TB_STUDENT
ORDER BY 1;

-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
ORDER BY 
    EXTRACT(YEAR FROM SYSDATE) - 
    (DECODE(SUBSTR(STUDENT_SSN,7,1),'1', '19','2','19','20') || SUBSTR(STUDENT_SSN,1,2)) +1;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년도 학번을 가진 학생들의 이름과 학번,
-- 주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 학생이름, 학번, 거주지 주소 가 출력되게.
SELECT STUDENT_NAME AS 학생이름, STUDENT_NO AS 학번, STUDENT_ADDRESS AS "거주지 주소"
FROM TB_STUDENT
WHERE (NOT SUBSTR(STUDENT_NO,1,1) = 'A')
        AND (STUDENT_ADDRESS LIKE '%경기%' 
        OR STUDENT_ADDRESS LIKE '%강원%')
ORDER BY STUDENT_NAME;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL문장을 작성
-- (법학과의 학과코드는 학과테이블을 조회해서 찾아내도록하자)
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR P
JOIN TB_DEPARTMENT D ON P.DEPARTMENT_NO = D.DEPARTMENT_NO
WHERE d.department_name = '법학과'
ORDER BY PROFESSOR_SSN;

-- 5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 학점이 높은
-- 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
SELECT S.STUDENT_NO, TO_CHAR(POINT, '99.99')
FROM TB_STUDENT S
JOIN TB_GRADE G ON S.student_no = G.student_no
WHERE G.CLASS_NO = 'C3118100' AND TERM_NO = '200402'
ORDER BY POINT DESC;

-- 6. 학생 번호, 학생 이름, 학과이름을 학생 이름으로 오름차순하여 출력 SQL문 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON s.department_no = d.department_no 
ORDER BY 2;

-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL문장을 작성
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS C
JOIN tb_department D ON c.department_no = d.department_no;

-- 8. 과목별 교수 이름을 찾으려고한다. 과목이름과 교수이름을 출력하는 SQL문작성
SELECT CLASS_NAME, PROFESSOR_NAME
FROM tb_professor P
JOIN tb_class C ON p.department_no = c.department_no
ORDER BY 1;

-- 9. 8번의 결과중 인문사회 계열에 속한 교수의 이름을 찾으려고 한다 SQL문 작성
SELECT CLASS_NAME, PROFESSOR_NAME
FROM tb_professor P
JOIN tb_class C ON p.department_no = c.department_no
JOIN tb_department D ON p.department_no = d.department_no
WHERE d.category = '인문사회'
ORDER BY 1;

-- 10. '음악학과' 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 
-- SQL문장 작성. 단, 평점은 소수 1자리까지만 반올림하여 표시한다.
SELECT S.STUDENT_NO AS "학번", S.STUDENT_NAME AS "학생 이름", ROUND(AVG(G.POINT),1) AS "전체 평점"
FROM TB_STUDENT S
JOIN tb_grade G ON s.student_no = g.student_no
JOIN tb_department D ON s.department_no = d.department_no
WHERE d.department_name = '음악학과'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME
ORDER BY 1;

-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한
-- 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL문작성
-- 출력헤더는 학과이름, 학생이름, 지도교수이름으로 출력
SELECT D.DEPARTMENT_NAME AS "학과이름", S.STUDENT_NAME AS "학생이름", P.PROFESSOR_NAME AS "지도교수이름"
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON S.DEPARTMENT_NO = D.DEPARTMENT_NO
JOIN TB_PROFESSOR P ON S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
WHERE S.STUDENT_NO = 'A313047';

-- 12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL문장 작성.
SELECT STUDENT_NAME, TERM_NO AS "TERM_NAME"
FROM TB_STUDENT S
JOIN TB_GRADE G ON S.STUDENT_NO = G.STUDENT_NO
JOIN tb_class C ON G.CLASS_NO = C.CLASS_NO
WHERE CLASS_NAME = '인간관계론' AND SUBSTR(TERM_NO,1,4) = '2007'
ORDER BY 1 ASC;

-- 13. 예체능 계열 과목 중 담당교수를 한 명도 배정받지 못한 과목을 찾아그 과목이름과
--학과이름을 출력하는 SQL문장을 작성하시오.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
     LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
     LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = '예체능'
      AND PROFESSOR_NO IS NULL;
      
-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과 지도교수 이름을 
-- 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정"으로 표시하도록 하는 SQL 문을 작성하시오. 
-- 단, 출력헤더는 "학생이름", "지도교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT S
     LEFT JOIN TB_PROFESSOR ON(PROFESSOR_NO = COACH_PROFESSOR_NO)
     JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

-- 15. 휴학생이 아닌 학생 중 평점이 4.0이상인 학생을 찾아 그 학생의 학번, 이름, 학과이름,
-- 평점을 출력하는 SQL문 작성.
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME "학과 이름", AVG(POINT) 평점
FROM TB_STUDENT
     JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
     JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 1;


-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL문을 작성하시오.
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS
     JOIN TB_GRADE USING(CLASS_NO)
     JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과'
      AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 1;

-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL문 작성.
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                       FROM TB_STUDENT
                       WHERE STUDENT_NAME = '최경희');

-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME
FROM (SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT)
      FROM TB_GRADE
           JOIN TB_STUDENT USING(STUDENT_NO)
      WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                             FROM TB_DEPARTMENT
                             WHERE DEPARTMENT_NAME = '국어국문학과')
      GROUP BY STUDENT_NO, STUDENT_NAME
      ORDER BY AVG(POINT) DESC)
WHERE ROWNUM = 1;

-- 19. 춘 기술대학교의 "환경조경학과" 가 속한 같은 계열 학과들의 학과 별 전공과목 평점을
-- 파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명",
-- "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.
SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT), 1)
FROM TB_DEPARTMENT
     JOIN TB_STUDENT USING(DEPARTMENT_NO)
     JOIN TB_GRADE USING(STUDENT_NO)
WHERE CATEGORY = (SELECT CATEGORY
                  FROM TB_DEPARTMENT
                  WHERE DEPARTMENT_NAME = '환경조경학과')
GROUP BY DEPARTMENT_NAME
ORDER BY 1;