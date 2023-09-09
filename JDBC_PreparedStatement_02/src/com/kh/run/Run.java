package com.kh.run;

import com.kh.view.MemberMenu;

public class Run {

	public static void main(String[] args) {
		/*
		 * M(model) : 데이터 처리 담당(데이터들을 담기위한 클래스(vo), 데이터들이 보관된 공간(db)과 직접적으로 접근해서 데이터 주고받기(dao),...)
		 * V(view) : 화면을 담당(사용자가 보게되는 시각적인 요소, 출력및 입력)
		 * C(Controller) : 사용자의 요청을 처리해주는 담당(사용자의 요청을 처리한 후 그에 해당하는 응답화면 지정)
		 * */
		
		
		//run : 프로그램 실행담당(즉, 사용자가 보게될 첫 화면만 띄워주고 끝)
		new MemberMenu().mainMenu();
	}

}
