/*
    *DDL : 데이터 정의 언어
    오라클에서 제공하는 객체를 새로 만들고(CREATE), 구조를 변경하고(ALTER),
    구조자체를 삭제(DELETE)하는 언어
    즉, 실제 데이터 값이 아닌 규칙 자체를 정의하는 언어
    
    오라클에서 객체(구조) : 테이블, 뷰, 시퀀스
                            인덱스, 패키지, 트리거
                            프로시져, 함수, 동의어, 사용자
                            
    < CREATE >
    객체를 새로 생성하는 구문
*/

/*
    1. 테이블 생성
    - 테이블이란 : 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
                모든 데이터들은 테이블을 통해서 저장됨
                (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
                
    [표현식]
    CREATE TABLE 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형
        ...
    )
    
    *자료형
    -문자(CHAR(바이트크기) | VARCHAR2(바이트크기)) -> 반드시 크기지정 해야함
        -CHAR : 최대 2000바이트까지 지정가능 / 고정길이(고정된 글자수의 데이터가 담길 경우)
        (지정한 크기보다 더 적은 값이 들어오면 공백으로라도 채워서 처음 지정한 크기만큼 세팅)
        -VARCHAR2 : 최대 4000바이트까지 지정가능 / 가변길이(몇글자의 데이터가 들어올지 모르는 경우)
        (담긴 값에 따라서 공간 크기가 맞춰짐)
    -숫자(NUMBER)
    -날짜(DATE)
*/

--회원에 대한 데이터를 담기위한 테이블 MEMBER 생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);
SELECT * FROM MEMBER;

--데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
-- [참고] USER_TABLES : 사용자가 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 시스템테이블
-- [참고] USER_TAB_COLUMNS : 사용자가 가지고 있는 테이블들 상의 모든 컬럼구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TABLES;
SELECT * FROM USER_TAB_COLUMNS;
--------------------------------------------------------------------------------
/*
    2. 컬럼에 주석달기 (컬럼에 대한 간단한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    -> 잘못 작성시 새로 작성하면 수정이 된다.
*/

COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남/여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

--테이블 삭제하고자 할 때 : DROP TABLE 테이블명;
--테이블에 데이터를 추가시키는 구문(INSERT)
--INSERT INTO 테이블명 VALUES(값,값,값,값,....)
INSERT INTO MEMBER
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM', '20/12/30');                         
SELECT * FROM MEMBER;
INSERT INTO MEMBER
VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL, SYSDATE);

INSERT INTO MEMBER
VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--------------------------------------------------------------------------------

/*
    <제약조건>
    -원하는 데이터값(유효한 형식의 값)만 유지하기 위해서 특정 컬럼에 설정하는 제약
    -데이터 무결성 보장을 목적으로 한다.
    
    *종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
*/

/*
    *NOT NULL 제약조건
    해당 컬럼의 반드시 값이 존재해야만 할 경우(즉, 절대 NULL이 들어오면 안되는 경우)
    삽입/수정시 NULL값을 허용하지 않도록 제한
    
    제약조건을 부여하는 방식은 크게 2가지가 있다. (컬럼레벨방식 / 테이블레벨방식)
    NOT NULL제약조건은 무조건 컬럼레벨방식으로만 가능하다.
*/

CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL, --컬럼레벨방식
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');                      
SELECT * FROM MEMBER;

INSERT INTO MEM_NOTNULL
VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);

INSERT INTO MEM_NOTNULL
VALUES(NULL, 'USER3', 'PASS3', '홍홍홍', NULL, NULL, NULL);
--의도했던대로 오류가 발생한다. (NOT NULL 제약조건에 위배되어 오류 발생)

INSERT INTO MEM_NOTNULL
VALUES(3, 'USER2', 'PASS3', '김개똥', NULL, NULL, NULL);
--아이디가 중복되었음에도 불구하고 추가됨.

