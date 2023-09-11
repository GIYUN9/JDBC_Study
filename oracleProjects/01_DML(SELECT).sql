/*
    <SELECT>
    SELECT ���������� ���� ���� FROM ���̺�
*/

-- ��� ����� ������������
SELECT * FROM EMPLOYEE;

-- ������� �̸�, �ֹε�Ϲ�ȣ, �ڵ�����ȣ ��ȸ
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE;

-------------------�ǽ�--------------------
-- JOB���̺��� ���޸� �÷��� ��ȸ
SELECT JOB_NAME FROM JOB;
-- DEPARTMENT ���̺��� ����÷� ��ȸ
SELECT * FROM department;
-- DEPARTMENT ���̺��� �μ��ڵ� �μ��� ��ȸ
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
-- EMPLOYEE ���̺��� �����, �̸���, ��ȭ��ȣ, �Ի���, �޿� ��ȸ
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY FROM employee;

-- <�÷����� ���� �������>
-- SELECT�� �ķ��� �ۼ��κп� ��������� �� �� �ִ�.

-- EMPLOYEE ���̺��� �����, ����� ����(�޿� * 12) ��ȸ
SELECT EMP_NAME, SALARY * 12
FROM employee;

-- EMPLOYEE ���̺��� �����, �޿�, ���ʽ�, ����, ���ʽ� ���Կ��� ��ȸ
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + (SALARY * BONUS)) * 12
FROM employee;
-- ������� �����߿� NULL�����Ͱ� ���ԵǾ� �ִٸ� ������ ������� NULL

-- �����, �Ի���, �ٹ��ϼ��� ��ȸ
-- �ڵ�������� ��¥�� ǥ���ϴ»�� : SYSDATE [��/��/��/��/��/��]
-- DATE - DATE �� ������� �Ϸ� ǥ�õȴ�.
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

-- ���� �ý����� ��¥�� �ð��� ��ȸ
SELECT SYSDATE
FROM DUAL;
-- DUAL : ����Ŭ���� �������ִ� �����������̺�(����������)

/*
    <�÷����� ��Ī �����ϱ�>
    ��������� �ϰԵǸ� �÷����� ������ ������. �̶� �÷������� ��Ī�� �ο��ؼ� ����ϰ� ������ �� �ִ�.
    [ǥ����]
    �÷��� ��Ī / �÷��� as ��Ī / �÷��� "��Ī" / �÷��� as "��Ī"
    ��Ī�� ���� �Ǵ� Ư�����ڰ� ���Եɶ���  ���������̼�("")�� �ٿ��ݴϴ�.
*/

-- EMPLOYEE ���̺��� �����, �޿�, ���ʽ�, ����, ���ʽ� ���Կ��� ��ȸ
SELECT EMP_NAME �����, SALARY as �޿�, BONUS "���ʽ�", SALARY * 12 "����(��)",
(SALARY + (SALARY * BONUS)) * 12 as "�� �ҵ�"
FROM employee;

/*
    <���ͷ�>
    ���Ƿ� ������ ���ڿ�('')
    ��ȸ�� RESULT SET�� ��� �࿡ �ݺ������� ���
*/

-- EMPLOYEE ���̺��� ���, �����, �޿�
SELECT EMP_ID, EMP_NAME, SALARY, '��' AS "����"
FROM employee;

/*
    <���Ῥ���� : ||>
    ���� �÷������� ��ġ �ϳ��� �÷�ó�� ������ �� �ִ�.
*/

-- ���, �̸�, �޿��� �ϳ��� �÷����� ��ȸ
SELECT EMP_ID || EMP_NAME || SALARY
FROM employee;

-- XX�� ������ XX���Դϴ�.
SELECT EMP_NAME || '�� ������ ' || SALARY || '�� �Դϴ�.' AS "�޿�����"
FROM employee;

/*
    <DISTINCT>
    �ߺ����� - �÷��� ǥ�õ� ������ �ѹ����� ��ȸ�ϰ��� �� �� ���
*/

-- EMPLOYEE �����ڵ� ��ȸ
SELECT DISTINCT JOB_CODE 
FROM EMPLOYEE;

