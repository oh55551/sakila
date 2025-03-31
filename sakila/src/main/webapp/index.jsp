<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId == null){ //로그아웃 상태라면
		//로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<div>
		<%=staffId%>님 반갑습니다.
		<a href="/sakila/logout.jsp">[로그아웃]</a>
		<a href="/sakila/updatePasswordForm.jsp">[비밀번호수정]</a> <!-- 이전비밀번호->수정할비밀번호 -->
	</div>
	<hr>
	<h1>INDEX</h1>
	<ol>
		<li><a href="/sakila/rentalList.jsp">렌탈목록</a></li>
		<li><a href="/sakila/d0326/filmList.jsp">필름목록</a></li>
		<li><a href="/sakila/d0326/actorList.jsp">배우목록</a></li>
		<li><a href="/sakila/d0327/inventory.jsp">인벤토리목록</a></li>
	</ol>
</body>
</html>