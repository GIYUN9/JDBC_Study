-- 1. �� ������б��� �а� �̸��� �迭�� ǥ���Ͻÿ�.
-- ��, �������� "�а� ��", "�迭"���� ǥ���ϵ��� �Ѵ�.
SELECT DEPARTMENT_NAME AS "�а� ��", CATEGORY AS "�迭"
FROM TB_DEPARTMENT;

-- 2. �а��� �а� ������ ������ ���� ���·� ȭ�鿡 ����Ѵ�.
SELECT DEPARTMENT_NAME||'�� ������ ' || CAPACITY || '�� �Դϴ�.' AS "�а��� ����"
FROM TB_DEPARTMENT;

-- 3. "������а�" �� �ٴϴ� ���л� �� ���� ���e���� ���л��� ã�ƴ޶�� ��û�� ���Դ�.
-- �����ΰ�? (�����а��� '�а��ڵ�'�� �а� ���̺�(TB_DEPARTMENT)�� ��ȸ�ؼ� ã�� ������ ����)
SELECT STUDENT_NAME
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON D.DEPARTMENT_NO = S.DEPARTMENT_NO
WHERE D.DEPARTMENT_NAME = '������а�' 
        AND ABSENCE_YN = 'Y'
        AND SUBSTR(STUDENT_SSN, 8,1) IN ('2','4');
        
-- 4. ���������� ���� ���� ��� ��ü�� ���� ã�� �̸��� �����ϰ��� �Ѵ�.
-- �� ����ڵ��� �й��� ������ ���� �� ����ڸ� ã�� ������ SQL ������ �ۼ��Ͻÿ�
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY 1 DESC;

-- 5. ���������� 20 �� �̻� 30 �� ������ �а����� �а� �̸��� �迭�� ����Ͻÿ�.
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 6. �� ������б��� ������ �����ϰ� ��� �������� �Ҽ� �а��� ������ �ִ�.
-- �׷� �� ������б� ������ �̸��� �˾Ƴ� �� �ִ� SQL ������ �ۼ��Ͻÿ�.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7. Ȥ�� ������� ������ �а��� �����Ǿ� ���� ���� �л��� �ִ��� Ȯ���ϰ��� �Ѵ�.
-- ��� SQL ������ ����ϸ� �� ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 8. ������û�� �Ϸ��� �Ѵ�. �������� ���θ� Ȯ���ؾ� �ϴµ�, ���������� �����ϴ� �������
-- � �������� �����ȣ�� ��ȸ�غ��ÿ�.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9. �� ���п��� � �迭(CATECORY)���� �ִ��� ��ȸ�غ��ÿ�.
SELECT CATEGORY
FROM TB_DEPARTMENT
GROUP BY CATEGORY;

-- 10. 02�й� ���� �����ڵ��� ������ ������� �Ѵ�. ������ ������� ������ ��������
-- �л����� �й�, �̸�, �ֹε�Ϲ�ȣ�� ����ϴ� ������ �ۼ��Ͻÿ�.
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE tb_student.absence_yn = 'N'
        AND SUBSTR(tb_student.student_no, 1, 3) = 'A21'
        AND tb_student.student_address LIKE '%����%';
-- ��