-- EMPLOYEE�� �μ��ڵ带 ���� ��ȸ(�ߺ�����)
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE
-- ��ó�� �ۼ��ϸ� ������ �߻��Ѵ�. DISTINCT�� �ѹ��� ����� �����ϴ�.
SELECT DISTINCT JOB_CODE, DEPT_CODE
-- ��ó�� ���� (JOB_CODE, DEPT_CODE) ������ ��� �ߺ��� ������ ���� �����ش�.
FROM employee;

-- =============================================================================

/*
    <WHERE ��>
    ��ȸ�ϰ����ϴ� ���̺��κ��� Ư�� ���ǿ� �����ϴ� �����͸��� ��ȸ�� �� ���
    ���ǽĿ����� �پ��� ������ ����� ����
    [ǥ����]
    SELECT �ķ�,�÷�,�÷�����
    FROM ���̺�
    WHERE ����;
    
    >>�񱳿�����<<
    >, <, >=, <=    ��Һ�
    =               ������ ����.
    !=, ^=, <>      ������ �ٸ���.
*/

-- EMPLOYEE ���� �μ��ڵ尡 'D9'�� ����鸸 ��ȸ(����÷�)
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE���� �μ��ڵ尡 'D1'�� ������� �����, �޿�, �μ��ڵ� ��ȸ
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- EMPLOYEE���� �μ��ڵ尡 'D1'�� �ƴѻ������ ���, �����,�μ��ڵ� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE != 'D1';

-- ������ 400���� �̻��� ������� �����, �μ��ڵ�, �޿���ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-----------------------�ǽ�����---------------------
-- 1. �޿��� 300���� �̻��� �����, �޿�, �Ի���, ������ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY * 12 AS "����"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. ������ 5000���� �̻��� ������� �����, �޿�, ����, �μ��ڵ� ��ȸ
SELECT EMP_NAME, SALARY, SALARY * 12 AS "����", DEPT_CODE
FROM EMPLOYEE
WHERE SALARY * 12 >= 50000000;

-- WHERE ���� >= 50000000; -> �������� ������ ��������� FORM- WHERE- SELECT�̱� ����
-- 3. �����ڵ尡 'J3'�� �ƴѻ������ ���, �����, �����ڵ�, ��翩�� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

-- 4. �޿��� 350���� �̻� 600���� ������ ��� ����� �����, ���, �޿� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

-- =============================================================================

/*
    <AND, OR ������>
    ������ ������ ������ �� ����Ѵ�.
    [ǥ����]
    ����A AND ����B -> ����A�� ����B�� ��� �����ϴ� ���� ������ �´�.
    ����A OR ����B -> ����A�� ����B�� �ϳ��� �����ϴ� ���� ������ �´�.
    
    <BETWEEN AND>
    ���ǽĿ� ���Ǵ� ����
    ���̻� �������� ������ ���� ������ ������ �� ����ϴ� ������(�̻�, ���ϸ� ����)
    [ǥ����]
    �񱳴�� Ŀ�� BETWEEN ���Ѱ� AND ���Ѱ�
*/

-- �޿��� 350���� �̻� 600���� ������ ��� ����� �����, ���, �޿� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- �޿��� 350���� �̸� 600���� �ʰ��� ��� ����� �����, ���, �޿� ��ȸ
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
-- WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
WHERE SALARY < 3500000 OR SALARY > 6000000;
-- NOT : ���� ���� ������
-- �÷��� �� �Ǵ� BETWEEN�տ� ���𰡴�

-- �Ի����� '90/01/01' ~ '01/01/01' ����� ��ü��ȸ
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01'; -- DATEŸ�Ե� �񱳿����̰����ϴ�.

-- BETWEEN ���
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- =============================================================================

