--�ǽ�����--
--�������� ���α׷��� ����� ���� ���̺�� �����--
--�̶�, �������ǿ� �̸��� �ο��� ��
--   �� �÷��� �ּ��ޱ�

/*
    1. ���ǻ�鿡 ���� �����͸� ������� ���ǻ� ���̺�(TB_PUBLISHER)
    �÷� : PUB_NO(���ǻ� ��ȣ) - �⺻Ű(PUBLISHER_PK)
          PUB_NAME(���ǻ��) -- NOT NULL(PUBLISHER_NN)
          PHONE(���ǻ���ȭ��ȣ) -- �������Ǿ���
*/
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY,
    PUB_NAME VARCHAR2(20) CONSTRAINT PUBLISHER_NN NOT NULL,
    PHONE VARCHAR2(13)
);
--���� 3������ ����
INSERT INTO TB_PUBLISHER VALUES(1, 'KH_PB', '010-1111-1111');
INSERT INTO TB_PUBLISHER VALUES(2, 'I_PB', '010-2222-2222');
INSERT INTO TB_PUBLISHER VALUES(3, 'SQL_PB', '010-3333-3333');

/*
    2. �����鿡 ���� �����͸� ������� ���� ���̺�(TB_BOOK)
    �÷� : BK_NO(������ȣ)--�⺻Ű(BOOK_PK)
          BK_TITLE(������)--NOT NULL(BOOK__NN_TITLE)
          BK_AUTHOR(���ڸ�)--NOT NULL(BOOK__NN_AUTHOR)
          BK_PRICE(����)-- �������Ǿ���
          BK_PUB_NO(���ǻ� ��ȣ)--�ܷ�Ű(BOOK_FK)(TB_PUBLISHER���̺��� ����)
                                �̶� �����ϰ� �ִ� �θ����� ������ �ڽĵ����͵� ���� �ǵ��� �ɼ�����                
*/

CREATE TABLE TB_BOOK(
    BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BK_TITLE VARCHAR2(40) CONSTRAINT BOOK__NN_TITLE NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT BOOK__NN_AUTHOR NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER REFERENCES TB_PUBLISHER(PUB_NO) ON DELETE CASCADE
);
--5�� ������ ���� ������ �߰��ϱ�
INSERT INTO TB_BOOK VALUES(100, '�ڵ�', 'ȫ�浿', 15000, 1);
INSERT INTO TB_BOOK VALUES(101, '�ڹ�', 'ȫ���', 20000, 2);
INSERT INTO TB_BOOK VALUES(102, 'SQL', 'ȫȫȫ', 10000, 3);
INSERT INTO TB_BOOK VALUES(103, 'HTML', '����', 27000, 1);
INSERT INTO TB_BOOK VALUES(104, 'CSS', '������', 16000, 2);

/*
    3. ȸ���� ���� �����͸� ������� ȸ�� ���̺�(TB_MEMBER)
    �÷��� : MEMBER_NO(ȸ����ȣ) -- �⺻Ű(MEMBER_PK)
            MEMBER_ID(���̵�) -- �ߺ�����(MEMBER_UQ_ID)
            MEMBER_PWD(��й�ȣ) -- NOT NULL(MEMBER_NN_PWD)
            MEMBER_NAME(ȸ����) -- NOT NULL(MEMBER_NN_NAME)
            GENDER(����) -- M�Ǵ� F�� �Էµǵ��� ����(MEMBER_CK_GEN)
            ADDRESS(�ּ�) -- �������Ǿ���
            PHONE(����ó)-- �������Ǿ���
            STATUS(Ż�𿩺�) -- �⺻���� N���� ����, �׸��� N�Ǵ� Y�� �Էµǵ��� �������� ����(MEMBER_CK_STA)
            ENROLL_DATE(������) -- �⺻������ SYSDATE, NOT NULL ��������(MEMBER_NN_EN)
*/
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) CONSTRAINT MEMBER_UQ_ID UNIQUE,
    MEMBER_PWD VARCHAR2(20) CONSTRAINT MEMBER_NN_PWD NOT NULL,
    MEMBER_NAME VARCHAR2(10) CONSTRAINT MEMBER_NN_NAME NOT NULL,
    GENDER CHAR(1) CONSTRAINT MEMBER_CK_GEN CHECK(GENDER IN ('M','F')),
    ADDRESS VARCHAR2(45),
    PHONE VARCHAR2(13),
    STATUS CHAR(1) DEFAULT 'N' CONSTRAINT MEMBER_CK_STA CHECK(STATUS IN('N','Y')),
    ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
);
--5�� ������ ���� ������ �߰��ϱ�
INSERT INTO TB_MEMBER VALUES(500, 'USER01', 'USER01', '�ƹ���', 'M', '�����', '010-4444-4444', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(501, 'USER02', 'USER02', '����', 'F', '������', '010-5555-5555', 'N', DEFAULT);
INSERT INTO TB_MEMBER VALUES(502, 'USER03', 'USER03', '������', 'M', NULL, '010-5555-5555', 'Y', '19-03-18');
INSERT INTO TB_MEMBER VALUES(503, 'USER04', 'USER04', '�ڹڹ�', 'F', NULL, NULL, 'N', DEFAULT);
INSERT INTO TB_MEMBER VALUES(504, 'USER05', 'USER05', 'JOHN ROE', 'M', 'california', NULL, 'N', '20-10-20');

/*
    4.� ȸ���� � ������ �뿩�ߴ����� ���� �뿩��� ���̺�(TB_RENT)
    �÷��� : RENT_NO(�뿩��ȣ)-- �⺻Ű(RENT_PK)
            RENT_MEM_NO(�뿩ȸ����ȣ)-- �ܷ�Ű(RENT_FK_MEM) TB_MEMBER�� �����ϵ���
                                        �̶� �θ� ������ ������ �ڽĵ����� ���� NULL�� �ǵ��� ����
            RENT_BOOK_NO(�뿩������ȣ)-- �ܷ�Ű(RENT_FK_BOOK) TB_BOOK�� �����ϵ���
                                        �̶� �θ� ������ ������ �ڽĵ����� ���� NULL�� �ǵ��� ����
            RENT_DATE(�뿩��) -- �⺻�� SYSDATE
*/
CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER(MEMBER_NO) ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK(BK_NO) ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);
--3�� ������ ���� ������ �߰��ϱ�
INSERT INTO TB_RENT VALUES(1000, 500, 100, DEFAULT);
INSERT INTO TB_RENT VALUES(1001, 501, 101, DEFAULT);
INSERT INTO TB_RENT VALUES(1002, 504, 104, DEFAULT);
