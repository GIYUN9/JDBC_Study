/*
    *DDL : 데이터 정의언어
    
    객체를 생성(CREATE), 변경(ALTER), 삭제(DELETE)하는구문
    
    <ALTER>
    객체를 변경하는 구문
    
    [표현식]
    ALTER TABLE 테이블명 변경할 내용;
    
    *변경할 내용
    1) 컬럼 추가/수정/삭제
    2) 제약조건 추가/삭제 --> 수정은 불가(삭제후 다시추가하면 됨)
    3) 컬럼명/제약조건명/테이블명/ 변경
*/

--1) 컬럼추가/수정/삭제

--1_1) 컬럼추가 (ADD : ADD 컬럼명 데이터 타입 [DEFAULT 기본값])
--DEPT_TABLE에 CNAME컬럼 추가
ALTER TABLE DEPT_TABLE ADD CNAME VARCHAR2(20);

-- LNAME 컬럼추가(기본값 지정)
ALTER TABLE DEPT_TABLE ADD LNAME VARCHAR2(20) DEFAULT '한국';

--1_2)컬럼 수정(MODIFY)
--> 데이터 타입 수정 : MODIFY 컬럼명 바꾸고자하는 데이터타입
--> DEFAULT 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는 기본값

ALTER TABLE DEPT_TABLE MODIFY DEPT_ID CHAR(5);
--ALTER TABLE DEPT_TABLE MODIFY DEPT_ID NUMBER; -- 형식오류 발생
ALTER TABLE DEPT_TABLE MODIFY DEPT_TITLE VARCHAR2(10); --크기 오류 발생

--DEPT_TITLE 컬럼을 VARCHAR2(40)
--LOCATION_ID 컬럼을 VARCHAR2(2)
--LNAME 컬럼의 기본값을 '미국'으로 변경

--다중변경 가능
ALTER TABLE DEPT_TABLE
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';
    
-- 1_3) 컬럼 삭제(DROP COLUMN) : DROP COLUMN 삭제하고자하는 컬럼
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPT_TABLE;

SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;

ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
--> 최소 한개의 컬럼은 존재해야된다.

--------------------------------------------------------------------------------
--2) 제약조건 추가/삭제(수정은 삭제 후 추가하면 된다.)

/*
    2_1)
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블[(컬럼명)]
    UNIQUE : ADD UNIQUE(컬럼명)
    CHECK : ADD CHECK(컬럼에대한 조건)
    NOT NULL : MODIFY 컬럼명 NULL | NOT NULL
    
    제약조건명 지정하고자 한다면[CONSTRAINT 제약조건명] 제약조건
*/

--DEPT_ID에 PRIMARY KEY 제약조건 추가
--DEPT_TITLE에 UNIQUE 제약조건 추가
--LNAME에 NOT NULL제약조건 추가

ALTER TABLE DEPT_TABLE
    ADD CONSTRAINT DTABLE_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DTABLE_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DTABLE_NN NOT NULL;
    
--2_2) 제약조건삭제 : DROP CONSTRAINT 제약조건명 / NOT NULL같은 경우
ALTER TABLE DEPT_TABLE DROP CONSTRAINT DTABLE_PK;

ALTER TABLE DEPT_TABLE 
    DROP CONSTRAINT DTABLE_UQ
    MODIFY LNAME NULL;
    
--------------------------------------------------------------------------------
--3) 컬럼명/제약조건명/테이블명 변경(RENAME)
--3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
--DEPT_TITLE -> DEPT_NAME으로 변경
ALTER TABLE DEPT_TABLE
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

--3_2)제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
ALTER TABLE DEPT_TABLE
RENAME CONSTRAINT SYS_C007305 TO DTABLE_LID_NN;

--3_3)테이블명 변경 : RENAME TO 바꿀테이블명
--DEPT_TABLE --> DEPT_TEST
ALTER TABLE DEPT_TABLE RENAME TO DEPT_TEST;

--------------------------------------------------------------------------------
--테이블 삭제
DROP TABLE DEPT_TEST;
--어딘가에 참조되고있는 부모테이블은함부로 삭제가 되지 않는다.
-- 1. 자식테이블먼저 삭제후 삭제
-- 2. 그냥 부모테이블만 삭제하는데 제약조건까지 삭제하는 방법
-- DROP TABLE 테이블명 CASCADE CONSTRAINT;