/*
    <LIKE>
    ���ϰ����ϴ� �÷����� ���� ������ Ư�� ���Ͽ� ������ ��� ��ȸ
    
    [ǥ����]
    �񱳴���÷� LIKE 'Ư������'; ��ġ�ϴ� ��, LIKE�� �����ϴ� ��
    
    Ư�������� ������ �� ���ϵ�ī���� Ư�������� ���ǵǾ��ִ�.
    '%' : ���Թ��� �˻�(0�����̻� ���� ��ȸ)
    EX) �񱳴���÷� LIKE '����%' : �񱳴���÷��� �߿��� �ش繮�ڷ� �����ϴ� �͵鸸 ��ȸ
    �񱳴���÷� LIKE '%����' : �񱳴���÷��� �߿��� �ش繮�ڷ� ������ �͵鸸 ��ȸ
    �񱳴���÷� LIKE '%����%' : �񱳴���÷��� �߿��� �ش繮�ڰ� ���Ե� �� ��ȸ
    
    '_' : 1���ڸ� ��ü�ؼ� �˻�
    EX) �񱳴���÷� LIKE '_����' : �񱳴���÷����� ���ھտ� �ƹ����ڳ� �ѱ��ڰ� �ִ°��� ��ȸ
    �񱳴���÷� LIKE '___����' : �񱳴���÷����� ���ھտ� �ƹ����ڳ� �����ڰ� �ִ°��� ��ȸ
    �񱳴���÷� LIKE '_����_' : �񱳴���÷����� ���ھտ� �ƹ����ڳ� �ڿ� �ƹ����ڳ� �ѱ��� �ִ� �� ��ȸ   
*/

-- ������� ���� ������ ������� �����, �޿�, �Ի��� ��ȸ
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '��%';

-- ������� �̸��� �ϰ� ���Ե� ������� �����, ���, ��ȭ��ȣ ��ȸ
SELECT EMP_NAME, EMP_ID, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��%';

-- ������� �̸� �߰����ڰ� ���� ������� �����, ��ȭ��ȣ ��ȸ
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_��_';

-- ��ȭ��ȣ�� 3��° �ڸ��� 1�� ������� ���, �����, ��ȭ��ȣ, �̸��� ��ȸ
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- �̸��� �� _�ձ��ڰ� 3������ ������� ���, �̸�, �̸����� ��ȸ
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
-- WHERE EMAIL LIKE ''; -> ���ϵ�ī�幮�ڶ����� ������� ���� ����
-- ���ϵ�ī�幮�ڿ� �Ϲݹ����� ������ �ʿ��ϴ�.
-- �����Ͱ����� ����ϰ� ���� ���ϵ�ī�� ���ھտ� ������ Ż����� �����ؼ� Ż���Ų��.
-- ESCAPE OPTION �� ����ؼ� ����ؾ���
WHERE EMAIL LIKE '___\_%' ESCAPE '\'; 

-- �� ������� �ƴ� �� ���� ������� ��ȸ�ϰ� �ʹ� �÷��� ����
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE NOT EMAIL LIKE '___\_%' ESCAPE '\'; 


-- ====================================�ǽ�=====================================
-- 1. �̸��� '��'���� ������ ������� �����, �Ի��� ��ȸ
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��';

-- 2. ��ȭ��ȣ ó�� 3�ڸ��� 010�� �ƴ� ������� �����, ��ȭ��ȣ ��ȸ
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

-- 3. �̸��� '��'�� ���ԵǾ� �ְ� �޿��� 240���� �̻��� ������� �����, �޿� ��ȸ
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%��%' AND SALARY >= 2400000; 

-- 4. �μ����̺����� �ؿܿ������� �μ����� �μ��ڵ�, �μ��� ��ȸ
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '�ؿܿ���%';

-- =============================================================================
/*
    <IN ��>
    WHERE������ �񱳴�� �÷����� ���� ������ ����߿� ��ġ�ϴ� ���� �ִ��� �˻�
    
    [ǥ����]
    �񱳴���÷� IN ('��1', '��2'..)
*/

-- �μ��ڵ尡 D6�̰ų� D8�̰ų� D5�� �μ������� �̸�, �μ��ڵ�, �޿��� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6', 'D8', 'D5');
-- =============================================================================
/*
    <IS NULL & IS NOT NULL>
    �÷����� NULL�� ���� ��� NULL���� ���ϱ� ���ؼ� ����ϴ� ������   
*/
-- ���ʽ��� �������� ������� ���, �̸�, �޿�, ���ʽ� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- ���ʽ��� �ް� �ִ� ������� ���, �̸�, �޿�, ���ʽ�
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

