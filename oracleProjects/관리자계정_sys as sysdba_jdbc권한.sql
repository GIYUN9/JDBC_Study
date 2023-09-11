-- 한 줄 주석
/*
여러줄 주석
*/
--RESULT SET 코드를  실행해서 나오는 결과값
select * from tab;
--/kh라는 유저를 만들고 비밀번호는
--kh(대소문자 구분함)로 하겠다.
CREATE USER JDBC IDENTIFIED BY JDBC;



--계정을 생성후에는 계정에 권한을 부여해야 사용하는 의미가 있다.

--GRANT 권한1, 권한2, ..... TO 계정명;

GRANT RESOURCE, CONNECT TO JDBC;