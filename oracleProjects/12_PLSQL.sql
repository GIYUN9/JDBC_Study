/*
    <PL/SQL>
    
    ����Ŭ ��ü�� ����Ǿ� �ִ� ������ ���
    SQL���� ������ ������ ����, ����(IF), �ݺ�(LOOP, FOR, WHILE)���� �����Ͽ� SQL�� ������ ����
    �ټ��� SQL���� �ѹ��� ���డ��
    
    *PL/SQL ����
    -[�����] : DECLARE�� ����, ������ ����� ���� �� �ʱ�ȭ�ϴ� �κ�
    -����� : BEGIN�� ����, SQL�� �Ǵ� ���(���ǹ�, �ݺ���)���� ������ ����ϴ� �κ�
    -[����ó����] : EXCEPTION���� ����, ���ܹ߻��� �ذ��ϱ����� ������ �̸� ����ص� �� �ִ� �κ�
*/

--*�����ϰ� ȭ�鿡 HELLO ORACLE���
SET SERVEROUTPUT ON;

BEGIN
    --SYSTEM.OUT.PRINT("")
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

--------------------------------------------------------------------------------
/*
    1. DECLARE �����
        ���� �� ��� �����ϴ� ����(����� ���ÿ� �ʱ�ȭ�� �����ϴ�)
        �Ϲ�Ÿ�Ժ���, ���۷���Ÿ�Ժ���, ROWŸ�Ժ���
        
        1_1)�Ϲ�Ÿ�Ժ��� ����� �ʱ�ȭ
            [ǥ����] ������ [CONSTANT] �ڷ��� [:=��]
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 800;
    ENAME := '������';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

-- &�Է� ���� '&�Է�' ����,��

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := &��ȣ;
    ENAME := '&�̸�';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/
--------------------------------------------------------------------------------
--1_2) ���۷��� Ÿ�� ���� ����� �ʱ�ȭ(����̺��� �Į���� ������Ÿ���� �����ؼ� �� Ÿ������ ����))
--[ǥ����] ������ ���̺��.�÷���%TYPE;

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
--    EID := '300';
--    ENAME := '������';
--    SAL := 3000000;
    
    -- ����� 200���� ����� ���, �����, �޿���ȸ
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
--    WHERE EMP_ID = 200;
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    
END;
/

--------------------------------------------------------------------------------
/*
    ���۷���Ÿ�� ������ EID, ENAME, JCODE, SAL, DTITLE
    �� �ڷ��� EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY) DEPARTMENT(DEPT_TITLE)���� ���� �ϵ���
    ����ڰ� �Է��� ����� ����� ���, �����, �����ڵ�, �޿�, �μ���, ��ȸ �� �� ������ ��� ����ض�
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
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
END;
/

--------------------------------------------------------------------------------
--1_3) ROWŸ�� ���� ����
-- ���̺��� �� �࿡���� ��� �÷����� �Ѳ����� ���� �� �ִ� ����
-- [ǥ����] ������ ���̺��%ROWTYPE;

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('����� : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('���ʽ� : ' || NVL(E.BONUS, 0));
END;
/

--------------------------------------------------------------------------------
--2. BEGIN �����
-- <���ǹ�>
-- 1)IF ���ǽ� THEN ���೻�� END IF; (���� IF��)

--����� �Է¹޾� �ش� ����� ���, �̸�, �޿�, ���ʽ��� ���

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || EID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || SAL);
    
    -- ���ʽ��� ���� �ʴ� ����̶�� '���ʽ��� ���޹��� �ʴ� ����Դϴ�.'
    IF BONUS = 0 
        THEN DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� �ʴ� ����Դϴ�.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('���ʽ��� : ' || BONUS * 100 || '%');
END;
/

-- 2) IF ���ǽ� THEN ���೻�� ELSE ���೻�� END IF;(IF ~ ELSE)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || EID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || SAL);
    
    -- ���ʽ��� ���� �ʴ� ����̶�� '���ʽ��� ���޹��� �ʴ� ����Դϴ�.'
    IF BONUS = 0 
        THEN DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� �ʴ� ����Դϴ�.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('���ʽ��� : ' || BONUS * 100 || '%');
    END IF;
END;
/

------------------------------------����----------------------------------------
DECLARE
-- ���۷���Ÿ�Ժ���(EID, ENAME, DTITLE, NCODE)
-- �����÷�(EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE)
-- �Ϲ�Ÿ�Ժ���(TEAM ���ڿ�) <= ������ �Ǵ� �ؿ��� ���� ����
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
BEGIN
-- ����ڰ� �Է��� ����� ����� ã�� ���, �̸�, �μ���, �ٹ������ڵ�, ��ȸ�� �� ������ ����
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &���;
-- NCODE ���� KO�ϰ�� TEAM�� '������' ����
    IF NCODE = 'KO'
        THEN TEAM := '������';
-- �װ� �ƴҰ�� TEAM�� '�ؿ���' ����
        ELSE TEAM := '�ؿ���';
    END IF;
-- ���, �̸�, �μ�, �Ҽ����
    DBMS_OUTPUT.PUT_LINE('��� : ' || EID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('�μ� : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('�Ҽ� : ' || TEAM);
END;
/

-- 3) IF ���ǽ�1 THEN ���೻��1 ELSIF ���ǽ�2 THEN ���೻��2.... [ELSE ���೻��] END IF;

DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(1);
BEGIN
    SCORE := &����;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    -- ����� ������ XX�̰�, ������ X�Դϴ�.
    DBMS_OUTPUT.PUT_LINE('����� ������ ' ||SCORE||'�̰�, ������ '|| GRADE ||'�Դϴ�.');
END;
/

--------------------------------------����---------------------------------------
--����ڿ��� �Է¹��� ����� ����� ã�� �޿��� ��ȸ�ؼ� SAL������ ����
--500�� �̻��̸� '���'
--400�� �̻��̸� '�߱�'
--300�� �̻��̸� '�ʱ�'
--�ش� ����� �޿������ XX�Դϴ�.

DECLARE
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT EMP_NAME, SALARY
    INTO ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    IF SAL >= 5000000 THEN GRADE := '���';
    ELSIF SAL >= 4000000 THEN GRADE := '�߱�';
    ELSIF SAL >= 3000000 THEN GRADE := '�ʱ�';
    ELSE GRADE := '����';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('�ش� ����� �޿������ '||GRADE||'�Դϴ�.');
END;
/

--------------------------------------------------------------------------------
--4) CASE �񱳴�� WHEN ������Ұ�1 THEN �����1 WHEN ���Ұ�2 THEN �����2... ELSE ����� END;
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &���;
    
    DNAME := CASE EMP.DEPT_CODE 
            WHEN 'D1' THEN '�λ������'
            WHEN 'D2' THEN 'ȸ�������'
            WHEN 'D3' THEN '�����ú�'
            WHEN 'D4' THEN '����������'
            ELSE '�ؿܿ�����'
            END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '�� ' || DNAME || '�Դϴ�.' );
END;
/

--------------------------------------------------------------------------------

-- <�ݺ���>
/*
    1) BASIC LOOP��
    
    [ǥ����]
    LOOP
        �ݺ������� ������ ����;
        *�ݺ����� Ż���� �� �ִ� ����
    END LOOP;
    
    *�ݺ����� Ż���� �� �ִ� ����(2����)
    1) IF ���ǽ� THEN EXIT; END IF;
    2) EXIT WHEN ���ǽ�;
*/

