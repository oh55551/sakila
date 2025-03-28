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
	<h1>비밀번호 변경</h1>
	<form action="/sakila/updatePasswordAction.jsp">
	<table border="10">
		<tr>
			<th>기존 비밀번호</th>
			<td><input type="number" name="password"></td>
		</tr>
		<tr>
			<th>변경 할 비밀번호</th>
			<td><input type="password" name="newPassword"></td>
			<th>비밀번호확인</th>
			<td><input type="password" name="confirmPassword"></td>
		</tr>
	</table>
	<button type="submit">[비밀번호변경]</button>
	</form>
</body>
</html>