--------------------------------------------------------------------------------
/*
    *UNIQUE 제약조건
    해당컬럼에 중복된 값이 들어가서는 안될 경우 사용한다.
    컬럼에 중복값을 제한하는 제약조건이다.
    삽입/수정시 기존에 있는 데이터값 중 중복값이 있을 경우 오류를 발생시킨다.
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL, --컬럼레벨방식
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER1', 'PASS2', '홍길순', '여', NULL, NULL);
-- UNIQUE 제약조건에 위배되었으므로 INSERT 실패
--> 오류구문을 제약조건명으로 알려준다.
--> 쉽게 파악하기는 어렵다.
--> 제약조건 부여시 제약조건명을 지정해주지 않으면 시스템에서 임의의 이름으 부여함

--------------------------------------------------------------------------------
/*
    *제약조건 부여시 제약조건명까지 지어주는 방법
    > 컬럼레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 [CONSTRAINT 제약조건명]제약조건
    ) 
     > 테이블레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        [CONSTRAINT 제약조건명]제약조건(컬럼명)
    )
*/

DROP TABLE MEM_UNIQUE;

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER CONSTRAINT MEMNO_NT NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NT NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPDW_NA NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NT NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID) --> 테이블레벨방식
);

INSERT INTO MEM_UNIQUE
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');

INSERT INTO MEM_UNIQUE
VALUES(2, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);

INSERT INTO MEM_UNIQUE
VALUES(3, 'USER3', 'PASS3', '김개똥', NULL, NULL, NULL);

INSERT INTO MEM_UNIQUE
VALUES(4, 'USER4', 'PASS4', '최개똥', 'ㅇ', NULL, NULL);

--------------------------------------------------------------------------------
/*
    *CHECK(조건식)
    해당컬럼에 들어올 수 있는 값에 대한 조건을 제시해둘 수 있음
    해당조건에 만족하는 데이터값만 담길 수 있음
*/
CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20)NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --> 컬럼레벨방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID)
);

INSERT INTO MEM_CHECK
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');
SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK
VALUES(4, 'USER4', 'PASS4', '최개똥', 'ㅇ', NULL, NULL);
--> CHECK 제약조건 때문에 에러가 발생한다.
--> 만일 GENDER컬럼에 데이터를 넣고자 한다면 CHECK제약조건에 만족하는 값을 넣어야 한다.
--> NULL은 값이 없다는 뜻이기 때문에 가능하다.

INSERT INTO MEM_CHECK
VALUES(4, 'USER5', 'PASS4', '최개똥', '여', NULL, NULL);

--------------------------------------------------------------------------------

/*
    *PRIMARY KEY(기본키) 제약조건
    테이블에서 각 행(ROW)들을 식별하기 위해 사용될 컬럼에 제약조건(식별자 역할)
    
    EX) 회원번호, 학번, 군번, 부서코드, 직급코드, 주문번호, 택배운송장번호, 예약번호
    PRIMARY KEY 제약조건을 부여하면 그 컬럼에 자동적으로 NOT NULL + UNIQUE 제약조건이 걸렸음을 의미한다.
    
    유의사항 : 한 테이블당 한개만 설정 가능
*/

CREATE TABLE MEM_PRI(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20)NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --> 컬럼레벨방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID)
--    ,PRIMARY KEY(MEM_ID)
);

INSERT INTO MEM_PRI
VALUES(1, 'USER1', 'PASS1', '홍길동', '남', '010-1111-2222', 'AAAA@NAVER.COM');
SELECT * FROM MEM_PRI;

INSERT INTO MEM_PRI
VALUES(1, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);
--> 기본키에 중복값을 담으려고 할 때(UNIQUE제약조건 위반)

INSERT INTO MEM_PRI
VALUES(NULL, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);
--> 기본키에 NULL을 담으려고 할 때(NOT NULL제약조건 위반)

INSERT INTO MEM_PRI
VALUES(2, 'USER2', 'PASS2', '홍길순', '여', NULL, NULL);

--------------------------------------------------------------------------------
DROP TABLE MEM_PRI2;

CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20)NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), --> 컬럼레벨방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO, MEM_ID)
);

