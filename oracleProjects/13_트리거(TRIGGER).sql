/*
    <트리거>
    내가 지정한 테이블에 INSERT, UPDATE, DELETE등 DML문에 의해 변경사항이 생길때
    (테이블에 이벤트가 발생했을 때)
    자동으로 매번 실행할 내용을 미리 정의해 둘 수 있다.
    
    EX)
    회원탈퇴시 기존의 회원테이블에 데이터 DELETE 후 곧바로 탈퇴한 회원들만 따로 보관하는 테이블에
    자동으로 INSERT 시켜야 한다.
    신고횟수가 일정 수를 넘었을 때 묵시적으로 해당 회원을 블랙리스트로 처리되게끔
    입출고에 대한 데이터가 기록(INSERT)될때마다 해당 상품에 대한 재고수량을 매번 수정(UPDATE)해야 된다.
    
    *트리거의 종류
    -SQL문의 실행시기에 따른 분류
     >BEFROE TRIGGER : 내가 지정한 테이블에 이벤트가 발생되기 전에 트리거 실행
     >AFTER TRIGGER : 내가 지정한 테이블에 이벤트가 발생한 후 트리거 실행
     
    -SQL문에 의해 영향을 받는 각 행에 따른 분류
     >문장트리거 : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
     >행트리거 : 해당 SQL문 실행할 때마다 매번 트리거 실행
                (FOR EACH ROW옵션 기술해야함)
                > :OLD -BEFORE UPDATE(수정전자료), BEFORE DELETE(삭제전 자료)
                > :NEW -AFTER INSERT(추가된 자료), AFTER UPDATE(수정후 자료)
                
    *트리거 생성 구문
    
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE | AFTER      INSERT | UPDATE | DELETE    ON 테이블명
    [FOR EACH ROW]
    [DECLARE
        변수 선언]
    BEGIN
        실행내용(해당 위에 지정된 이벤트 발생시 묵시적(자동)으로 실행할 구문)
    [EXCEPTION
        예외처리]
    END;
    /
*/

--EMPLOYEE테이블에 새로운 행이 INSERT될 때마다 자동으로 출력되는 트리거 정의
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(500, '이순신', '111111-1111111', 'D7', 'J7', SYSDATE);

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(501, '김유신', '111111-1111111', 'D8', 'J7', SYSDATE);

--------------------------------------------------------------------------------
-- 상품입고 및 출고관련 예시
--> 필요한 테이블 및 시퀀스생성

--1. 상품에대한 데이터를 보관할 테이블(TB_PRODUCT)
DROP TABLE TB_PRODUCT;
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- 상품번호
    PNAME VARCHAR2(30) NOT NULL, -- 상품명
    BRAND VARCHAR2(30) NOT NULL, -- 브랜드
    PRICE NUMBER, -- 가격
    STOCK NUMBER DEFAULT 0 --재고
);

--상품번호 중복 안되게끔 매번 새로운 번호를 발생시키는 시퀀스(SEQ_PCODE)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

--샘플데이터 추가
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시23', '샘송', 1400000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰15', '사과', 1300000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤우미', 700000, 20);

SELECT * FROM TB_PRODUCT;

COMMIT;

--2. 상품 입출고 상세 이력 테이블생성(TB_PRODETAIL)
--어떤 상품이 어떤날짜에 몇개가 입고 또는 출고가 되었는지에 대한 데이터를 기록
CREATE TABLE TB_PRODETAIL(
    DECODE NUMBER PRIMARY KEY, --이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT, -- 상품번호
    PDATE DATE NOT NULL, --입출고일
    AMOUNT NUMBER NOT NULL, --입출고수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고')) --상태(입고, 출고)
);

--이력번호로 매번 새로운 번호 발생시켜서 들어갈 수 있게 도와주는 시퀀스 생성
CREATE SEQUENCE SEQ_DECODE
NOCACHE;

--200번 상품이 오늘날짜로 10개 입고
INSERT INTO TB_PRODETAIL
VALUES(seq_decode.nextval, 200, SYSDATE, 10, '입고');

--200번상품의 재고수량을 10증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT;

--205번 상품이오늘 날짜로 20개입고
INSERT INTO TB_PRODETAIL
VALUES(seq_decode.nextval, 205, SYSDATE, 20, '입고');

--205번 상품의 재고 수량을 20증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 25;

ROLLBACK;

--205번 상품이 오늘날짜로 20개입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 205, SYSDATE, 20, '입고');

--205번상품의 재고수량을 20증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 205;

COMMIT;

--TB_PRODETAIL테이블에 INSERT이벤트 발생시
--TB_PRODUCT테이블에 매번 자동으로 재고수량을 UPDATE되게끔 트리거 정의

/*
    -상품이 입고된 경우 --> 해당 상품을 찾아서 재고수량 증가 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK + 현재입고된 수량(INSERT된 자료의 AMOUNT)
    WHERE PCODE = 입고된상품번호(INSERT된 자료의 PCODE값)
    
    -상품이 출고된 경우 --> 해당 상품을 찾아서 재고수량 감소 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK - 현재입고된 수량(INSERT된 자료의 AMOUNT)
    WHERE PCODE = 입고된상품번호(INSERT된 자료의 PCODE값)
*/

CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    IF(:NEW.STATUS = '입고')
        THEN UPDATE TB_PRODUCT
            SET STOCK = STOCK + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
    IF(:NEW.STATUS = '출고')
        THEN UPDATE TB_PRODUCT
            SET STOCK = STOCK - :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

--210번 상품이 오늘날짜로 7개 출고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 210, SYSDATE, 7, '출고');

--200번 상품이 오늘날짜로 100개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DECODE.NEXTVAL, 200, SYSDATE, 100, '입고');