-- 1~5���� ���������� 1�� �����ϴ� ���� ����ض�
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
    2) FOR LOOP��
    [ǥ����]
    FOR ���� IN [REVERSE] �ʱⰪ..��������
    LOOP
        �ݺ������� ������ ����
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
    
    [ǥ����]
    WHILE �ݺ����� ����� ����
    LOOP
        �ݺ������� ����
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
    3. ����ó����
    ���� : ���� �� �߻��ϴ� ����
    
    [ǥ����]
    EXCEPTION
        WHEN ���ܸ�1 THEN ����ó������1;
        WHEN ���ܸ�2 THEN ����ó������2;
        ...
        WHEN ���ܸ�N THEN ����ó������N;    
    *�ý��� ���� (����Ŭ���� �̸� �����ص� ����)
    -NO_DATA_FOUND : SELECT�� ����� �� �൵ ���� ��
    -TOO_MANY_ROWS : SELECT�� ����� �������ϰ��
    -ZERO_DIVIDE : 0���� ������
    -DUP_VAL_ON_INDEX : UNIQUE�������ǿ� ����Ǿ��� ��
    ...
*/
-- ����ڰ� �Է��� ���� �������� ��� ���
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &����;
    DBMS_OUTPUT.PUT_LINE('��� : ' || RESULT);
EXCEPTION
--  WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('������ ������ 0���� �Ҽ� ����');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('����������');
END;
/

--UNIQUE �������� ����
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID= '&�����һ��'
    WHERE EMP_NAME = '���ö';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('�̹� �����ϴ� ����Դϴ�.');
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &������;
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || EID);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || ENAME);
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('�ʹ� ���� ���� ��ȸ�Ǿ����ϴ�.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('��ȸ����� �����ϴ�.');
END;
/