INSERT INTO MEM_PRI2 VALUES(1, 'USER1', 'PASS1', '홍길동', NULL, NULL, NULL);
INSERT INTO MEM_PRI2 VALUES(1, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);
INSERT INTO MEM_PRI2 VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);
SELECT * FROM MEM_PRI2;
INSERT INTO MEM_PRI2 VALUES(2, 'USER2', 'PASS2', '홍길순', NULL, NULL, NULL);

-- 복합기 사용 예시(어떤 회원이 어떤 상품을 찜하는지에 대한 데이터를 보관하는 테이블)
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY (MEM_NO, PRODUCT_NAME)
);

-- 1, 2번회원이 존재한다. 
-- 자전거A, 자전거B상품이 존재한다.

INSERT INTO TB_LIKE VALUES(1, '자전거A', SYSDATE);
SELECT * FROM TB_LIKE;
INSERT INTO TB_LIKE VALUES(1, '자전거B', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, '자전거A', SYSDATE);

--------------------------------------------------------------------------------
-- 회원등급에 대한 데이터를 따로 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

--------------------------------------------------------------------------------

INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

SELECT * FROM MEM_GRADE;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER 
);

INSERT INTO MEM VALUES(1, 'USER01', 'PASS01', '홍길동', '남', NULL, NULL, NULL);
INSERT INTO MEM VALUES(2, 'USER02', 'PASS02', '홍길순', '여', NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'USER03', 'PASS03', '강아지', NULL, NULL, NULL, 40);
--> 유요한 회원등급의번호가 아니여도 불구하고 INSERT가 잘된다.

--------------------------------------------------------------------------------

/*
    *FOREIGN KEY(왜래키) 제약조건
    다른테이블에 존재하는 값만 들어와도되는 특정 컬럼에 부여하는 제약조건
    --> 다른 테이블을 참조한다고 표현
    --> 주로 FOREIGN KEY 제약조건에 의해서 테이블간 관계가 형성된다.
    
    > 컬럼레벨방식
    컬럼명 자료형 REFERENCES 참조할테이블명[(참조할 컬럼명)]
    
    > 테이블레벨방식
    FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할 컬럼명)]
    
    -> 참조할 컬럼명 생략시 참조할 테이블에 PRIMARY KEY로 지정된 컬럼이 매칭된다.
*/

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE)
--    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE)
);

INSERT INTO MEM VALUES(1, 'USER01', 'PASS01', '홍길동', '남', NULL, NULL, NULL);
--> 외래키 제약조건이 부여된 컬럼에 기본적으로 NULL이 허용됨
INSERT INTO MEM VALUES(2, 'USER02', 'PASS02', '홍길순', '여', NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'USER03', 'PASS03', '강아지', NULL, NULL, NULL, 40);
--> PARENT KET를 찾을 수 없다는 오류 발생

-- MEM_GRADE(부모테이블) -|-----<- MEM(자식테이블)
--> 1:N관계 1쪽이 부모테이블 N이 자식테이블

INSERT INTO MEM VALUES(3, 'USER03', 'PASS03', '강아지', '여', NULL, NULL, 20);
INSERT INTO MEM VALUES(4, 'USER04', 'PASS04', '고양이', '남', NULL, NULL, 10);

--> 이때 부모테이블(MEM_GRADE)에서 데이터값을 삭제할 경우 어떤문제가 있을까?
-- 데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;

--> MEM_GRADE 테이블에서 10번등급 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> 자식테이블(MEM)에 10이라는 값을 사용하고 있기때문에 삭제가 안됨

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30;
--> 자식테이블(MEM)에 30이라는 값을 사용하고 있기 않기 때문에 삭제가 된다.
--> 부모테이블로부터 무조건 삭제가 안되는 "삭제제한" 옵션이 걸려있다.

ROLLBACK;

--------------------------------------------------------------------------------

/*
    자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능
    *삭제옵션 : 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을
                어떻게 처리할 건지
                
    -ON DELETE RESTRICTED(기본값) : 삭제제한옵션, 자식데이터로 쓰이는 부모테이터는 삭제가 아예 안됨
    -ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 사용하고 있는 자식데이터의 값을 NULL로 변경
    -ON DELETE CASCADE : 부모데이터 삭제시 해당 데이터를 삭제하고 있는 자식데이터도 같이 삭제시키는 옵션
*/

