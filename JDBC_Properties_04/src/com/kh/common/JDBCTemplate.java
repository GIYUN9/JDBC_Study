package com.kh.common;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

//공통 템플릿(매번 반복적으로 작성될 코드를 메소드로 정의해둠)
public class JDBCTemplate {

	/*
	 * 기존의 방식 : jdbc driver구문, 접속할 db의 url, 접속할 계정명/비번등을 자바소스코드 내에 명시적으로 작성함 => 정적코드방식
	 *  > 문제점 : dbms가 변경되었을 경우, 접속할 db의 url또는 계정명/비번이 변경될 경우 => 자바코드를 수정해야한다.
	 *  	=> 수정된 내용을 반영시키고자 한다면 프로그램을 재구동 해야한다.
	 *  	=> 유지보수가 불편하다.
	 *  
	 * > 해결방식 : db와 관련된 정보들을 별도로 관리하는 외부파일(.properties)로 만들어서 관리
	 * 			 외부파일로부터 읽어들여서 반영 시키면 된다. 
	 * 
	 */
	
	public static Connection getConnection(){
		Connection conn = null;
		Properties prop = new Properties();
		try {
			prop.load(new FileInputStream("resources/driver.properties"));
			
			Class.forName(prop.getProperty("driver"));
			conn = DriverManager.getConnection(prop.getProperty("url"),
												prop.getProperty("username"),
												prop.getProperty("password"));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
	// 2. commit 처리해주는 메소드(Connection 전달받아서)
	public static void commit(Connection conn) {
		try {
			if(conn != null && !conn.isClosed())
				conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 3. rollback 처리해주는 메소드(Connection 전달받아서)
	public static void rollback(Connection conn) {
		try {
			if(conn != null && !conn.isClosed())
				conn.rollback();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// JDBC용 객체들 전달받아서 반납처리해주는 메소드
	// 4.Statement관련 객체 전달받아 반답시켜주는 메소드
	public static void close(Statement stmt) {
		try {
			if(stmt != null && !stmt.isClosed())
				stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 5. Connection 객체 전달받아서 반납시켜주는 메소드
	public static void close(Connection conn) {
		try {
			if(conn != null && !conn.isClosed())
				conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 6. ResultSet 객체 전달받아서 반납시켜주는 메소드
	public static void close(ResultSet rset) {
		try {
			if(rset != null && !rset.isClosed())
				rset.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
