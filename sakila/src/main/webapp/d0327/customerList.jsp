<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId == null){ //로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
%>
	<div><a href="/sakila/d0327/insertRental.jsp?inventoryId=1">대여하기</a></div>
	<div>
		<a href="/sakila/index.jsp">[홈화면으로]</a>
	<br>
		<%=staffId%>님 반갑습니다.
		<a href="/sakila/logout.jsp">[로그아웃]</a>
	</div>
	<hr>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
</body>
</html>