DROP TABLE MEM;
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, 'USER01', 'PASS01', '홍길동', '남', NULL, NULL, NULL);
INSERT INTO MEM VALUES(2, 'USER02', 'PASS02', '홍길순', '여', NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'USER03', 'PASS03', '강아지', '여', NULL, NULL, 20);
INSERT INTO MEM VALUES(4, 'USER04', 'PASS04', '고양이', '남', NULL, NULL, 10);

-- 10번등급 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> 잘삭제가 되었다. 단 10을 가져다 쓰고 있던 자식데이터 값은 NULL로 변경됨!

ROLLBACK;
DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO MEM VALUES(1, 'USER01', 'PASS01', '홍길동', '남', NULL, NULL, NULL);
INSERT INTO MEM VALUES(2, 'USER02', 'PASS02', '홍길순', '여', NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'USER03', 'PASS03', '강아지', '여', NULL, NULL, 20);
INSERT INTO MEM VALUES(4, 'USER04', 'PASS04', '고양이', '남', NULL, NULL, 10);

--10번등급삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;
--> 삭제가 잘 됨. 단 해당데이터를 사용하고 있던 자식데이터도 같이 DELETE가 됨
--------------------------------------------------------------------------------

/*
    <DEFAULT 기본값> *제약조건은 아니다.
    컬럼을 선정하지 않고 INSERT시 NULL이 아닌 기본값을 INSERT하고자 한다.
    이때 세팅해둘 수 있는 값
    
    컬럼명 자료형 DEFAULT 기본값
*/

DROP TABLE MEMBER;

CREATE TABLE MEMBER(
   MEM_NO NUMBER PRIMARY KEY,
   MEM_NAME VARCHAR2(20) NOT NULL,
   MEM_AGE NUMBER,
   HOBBY VARCHAR2(20) DEFAULT '없음',
   ENRILL_DATE DATE DEFAULT SYSDATE
);

-- INSERT INTO 테이블명 VALUES(컬럼값, 컬럼값,..)
INSERT INTO MEMBER VALUES(1, '김계란', 20, '운동', '15/12/12');
INSERT INTO MEMBER VALUES(2, '홍길순', NULL, NULL, NULL);
INSERT INTO MEMBER VALUES(3, '홍길동', NULL, DEFAULT, DEFAULT);

--INSERT INTO 테이블명(컬럼1, 컬럼2, 컬럼3) VALUES(컬럼1값, 컬럼2값, 컬럼3값);
INSERT INTO MEMBER(MEM_NO, MEM_NAME) VALUES(4, '김개리');
--> 선택되지 않은 컬럼에는 기본적으로 NULL이 들어감
--> 단. 해당 컬럼에 DEFAULT 값이 부여되어 있을 경우 NULL이 아닌 DEFAULT값이 들어감
--------------------------------------------------------------------------------

-- 계정 변경 KH로

CREATE TABLE EMPLOYEE_COPY
AS (SELECT * FROM EMPLOYEE);

/*
    *테이블이 다 생성된 후에 뒤늦게 제약조건을 추가하는 방법 
    ALTER TABLE 테이블명 변경할 내용
    
    -PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    -FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할컬럼명[(참조컬럼명)];
    -UNIQUE      : ALTER TABLE 테이블명 UNIQUE(컬럼명);
    -CHECK       : ALTER TABLE 테이블명 CHECK(컬럼에대한 조건식);
    -NOT NULL    : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
*/
--EMPLOYEE_COPY 테이블에 PRIMARY_KEY 제약조건을 추가(EMP_ID)
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

--EMPLOYEE 테이블에 DEPT_CODE에 왜래키 제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;
--EMPLOYEE 테이블에 JOB_CODE에 왜래키 제약조건 추가
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;
--DEPARTMENT 테이블에 LOCATION_ID에 왜래키 제약조건 추가
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION;