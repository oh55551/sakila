<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// Controller layer : staffId, password
	int staffId = Integer.parseInt(request.getParameter("staffId"));
	String password = request.getParameter("password");
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	String sql = "select staff_id as staffId, first_name as firstName from staff where staff_id=? and password=?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, staffId);
	stmt.setString(2, password);
	rs=stmt.executeQuery();
	
	boolean isLogin = false;
	if(rs.next()){
		//로그인성공
		System.out.println("로그인성공");
		//현재 세션 영역에 loginStaff라는 변수를 생성(이 변수가 접속자의 세션에 있으면 로그인 된 상태, 없으면 로그아웃 상태)
		session.setAttribute("loginStaff", rs.getInt("staffId")); //내 session안에다가 만듬
		response.sendRedirect("/sakila/index.jsp");
	}else{
		//로그인실패
		System.out.println("로그인실패");
		response.sendRedirect("/sakila/loginForm.jsp");	
	}
	
	
	
	
	
%>