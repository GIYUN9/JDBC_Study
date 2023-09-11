--�˻��ϰ��� �ϴ� ����
-- JOB_CODE�� J7�̰ų� J6�̸鼭 SALARY���� 200���� �̻��̰�
-- BONUS�� �ְ� �����̸� �̸����ּҴ� _�տ� 3���ڸ� �ִ� �����
-- �̸�, �ֹε�Ϲ�ȣ, �����ڵ�, �μ��ڵ�, �޿�, ���ʽ��� ��ȸ�ϰ� �ʹ�.
-- ���������� ��ȸ�� �ȴٸ� �������� 2���� �ุ ��ȸ�� �Ǿ�� �Ѵ�.

-- ���� ������ �ۼ��� SQL���� �Ʒ��� ����.
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE JOB_CODE = 'J7' OR JOB_CODE = 'J6' AND SALARY > 2000000
 AND EMAIL LIKE '____%' AND BONUS IS NULL;
 
-- �� SQL�� ����� ���ϴ� ����� ����� ��ȸ���� �ʴ´�. � ���������� �ִ���
-- ��� ã�Ƽ� �����ϰ�, ��ġ�Ͽ� �Ϻ��� SQL���� �ۼ��غ���

-- ����
SELECT EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE EMAIL LIKE '___\_%' ESCAPE '\' AND BONUS IS NOT NULL AND SUBSTR(EMP_NO, 8, 1) IN (2, 4) AND
JOB_CODE IN ('J7' ,'J6') AND SALARY >= 2000000;
-- BONUS IS NULL ���� IS NOT NULL�� ����, EMAIL _�տ� �κп� '\' ESCAPE �߰�, ���ڻ�� EMP_NO�� 8��° �ڸ� 2�Ǵ� 4 �߰�
-- �켱���� ���缭 WHERE�� ����