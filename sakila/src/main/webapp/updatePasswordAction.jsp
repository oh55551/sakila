<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	//로그아웃 상태에 로그인 페이지로 리다이렉트
	if(staffId == null){ 
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
	String password = request.getParameter("password");
	String newPassword = request.getParameter("newPassword");
	String confirmPassword = request.getParameter("confirmPassword");
	
	//비밀번호확인 & 같은비밀번호오류출력
	 if(!newPassword.equals(confirmPassword)){ //비밀번호확인
		System.out.println("수정된 비밀번호 값이 다릅니다.");
		response.sendRedirect("/sakila/updatePasswordForm.jsp");	
		return;
	}else if(password.equals(newPassword)){ //같은비밀번호설정시 오류
		System.out.println("기존과 같은 비밀번호입니다.");
		response.sendRedirect("/sakila/updatePasswordForm.jsp");	
		return;
	}
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	//비밀번호 변경 쿼리
	String sql = "UPDATE staff "
			+"SET PASSWORD = ? "
			+"WHERE staff_id = ? AND PASSWORD= ? ";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newPassword);
	stmt.setInt(2, staffId);
	stmt.setString(3, password);
	int row=stmt.executeUpdate(); //sql에 update구문 사용하였으므로
	
	if(row>0){
		System.out.println("변경완료");
		response.sendRedirect("/sakila/logout.jsp");
	}else{
		System.out.println("비밀번호를 확인해주세요.");
		response.sendRedirect("/sakila/updatePasswordForm.jsp");	
	}
	
	
	
	
	
%>