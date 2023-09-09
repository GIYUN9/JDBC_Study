package com.kh.model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import com.kh.model.vo.Member;

//DAO(Data Access Object) : DB에 직접적으로 접근해서 사용자의 요청에 맞는 sql문 실행 후 결과 반환(JDBC)
//							결과를 Controller로 다시 리턴
public class MemberDao {
	/*
	 * * JDBC용 객체 
	 * -Connection : DB의 연결정보를 담고있는 객체 
	 * -[Prepared]Statement : 연결된 DB에
	 * SQL문을 전달해서 실행하고, 결과를 받아내는 객체 
	 * -ResultSet : SELECT문 실행 후 조회된 결과물들이 담겨있는 객체
	 * 
	 * *JDBC 과정(순서중요) 
	 * 1) jdbc driver 등록 : 해당 DBMS(오라클)가 제공하는 클래스 등록 
	 * 2) Connection생성 : 연결하고자 하는 DB정보를 입력해서 해당 DB와 연결하면서 생성 
	 * 3) Statement생성 : Connection 객체를 이용해서 생성(sql문 실행 및 결과받는 객체) 
	 * 4) sql문 전달하면서 실행 : Statement 객체를 이용해서 sql문 실행 
	 * 5) 결과받기
	 * 			> SELECT문 실행 => ResultSet객체 (조회된 데이터들이 담겨있음) => 6_1) 
	 * 			> DML문 실행 => int(처리된 행 수)
	 * 6_1) ResultSet에 담겨 있는 데이터들을 하나씩 하나씩 뽑아서 vo객체에 차근차근 옮겨담기[+ ArrayList에 담아주기]
	 * 6_2) 트랜잭션 처리 (성공했다면 commit, 실패했다면 rollback 실행)
	 * 
	 * 7) 다 사용한 JDBC용 객체들 반드시 자원 반납(close) => 생성된 역순으로
	 *
	 */
	/**
	 * 사용자가 입력한 정보들을 db
	 * @param m
	 * @return 
	 */
	public int insertMember(Member m) {
		// insert문 => 처리된 행수를(int) => 트랜잭션 처리
		
		//필요한 변수들 먼저 세팅
		int result =0; // 처리된 결과(처리된 행수)를 받아줄 변수
		Connection conn = null; // 연결된db의 연결정보를 담는 객체
		Statement stmt = null; // 완성된 sql문 전달해서 곧바로 실행 후 결과를 받는 객체
		
		//실행할 sql문(완성된 형태)
		//		INSERT INTO MEMBER
		// VALUES(SQ~~~~, ~~~, ''~~~'
		//			....
		//			);
		
		String sql = "INSERT INTO MEMBER VALUES(SEQ_USERNO.NEXTVAL, "
				+ "'" + m.getUserId() 	+ "',"
				+ "'" + m.getUserPwd()	+ "',"
				+ "'" + m.getUserName()	+ "',"
				+ "'" + m.getGender()	+ "',"
					  + m.getAge()		+ ","
				+ "'" + m.getEmail()	+ "',"
				+ "'" + m.getPhone()	+ "',"
				+ "'" + m.getAddress()	+ "',"
				+ "'" + m.getHobby()	+ "', SYSDATE)";
		
		try {
			// 1) jdbc driver등록
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			// 2) Connection 객체 생성 => db연결
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
			
			// 3) Statement 객체 생성
			stmt = conn.createStatement();
			
			// 4, 5) sql문 전달하면서 실행 후 결과받기(처리된 행수)
			result = stmt.executeUpdate(sql);
			
			//6 트랜잭션처리
			if(result > 0) {
				conn.commit();
			} else {
				conn.rollback();
			}
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// 7) 다쓴 jdbc객체들 반환
			
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
		
				e.printStackTrace();
			}
		}
		
