/*
    <DCL : 데이터 제어문>
    
    계정에게 시스템권한 또는 객체접근권한을 부여하거나 회수하는 구문
    
    > 시스템권한 : DB에 접근하는 권한, 객체들을 생성할 수 있는 권한
    > 객체접근권한 : 특정 객체들을 조작할 수 있는 권한
    
    CREATE USER 계정명 IDENTIFIED BY 비밀번호:
    GRANT 권한 (RESOURCE, CONNECT) TO 계정
*/

SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE IN ('RESOURCE', 'CONNECT');

/*
    <TCL : 트랜잭션 제어문>
    
    *트랜잭션
    -데이터베이스의 논리적 연산단위
    -데이터의 변경사항(DML)등을 하나의 트랜잭션에 묶어서 처리
    DML문 한개를 수행할 때 트랜잭션이 존재하지 않는다면 트랜잭션을 만들어서 묶음
                        트랜잭션이 존재한다면 해당 트랜잭션에 묶어서 처리
    COMMIT 하기 전까지의 변경사항들을 하나의 트랜잭션에 담는다.
    -트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE(DML)
    
    COMMIT(트랜잭션 종료 처리 후 확정)
    ROLLBACK(트랜잭션 취소)
    SAVEPOINT(임시저장)
    
    -COMMIT; --> 한 트랜잭션에 담겨있는 변경사항들을 DB에 반영시키겠다는 의미
    -ROLLBAVK; --> 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT시점으로 돌아감
    -SAVEPOINT 포인트명; --> 현재 시점에 해당 포인트 명으로 임시저장점을 저장해두는 것
*/

SELECT * FROM EMP_01;
--사번이 900번인 사람 삭제

DELETE FROM EMP_01
WHERE EMP_DI = 900;

DELETE FROM EMP_01
WHERE EMP_DI = 901;

ROLLBACK;

SELECT * FROM EMP_01;
--------------------------------------------------------------------------------
--사번이 900번인 사원 지우기
DELETE EMP_01
WHERE EMP_DI = 900;

--800, 홍길동, 총무부인 사원추가
INSERT INTO EMP_01
VALUES(800, '홍길동', '총무부');

COMMIT;
ROLLBACK;

--------------------------------------------------------------------------------
-- 217, 216, 214사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (217,216,214);

SAVEPOINT SP;

--801, 김말똥, 기술지원부
INSERT INTO EMP_01
VALUES(801, '김말똥', '기술지원부');

DELETE FROM EMP_01
WHERE EMP_ID = 218;

ROLLBACK TO SP;

COMMIT;

--------------------------------------------------------------------------------
--800번 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 800;

--DDL문실행
CREATE TABLE TEST(
    TID NUMBER
);
-- 이때 반영이 완료
ROLLBACK;

-- DDL문(CREATE, ALTER, DROP)을 수행하는 순간 기존에 트랜잭션에 있던 변경사항들을
-- 무조건 COMMIT (실제 DB반영된다.)
-- 즉,DDL문 수행 전 변경사항들이 있다면 정확하게 픽스하고 해라!