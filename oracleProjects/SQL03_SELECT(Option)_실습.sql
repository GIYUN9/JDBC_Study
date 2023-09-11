-- 1. �л��̸��� �ּ����� ǥ���Ͻÿ�. ��, ��� ����� "�л� �̸�", "�ּ���"�� �ϰ�, ������ �̸����� �������� 
-- ǥ���ϵ��� �Ѵ�.
SELECT STUDENT_NAME AS "�л� �̸�", STUDENT_ADDRESS AS "�ּ���"
FROM TB_STUDENT
ORDER BY 1;

-- 2. �������� �л����� �̸��� �ֹι�ȣ�� ���̰� ���� ������ ȭ�鿡 ����Ͻÿ�.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
ORDER BY 
    EXTRACT(YEAR FROM SYSDATE) - 
    (DECODE(SUBSTR(STUDENT_SSN,7,1),'1', '19','2','19','20') || SUBSTR(STUDENT_SSN,1,2)) +1;

-- 3. �ּ����� �������� ��⵵�� �л��� �� 1900�⵵ �й��� ���� �л����� �̸��� �й�,
-- �ּҸ� �̸��� ������������ ȭ�鿡 ����Ͻÿ�. ��, ���������� �л��̸�, �й�, ������ �ּ� �� ��µǰ�.
SELECT STUDENT_NAME AS �л��̸�, STUDENT_NO AS �й�, STUDENT_ADDRESS AS "������ �ּ�"
FROM TB_STUDENT
WHERE (NOT SUBSTR(STUDENT_NO,1,1) = 'A')
        AND (STUDENT_ADDRESS LIKE '%���%' 
        OR STUDENT_ADDRESS LIKE '%����%')
ORDER BY STUDENT_NAME;

-- 4. ���� ���а� ���� �� ���� ���̰� ���� ������� �̸��� Ȯ���� �� �ִ� SQL������ �ۼ�
-- (���а��� �а��ڵ�� �а����̺��� ��ȸ�ؼ� ã�Ƴ���������)
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR P
JOIN TB_DEPARTMENT D ON P.DEPARTMENT_NO = D.DEPARTMENT_NO
WHERE d.department_name = '���а�'
ORDER BY PROFESSOR_SSN;

-- 5. 2004�� 2�б⿡ 'C3118100' ������ ������ �л����� ������ ��ȸ�Ϸ��� �Ѵ�. ������ ����
-- �л����� ǥ���ϰ�, ������ ������ �й��� ���� �л����� ǥ���ϴ� ������ �ۼ��غ��ÿ�.
SELECT S.STUDENT_NO, TO_CHAR(POINT, '99.99')
FROM TB_STUDENT S
JOIN TB_GRADE G ON S.student_no = G.student_no
WHERE G.CLASS_NO = 'C3118100' AND TERM_NO = '200402'
ORDER BY POINT DESC;

-- 6. �л� ��ȣ, �л� �̸�, �а��̸��� �л� �̸����� ���������Ͽ� ��� SQL�� �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON s.department_no = d.department_no 
ORDER BY 2;

-- 7. �� ������б��� ���� �̸��� ������ �а� �̸��� ����ϴ� SQL������ �ۼ�
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS C
JOIN tb_department D ON c.department_no = d.department_no;

-- 8. ���� ���� �̸��� ã�������Ѵ�. �����̸��� �����̸��� ����ϴ� SQL���ۼ�
SELECT CLASS_NAME, PROFESSOR_NAME
FROM tb_professor P
JOIN tb_class C ON p.department_no = c.department_no
ORDER BY 1;

-- 9. 8���� ����� �ι���ȸ �迭�� ���� ������ �̸��� ã������ �Ѵ� SQL�� �ۼ�
SELECT CLASS_NAME, PROFESSOR_NAME
FROM tb_professor P
JOIN tb_class C ON p.department_no = c.department_no
JOIN tb_department D ON p.department_no = d.department_no
WHERE d.category = '�ι���ȸ'
ORDER BY 1;

-- 10. '�����а�' �л����� ������ ���Ϸ��� �Ѵ�. �����а� �л����� "�й�", "�л� �̸�", "��ü ����"�� ����ϴ� 
-- SQL���� �ۼ�. ��, ������ �Ҽ� 1�ڸ������� �ݿø��Ͽ� ǥ���Ѵ�.
SELECT S.STUDENT_NO AS "�й�", S.STUDENT_NAME AS "�л� �̸�", ROUND(AVG(G.POINT),1) AS "��ü ����"
FROM TB_STUDENT S
JOIN tb_grade G ON s.student_no = g.student_no
JOIN tb_department D ON s.department_no = d.department_no
WHERE d.department_name = '�����а�'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME
ORDER BY 1;