-- ����� ���� ������� ����� ������, �μ��ڵ� ��ȸ
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- �μ���ġ�� ���� ���� �ʾҰ� ���ʽ��� �޴� ������� �̸�, ���ʽ�, �μ��ڵ�
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

/*
    <������ �켱����>
    1. ���������
    2. ���Ῥ����(||)
    3. �񱳿�����
    4. IS NULL / LIKE / IN
    5. BETWEEN a AND b
    6. NOT
    7. AND
    8. OR
*/

-- �����ڵ尡 J7�̰ų� J2�� ����߿� �޿��� 200���� �̻��� ������� ��� �÷� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE IN ('J7', 'J2') AND SALARY >= 2000000;

-- =================================�ǽ�========================================
-- 1. ����� ���� �μ���ġ�� ���� ���� ������� �����,���,�μ��ڵ� ��ȸ
SELECT EMP_NAME, EMP_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 2. ����(���ʽ� ������)�� 3000���� �̻��̰� ���ʽ��� ���� �ʴ� ������� ���, �����, �޿�, ���ʽ� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE (SALARY * 12) >= 30000000 AND BONUS IS NULL;


-- 3. �Ի����� '95/01/01/' �̻��̰� �μ���ġ�� ���� ���� ������� ���, �����, �Ի���, �μ��ڵ� ��ȸ
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NULL;

-- 4. �޿��� 200���� �̻��̰� 500���������� ��� �� �Ի����� '01/01/01' �̻��̰� ���ʽ��� ���� ����
-- ������� ���, �����, �޿�, �Ի���, ���ʽ� ��ȸ
SELECT EMP_ID,EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE (SALARY BETWEEN 2000000 AND 5000000) AND HIRE_DATE >= '01/01/01' AND BONUS IS NULL;

-- 5.���ʽ��� ���� ������ NULL�� �ƴϰ� �̸��� '��'�� ���Ե� ������� ���, �����, �޿�, ���ʽ����� ���� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, (SALARY + (SALARY * BONUS)) * 12
FROM EMPLOYEE
WHERE SALARY IS NOT NULL AND BONUS IS NOT NULL AND EMP_NAME LIKE '%��%';

-- =============================================================================

-- �μ��� ���� ����� �����ȣ, �̸�, �޿��� ��ȸ
SELECT EMP_ID "�����ȣ", EMP_NAME AS �̸�, SALARY AS "�޿�"
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL ;

/*
    <ORDER BY ��>
    SELECT�� ���� �������ٿ� �ۼ�, ������� ���� ������������
    
    [ǥ����]
    SELECT ��ȸ�� �÷���, ., ., . + ���� AS ��Ī
    FROM ��ȸ�� ���̺�
    WHERE ���ǽ�
    ORDER BY ���ı����� �ķ��� | ��Ī | ���� [ASC | DESC] [NULLS FIRST | NULLS LAST]    
    
    ASC : �������� [NULLS LAST]
    DESC : �������� [NULLS FIRST]
    
    NULLS FIRST : NULL���� ��ȸ�� ���̺����� ���ʿ� ��ġ ��ų ����
    NULLS LAST : NULL���� ��ȸ�� ���̺����� ���ʿ� ��ġ ��ų ����
*/

SELECT *
FROM employee
--ORDER BY BONUS; -- ���Ĺ���� �������� �ʾ��� �� �������� ����[�⺻��]�ؼ� �������´�.
--ORDER BY BONUS ASC NULLS FIRST;
--ORDER BY BONUS DESC NULLS FIRST;
ORDER BY BONUS DESC, SALARY ASC;

-- �� ����� �����, ������ ��ȸ(������ �������� ����)
SELECT EMP_NAME, SALARY * 12 AS "����"
FROM EMPLOYEE
ORDER BY 2 DESC;