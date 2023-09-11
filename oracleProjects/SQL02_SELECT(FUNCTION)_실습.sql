-- 1. ������а�(�а��ڵ� 002) �л����� �й��� �̸�, ���г⵵�� ���� ������ ǥ���ϴ�
-- SQL���� �ۼ��Ͻÿ� (��, ����� "�й�", "�̸�", "���г⵵" �� ǥ�õǵ��� �Ѵ�.)
SELECT STUDENT_NO AS "�й�", STUDENT_NAME AS "�̸�", TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') AS "���г⵵"
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002'
ORDER BY ���г⵵;

-- 2. �� ������б��� ���� �� �̸��� �����ڰ� �ƴ� ������ �Ѹ� �ִٰ� �Ѵ�. �� ������ �̸���
-- �ֹι�ȣ�� ȭ�鿡 ����ϴ� SQL ������ �ۼ��غ���. (*�̶� �ùٸ��� �ۼ��� SQL������ ��� ���� ����
-- �� �ٸ��� ���� �� �ִ�. ������ �������� �����غ� ��)
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE NOT PROFESSOR_NAME LIKE '___';

-- 3. �� ������б��� ���� �������� �̸��� ���̸� ����ϴ� SQL ������ �ۼ��Ͻÿ�. �� �̶�
-- ���̰� ����������� ���� ������ ȭ�鿡 ��µǵ��� ����ÿ�
-- (��, ���� �� 2000�� ���� ����ڴ� ������ ��� ����� "�����̸�", "����"�� �Ѵ�. ���̴�
-- '��' ���� ����Ѵ�.)
SELECT PROFESSOR_NAME AS "�����̸�",
  ROUND((SYSDATE - TO_DATE('19'||SUBSTR(professor_ssn, 1, 6), 'YYYYMMDD')) / 365) AS "����"
FROM TB_PROFESSOR;

-- 4. �������� �̸� �� ���� ������ �̸��� ����ϴ� SQL������ �ۼ��Ͻÿ�.
-- �������� "�̸�"�� �������� �Ѵ�. (���� 2���� ������ ���ٰ� ����)
SELECT SUBSTR(PROFESSOR_NAME,2) AS "�̸�"
FROM TB_PROFESSOR;

-- 5. �� ������б��� ����� �����ڸ� ���Ϸ��� �Ѵ�. ��� ã�Ƴ� ���ΰ�?
-- �̶� 19�쿡 �����ϸ� ����� ���� ���� ������ �����Ѵ�.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE 
    EXTRACT(YEAR FROM ENTRANCE_DATE)
    - EXTRACT(YEAR FROM TO_DATE(SUBSTR(STUDENT_SSN, 1, 6))) > 19;

-- 6. 2020�� ũ���������� ���� �����ΰ�?
SELECT TO_CHAR(TO_DATE('2020-12-25', 'YYYY-MM-DD'), 'DAY') AS day
FROM DUAL;

-- 7. TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE(49/10/11, 'YY/MM/DD')
-- �� ���� ��� ��� ������ �ǹ��ұ�? �� TO_DATE('99/10/11','RR/MM/DD'),
-- TO_DATE('49/10/11','RR/MM/DD')�� ���� ��� ��� ������ �ǹ��ұ�?
SELECT TO_DATE('99/10/11', 'YY/MM/DD'), TO_DATE('49/10/11', 'YY/MM/DD')
FROM DUAL;
-- 2000���
SELECT TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')
FROM DUAL;
-- 1999�� / 2049��

-- 8. �� ������б��� 2000�⵵ ���� �����ڵ��� �й��� A�� �����ϰ� �Ǿ��ִ�. 2000�⵵ ����
-- �й��� ���� �л����� �й��� �̸��� �����ִ� SQL ������ �ۼ��Ͻÿ�
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE NOT STUDENT_NO LIKE 'A%';

-- 9. �й��� A517178�� �ѾƸ� �л��� ���� �� ������ ���ϴ� SQL���� �ۼ��ϼ���.
-- ��, �̶� ��� ȭ���� ����� "����"�̶�� ������ �ϰ�, ������ �ݿø��Ͽ� �Ҽ��� ���� ���ڸ������� ǥ���Ѵ�.
SELECT ROUND((SUM(POINT)) /COUNT(POINT), 1) AS ����
FROM TB_GRADE G
WHERE G.STUDENT_NO = 'A517178';

-- 10. �а��� �л����� ���Ͽ� "�а���ȣ", "�л���(��)" �� ���·� ������� ����� �������
-- ��µǵ��� �Ͻÿ�.
SELECT DEPARTMENT_NO AS "�а���ȣ", COUNT(DEPARTMENT_NO) AS "�л���(��)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;


-- 11. ���� ������ �������� ���� ����� ���� �� �� ���� �Ǵ��� �˾Ƴ��� SQL���� �ۼ��Ͻÿ�.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE coach_professor_no IS NULL;

-- 12. �й��� A112113�� ���� �л��� �⵵�� ������ ���ϴ� SQL�� �ۼ�
-- ��, �̶� ��� ȭ���� ����� "�⵵", "�⵵ �� ����"�̶�� �������ϰ�,
-- ������ �ݿø��Ͽ� �Ҽ��� ���� �� �ڸ������� ǥ���Ѵ�.
SELECT SUBSTR(TERM_NO,1,4) AS �⵵, ROUND(AVG(POINT),1) AS "�⵵ �� ����"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO,1,4);

-- 13. �а� �� ���л� ���� �ľ��ϰ��� �Ѵ�. �а� ��ȣ�� ���л� ���� ǥ���ϴ� SQL ������ �ۼ��Ͻÿ�.
SELECT DEPARTMENT_NO �а��ڵ��, COUNT(DECODE(ABSENCE_YN, 'Y', 1)) "���л� ��"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;
-- / 0�� �а� ����???

-- 14. �� ���б��� �ٴϴ� �������� �л����� �̸��� ã���Ѵ�.
SELECT STUDENT_NAME AS �����̸�, COUNT(*) AS "������ ��"
FROM TB_STUDENT
WHERE STUDENT_NAME = STUDENT_NAME
GROUP BY STUDENT_NAME
HAVING COUNT(*) >= 2;

-- 15. �й��� A112113�� ���� �л��� �⵵, �б� �� ������ �⵵ �� ���� ����, �� ������ ���ϴ�
-- SQL ���� �ۼ��Ͻÿ�
-- ��, ������ �Ҽ��� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.
SELECT SUBSTR(TERM_NO,1,4) AS "�⵵", 
    CASE
        WHEN SUBSTR(TERM_NO,6,1) = '1' THEN '01'
        WHEN SUBSTR(TERM_NO,6,1) = '2' THEN '02'
        WHEN SUBSTR(TERM_NO,6,1) = '3' THEN '03'
        WHEN SUBSTR(TERM_NO,6,1) = '4' THEN '04'
        END AS "�б�",
        ROUND(AVG(POINT),1) AS "����"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY TERM_NO
ORDER BY TERM_NO;
-- �⵵�� ����????