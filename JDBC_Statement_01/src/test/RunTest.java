package test;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RunTest {

	public static void main(String[] args) {
		/*
		 * * JDBC용 객체 -Connection : DB의 연결정보를 담고있는 객체 -[Prepared]Statement : 연결된 DB에
		 * SQL문을 전달해서 실행하고, 결과를 받아내는 객체 -ResultSet : SELECT문 실행 후 조회된 결과물들이 담겨있는 객체
		 * 
		 * *JDBC 과정(순서중요) 1) jdbc driver 등록 : 해당 DBMS(오라클)가 제공하는 클래스 등록 2) Connection생성
		 * : 연결하고자 하는 DB정보를 입력해서 해당 DB와 연결하면서 생성 3) Statement생성 : Connection 객체를 이용해서
		 * 생성(sql문 실행 및 결과받는 객체) 4) sql문 전달하면서 실행 : Statement 객체를 이용해서 sql문 실행 5) 결과받기 >
		 * SELECT문 실행 => ResultSet객체 (조회된 데이터들이 담겨있음) => 6_1) > DML문 실행 => int(처리된 행 수)
		 *
		 * 6_1) ResultSet에 담겨 있는 데이터들을 하나씩 하나씩 뽑아서 vo객체에 차근차근 옮겨담기[+ ArrayList에 담아주기]
		 * 6_2) 트랜잭션 처리 (성공했다면 commit, 실패했다면 rollback 실행)
		 * 
		 * 7) 다 사용한 JDBC용 객체들 반드시 자원 반납(close) => 생성된 역순으로
		 *
		 */
		
		/*
		// 1. 각자 pc(localhost)에 JDBC계정에 연결한 후 TEST테이블에 insert 해보기
		// insert => 처리된 행 수(int) => 트랜잭션

		// 필요한 변수 먼저 세팅
		int result = 0; // 결과(처리된 행수)를 받아줄 변수
		Connection conn = null; // DB의 연결정보를 보관할 객체
		Statement stmt = null; // sql문 전달해서 실행 후 결과를 받는 객체

		// 앞으로 실행할 sql문("완성형태"로 만들어 두기)(맨뒤에 세미콜론은 없어야된다!!)
		// String sql = "INSERT INTO TEST VALUES(1, '김개똥', SYSDATE)";

		Scanner sc = new Scanner(System.in);
		System.out.print("번호 : ");
		int num = sc.nextInt();
		sc.nextLine();
		
		System.out.print("이름 : ");
		String name = sc.next();
		
		String sql = "INSERT INTO TEST VALUES(" + num + ",'"+ name +"', SYSDATE)";
		System.out.println(sql);
		
		try {
			// 1) jdbc driver등록
			Class.forName("oracle.jdbc.driver.OracleDriver"); // ojdvc6.jar 파일을 추가 안했을 경우 | 추가는 했는데 오타가 있을 경우 =>
																// ClassNotFoundException발생
//			System.out.println("OracleDriver 등록성공");

			// 2) Connection객체 생성 : DB에 연결(url, 계정명, 비밀번호)
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "JDBC", "JDBC");

			// 3) Statement객체 생성
			stmt = conn.createStatement();

			// 4, 5) sql문 전달하면서 실행 후 결과받기(처리된 행수)
			result = stmt.executeUpdate(sql);
			// 내가 실행할 sql문이 dml문(insert, update, delete)일 경우 => stmt.exeuteUpdate("dml문") :
			// int
			// 내가 실행할 sql문이 select문일 경우 => stmt.executeQuery("select문") : ResultSet

			// 6) 트랜잭션 처리
			if (result > 0) { // 요청sql문 성공시 commit
				conn.commit();
			} else { // 요청sql문 실패시 rollback
				conn.rollback();
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// 7) 다쓴 JDBC용 객체 자원반납(생성된 역순으로)
			try {
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		if (result > 0) { // 요청sql문 성공시
			System.out.println("데이터 삽입 성공");
		} else { // 요청sql문 실패시
			System.out.println("데이터 삽입 실패");
		}
		*/
		
		// 2. 내 pc db상에 jdbc계정에 TEST테이블에 모든 데이터 조회해보기
		// select문 => 결과 ResultSet(조회된 데이터들 담겨있음)받기 => ResultSet으로 부터 데이터 뽑기
		
		//필요한 변수들 세팅
		Connection conn = null;
		Statement stmt = null;
		ResultSet rset = null;
		
		//실행할 sql문 작성
		String sql = "SELECT * FROM TEST where tno";
		try {
			// 1) jdbc driver등록
			Class.forName("oracle.jdbc.driver.OracleDriver"); // ojdvc6.jar 파일을 추가 안했을 경우 | 추가는 했는데 오타가 있을 경우 =>
			// ClassNotFoundException발생
			// System.out.println("OracleDriver 등록성공");
	
			// 2) Connection객체 생성 : DB에 연결(url, 계정명, 비밀번호)
			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "JDBC", "JDBC");
	
			// 3) Statement객체 생성
			stmt = conn.createStatement();
			
			// 4, 5) sql문 전달해서 실행 후 결과 받기 (ResultSet)
			rset = stmt.executeQuery(sql);
			
			//rset.next() => rset의 다음행이 들어있는지 없는지 확인후 결과 반환 + 한행을 내려준다
			
			while(rset.next()) {
				// 현재 참조하는 rset으로 부터 어떤 컬럼에 해당하는 값을 어떤 타입으로 뽑은건지 제시해줘야한다.
				// db의 컬럼명 제시(대소문자를 가리지 않는다.)
				int tno = rset.getInt("TNO");
				String tname = rset.getString("TNAME");
				Date tdate = rset.getDate("TDATE");
				
				System.out.println(tno + ", " + tname + ", " + tdate);
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
	}

}