		return result;
	}
	

	public ArrayList<Member> selectList() {
		// select문(여러행 조회) => ResultSet객체 => ArrayList<Member>에 담기
		
		//필요한 변수들 세팅
		ArrayList<Member> list = new ArrayList<>(); // 비어있는 상태
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null; // select문 실행시 조회된 결과값들이 최초로 담기는객체
		
		// 실행할 sql
		String sql = "SELECT * FROM MEMBER";
		
		try {
			// 1)JDBC 드라이버 등록
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			// 2)Connection 생성
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
		
			// 3)Statement 생성
			stmt = conn.createStatement();
			
			// 4, 5) sql문 실행및 결과 받기
			rset = stmt.executeQuery(sql);
			
			// 6) ResultSet으로부터 데이터를 하나씩 꺼내서
			while(rset.next()) {
				Member m = new Member();
				m.setUserNo(rset.getInt("userno"));
				m.setUserId(rset.getString("userid"));
				m.setUserPwd(rset.getString("userpwd"));
				m.setUserName(rset.getString("username"));
				m.setGender(rset.getString("gender"));
				m.setAge(rset.getInt("age"));
				m.setEmail(rset.getString("email"));
				m.setPhone(rset.getString("phone"));
				m.setAddress(rset.getString("address"));
				m.setHobby(rset.getString("hobby"));
				m.setEnrollDate(rset.getDate("enrolldate"));
				//현재 참조하고있는 행에 대한 모든 컬럼에 데이터들을 한 Member객체에 담기! 끝!
				
				list.add(m);// 리스트에 담기
			}
			
			//반복문이 끝난 시점
			// 조회된 데이터가 없다면 리스트는 비어있을 것이다.
			// 조회된 데이터가 있다면 list에는 한개이상 담겨있을 것이다.
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rset.close();
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} 
		
		return list;
	}

	public Member selectByUserId(String userId) {
		// select문(한개) => ResultSet객체 => Member객체
		
		Member m = null;
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;
		
		// 실행할 sql문
		String sql = "SELECT * FROM MEMBER WHERE USERID = '" + userId + "'";
		
		try {
			// 1)
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			// 2)
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
			
			// 3)
			stmt = conn.createStatement();
			
			// 4, 5)
			rset = stmt.executeQuery(sql);
			
			// 6)
			
			if (rset.next()) {
				m = new Member(rset.getInt("userno"),
						rset.getString("userid"),
						rset.getString("userpwd"),
						rset.getString("username"),
						rset.getString("gender"),
						rset.getInt("age"),
						rset.getString("email"),
						rset.getString("phone"),
						rset.getString("address"),
						rset.getString("hobby"),
						rset.getDate("enrolldate"));
			}
			// 위의 조건문 다 끝난 시점
			// 만약 조회된 데이터가 없다면 => m => null
			// 만약 조회된 데이터가 있다면 => m는 생성된 객체
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rset.close();
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return m;
	}
	
	public ArrayList<Member> selectByUserName(String keyword) {
		// select문(여러행) => ResultSet객체 => ArrayList<Member> 객체에 담기
		
		ArrayList<Member> list = new ArrayList<>(); // 텅빈상태

		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;
		
		//SELECT * FROM MEMBER WHERE USERNAME LIKE '%"+keyword+"%'
		String sql= "SELECT * FROM MEMBER WHERE USERNAME LIKE '%"+keyword+"%'";
		
		try {
			// 1)
			Class.forName("oracle.jdbc.driver.OracleDriver");
			
			// 2)
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
			
			// 3)
			stmt = conn.createStatement();
			
			// 4, 5)
			rset = stmt.executeQuery(sql);
			
			// 6)
			while(rset.next()) {
				Member m = new Member();
				m.setUserNo(rset.getInt("userno"));
				m.setUserId(rset.getString("userid"));
				m.setUserPwd(rset.getString("userpwd"));
				m.setUserName(rset.getString("username"));
				m.setGender(rset.getString("gender"));
				m.setAge(rset.getInt("age"));
				m.setEmail(rset.getString("email"));
				m.setPhone(rset.getString("phone"));
				m.setAddress(rset.getString("address"));
				m.setHobby(rset.getString("hobby"));
				m.setEnrollDate(rset.getDate("enrolldate"));
				//현재 참조하고있는 행에 대한 모든 컬럼에 데이터들을 한 Member객체에 담기! 끝!
				
				list.add(m);// 리스트에 담기
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				rset.close();
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return list;
	}
	
	public int updateMember(Member m) {
		// update문 => 처리된 행 수(int) => 트랜잭션 처리
		int result = 0;
		
		Connection conn = null;
		Statement stmt = null;
		
		/*
		 * update member
		 * set userpwd = 'xx', email = 'xx', phone = 'xx', address = 'xx'
		 * where userid = 'xxx';
		 */
		
		String sql = "UPDATE MEMBER "
				+ "SET USERPWD = '" + m.getUserPwd() + "' "
					+ ", EMAIL = '" + m.getEmail()	 + "' "
					+ ", PHONE = '" + m.getPhone()	 + "' "
					+ ", ADDRESS = '" + m.getAddress() + "' "
					+ "WHERE USERID = '" + m.getUserId() + "' ";
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
			stmt = conn.createStatement();	
			result = stmt.executeUpdate(sql);
			
			if (result > 0) {
				conn.commit();
			} else {
				conn.rollback();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	public int deleteMember(String userid) {
		// delete문 => 처리된 행 수(int) => 트랜잭션처리
		int result = 0;
		
		Connection conn = null;
		Statement stmt = null;
		
		String sql = "DELETE FROM MEMBER WHERE USERID = '" + userid +"'";
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","JDBC","JDBC");
			stmt = conn.createStatement();	
			result = stmt.executeUpdate(sql);
			
			if (result > 0) {
				conn.commit();
			} else {
				conn.rollback();
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
}
