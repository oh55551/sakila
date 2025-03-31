<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId != null){ //로그인 상태라면
		//로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/index.jsp");	
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
	<h1>Staff Login</h1>
	<form action="/sakila/loginAction.jsp" method="post"> 
	<!-- 
		a태그랑 동일한반식 기본적인 method:"get"으로 넘기면 loginAction.jsp?number= & password= 매개값이 노출
		브라우저 주소창에 문자열형태로 넘어감 <- 길이가 제한
		
		데이터값을 매개값으로 다른페이지로 전송
		1) a 태그 이용 : get
		2) form 태그의 method 속성 : get, post
		method="post" 로 웬만하면 넘기는게 좋음(보안 우수 데이터도 더 많이보낼수있음)
	-->
	<table border="10">
		<tr>
			<th>staffId</th>
			<td><input type="number" name="staffId"></td>
		</tr>
		<tr>
			<th>password</th>
			<td><input type="password" name="password"></td>
		</tr>
	</table>
	<button type="submit">로그인</button>
	</form>
</body>
</html>