-- 1. �迭 ������ ������ ī�װ� ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

-- 2. ���� ������ ������ ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

-- 3. TB_CATEGORY ���̺��� NAME �÷��� PRIMARY KEY�� �����Ͻÿ�.
ALTER TABLE TB_CATEGORY ADD PRIMARY KEY(NAME);

-- 4. TB_CLASS_TYPE ���̺��� NAMEĮ���� NULL ���� ���� �ʵ��� �Ӽ��� �����Ͻÿ�.
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

-- 5. �� ���̺��� �÷����� NO�� ���� ���� Ÿ���� �����ϸ鼭 ũ��� 10����, �÷����� NAME��
-- ���� ���������� ���� Ÿ���� �����ϸ鼭 ũ�� 20���� �����Ͻÿ�.
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CLASS_TYPE MODIFY NAME VARCHAR2(20);

-- 6. �����̺��� NO�÷��� NAME�÷��� �̸��� ���� TB_�� ������ ���̺� �̸��� �տ� ���� ���·κ����Ѵ�.
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;

-- 7. TB_CATEGORY ���̺�� TB_CLASS_TYPE ���̺��� PRIMARY KEY �̸��� ������ ���� ����.
ALTER TABLE TB_CATEGORY RENAME COLUMN CATEGORY_NAME TO PK_CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN CLASS_TYPE_NAME TO PK_CLASS_TYPE;

-- 8. ������ ���� INSERT ���� �����Ѵ�.
INSERT INTO TB_CATEGORY VALUES ('����', 'Y');
INSERT INTO TB_CATEGORY VALUES ('�ڿ�����', 'Y');
INSERT INTO TB_CATEGORY VALUES ('����', 'Y');
INSERT INTO TB_CATEGORY VALUES ('��ü��', 'Y');
INSERT INTO TB_CATEGORY VALUES ('�ι���ȸ', 'Y');
COMMIT;

-- 9. TB_DEPARTMENT �� CATEGORY �÷��� TB_CATEGORY ���̺��� CATEGORY_NAME �÷���
-- �θ����� �����ϵ��� FOREIGN KEY�� �����Ͻÿ�. �̶� KEY�̸��� FK_���̺��̸�_�÷��̸����� ����
-- (EX. FK_DEPARTMENT_CATEGORY)
ALTER TABLE TB_DEPARTMENT
    ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY(CATEGORY)
    REFERENCES TB_CATEGORY(PK_CATEGORY_NAME);

-- 10. �� ������б� �л����� �������� ���ԵǾ� �ִ� �л��Ϲ����� VIEW�� ��������Ѵ�.
-- ������ �����Ͽ� SQL���ۼ�
CREATE VIEW VW_�л��Ϲ�����
AS (SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT);

-- ������ �������α��� �ο�GRANT CREATE VIEW TO wk;

-- 11. �� ������б��� 1�⿡ �� ���� �а����� �л��� ���������� ���� ����� �����Ѵ�.
-- �̸� ���� ����� �л��̸�, �а��̸�, ��米���̸����� �����Ǿ��ִ� VIEW�� ����ÿ�.
-- �̶� ���������� ���� �л��� ���� �� ������ ����Ͻÿ�
--(��,�� VIEW�� �ܼ� SELECT���� �� ��� �а����� ���ĵǾ� ȭ�鿡 �������� ����ÿ�.)
CREATE VIEW VW_�������
AS (SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT ON (TB_STUDENT.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
    JOIN TB_PROFESSOR ON (tb_student.coach_professor_no = tb_professor.professor_no))
ORDER BY TB_DEPARTMENT.DEPARTMENT_NAME;

-- 12. ��� �а��� �а��� �л� ���� Ȯ���� �� �ֵ��� ������ VIEW�� �ۼ��� ����.
CREATE VIEW VW_�а����л���
AS (SELECT DEPARTMENT_NAME, COUNT(*) AS "STUDENT_COUNT"
    FROM TB_STUDENT S
    JOIN TB_DEPARTMENT D ON S.department_no =  D.department_no
    GROUP BY DEPARTMENT_NAME
);

-- 13. ������ ������ �л��Ϲ����� VIEW�� ���� �й��� A213046�� �л��� �̸��� ���� �̸����� �����ϴ�SQL�� �ۼ�
UPDATE VW_�л��Ϲ�����
SET STUDENT_NAME = '������'
WHERE STUDENT_NO = 'A213046';

-- 14. 13�������� ���� VIEW�� ���ؼ� �����Ͱ� ����� �� �ִ� ��Ȳ�� �������� VIEW�� ���
-- �����ؾ� �ϴ��� �ۼ�.
CREATE OR REPLACE VIEW VW_�л��Ϲ�����
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT
    WITH READ ONLY;
-- �б⸸ �����ϵ��� ������ �����ϰ� ������ش�.

-- 15. �� ������б��� �ų� ������û �Ⱓ�� �Ǹ� Ư�� �α����鿡 ������û�� ���� ������ �ǰ�
-- �ִ�. �ֱ� 3���� �������� �����ο��� ���� ���Ҵ� 3������ ã�±����� �ۼ��Ͻÿ�.
SELECT �����ȣ, �����̸�, "������������(��)"
FROM (SELECT CLASS_NO �����ȣ, CLASS_NAME �����̸�, COUNT(*) "������������(��)"
      FROM TB_GRADE
           JOIN TB_CLASS USING(CLASS_NO)
      WHERE TERM_NO LIKE '2009%'
            OR TERM_NO LIKE '2008%'
            OR TERM_NO LIKE '2007%'
      GROUP BY CLASS_NO, CLASS_NAME
      ORDER BY 3 DESC)
WHERE ROWNUM <= 3;