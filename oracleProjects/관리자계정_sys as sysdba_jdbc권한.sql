-- �� �� �ּ�
/*
������ �ּ�
*/
--RESULT SET �ڵ带  �����ؼ� ������ �����
select * from tab;
--/kh��� ������ ����� ��й�ȣ��
--kh(��ҹ��� ������)�� �ϰڴ�.
CREATE USER JDBC IDENTIFIED BY JDBC;



--������ �����Ŀ��� ������ ������ �ο��ؾ� ����ϴ� �ǹ̰� �ִ�.

--GRANT ����1, ����2, ..... TO ������;

GRANT RESOURCE, CONNECT TO JDBC;