-- 11. �й��� A313047�� �л��� �б��� ������ ���� �ʴ�. ���� �������� ������ �����ϱ� ����
-- �а� �̸�, �л� �̸��� ���� ���� �̸��� �ʿ��ϴ�. �̶� ����� SQL���ۼ�
-- �������� �а��̸�, �л��̸�, ���������̸����� ���
SELECT D.DEPARTMENT_NAME AS "�а��̸�", S.STUDENT_NAME AS "�л��̸�", P.PROFESSOR_NAME AS "���������̸�"
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON S.DEPARTMENT_NO = D.DEPARTMENT_NO
JOIN TB_PROFESSOR P ON S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
WHERE S.STUDENT_NO = 'A313047';

-- 12. 2007�⵵�� '�ΰ������' ������ ������ �л��� ã�� �л��̸��� �����б⸦ ǥ���ϴ� SQL���� �ۼ�.
SELECT STUDENT_NAME, TERM_NO AS "TERM_NAME"
FROM TB_STUDENT S
JOIN TB_GRADE G ON S.STUDENT_NO = G.STUDENT_NO
JOIN tb_class C ON G.CLASS_NO = C.CLASS_NO
WHERE CLASS_NAME = '�ΰ������' AND SUBSTR(TERM_NO,1,4) = '2007'
ORDER BY 1 ASC;

-- 13. ��ü�� �迭 ���� �� ��米���� �� �� �������� ���� ������ ã�Ʊ� �����̸���
--�а��̸��� ����ϴ� SQL������ �ۼ��Ͻÿ�.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
     LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
     LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = '��ü��'
      AND PROFESSOR_NO IS NULL;
      
-- 14. �� ������б� ���ݾƾ��а� �л����� ���������� �Խ��ϰ��� �Ѵ�. �л��̸��� �������� �̸��� 
-- ã�� ���� ���� ������ ���� �л��� ��� "�������� ������"���� ǥ���ϵ��� �ϴ� SQL ���� �ۼ��Ͻÿ�. 
-- ��, �������� "�л��̸�", "��������"�� ǥ���ϸ� ���й� �л��� ���� ǥ�õǵ��� �Ѵ�.
SELECT STUDENT_NAME �л��̸�, NVL(PROFESSOR_NAME, '�������� ������') ��������
FROM TB_STUDENT S
     LEFT JOIN TB_PROFESSOR ON(PROFESSOR_NO = COACH_PROFESSOR_NO)
     JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '���ݾƾ��а�'
ORDER BY STUDENT_NO;

-- 15. ���л��� �ƴ� �л� �� ������ 4.0�̻��� �л��� ã�� �� �л��� �й�, �̸�, �а��̸�,
-- ������ ����ϴ� SQL�� �ۼ�.
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, DEPARTMENT_NAME "�а� �̸�", AVG(POINT) ����
FROM TB_STUDENT
     JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
     JOIN TB_GRADE USING(STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
ORDER BY 1;


-- 16. ȯ�������а� ����������� ���� �� ������ �ľ��� �� �ִ� SQL���� �ۼ��Ͻÿ�.
SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS
     JOIN TB_GRADE USING(CLASS_NO)
     JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = 'ȯ�������а�'
      AND CLASS_TYPE LIKE '����%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 1;

-- 17. �� ������б��� �ٴϰ� �ִ� �ְ��� �л��� ���� �� �л����� �̸��� �ּҸ� ����ϴ� SQL�� �ۼ�.
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                       FROM TB_STUDENT
                       WHERE STUDENT_NAME = '�ְ���');

-- 18. ������а����� �� ������ ���� ���� �л��� �̸��� �й��� ǥ���ϴ� SQL���� �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME
FROM (SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT)
      FROM TB_GRADE
           JOIN TB_STUDENT USING(STUDENT_NO)
      WHERE DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                             FROM TB_DEPARTMENT
                             WHERE DEPARTMENT_NAME = '������а�')
      GROUP BY STUDENT_NO, STUDENT_NAME
      ORDER BY AVG(POINT) DESC)
WHERE ROWNUM = 1;

-- 19. �� ������б��� "ȯ�������а�" �� ���� ���� �迭 �а����� �а� �� �������� ������
-- �ľ��ϱ� ���� ������ SQL ���� ã�Ƴ��ÿ�. ��, �������� "�迭 �а���",
-- "��������"���� ǥ�õǵ��� �ϰ�, ������ �Ҽ��� �� �ڸ������� �ݿø��Ͽ� ǥ�õǵ��� �Ѵ�.
SELECT DEPARTMENT_NAME "�迭 �а���", ROUND(AVG(POINT), 1)
FROM TB_DEPARTMENT
     JOIN TB_STUDENT USING(DEPARTMENT_NO)
     JOIN TB_GRADE USING(STUDENT_NO)
WHERE CATEGORY = (SELECT CATEGORY
                  FROM TB_DEPARTMENT
                  WHERE DEPARTMENT_NAME = 'ȯ�������а�')
GROUP BY DEPARTMENT_NAME
ORDER BY 1;