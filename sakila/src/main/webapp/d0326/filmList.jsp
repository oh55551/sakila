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
<% 
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage= Integer.valueOf(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	int startIdx = (currentPage-1)*rowPerPage;

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	String sql="select f.film_id AS filmId "
			+",f.title AS filmTitle "
			+"from film f " 
			+"order by film_id desc limit ?,?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startIdx);
	stmt.setInt(2, rowPerPage);
	rs=stmt.executeQuery();
	
	PreparedStatement stmt2 = null;
	ResultSet rs2=null;	
	String sql2="select count(*) cnt from film";
	stmt2=conn.prepareStatement(sql2);
	rs2 = stmt2.executeQuery();
	rs2.next();
	
	int totalCnt= rs2.getInt("cnt");
	int lastPage=totalCnt/rowPerPage;
	if(totalCnt%rowPerPage !=0){
		lastPage=lastPage+1;
	}
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> film = new HashMap<String, Object>();
		film.put("filmNo", rs.getString("filmId"));
		film.put("filmTitle", rs.getString("filmTitle"));
		
		list.add(film);
	}
%>

	<h1>영화리스트</h1>
	<h2>filmList</h2>
	<table border="10">
		<tr> 
			<th>filmNo</th>
			<th>filmTitle</th>

		</tr>
		<%
				for(HashMap<String, Object> f : list){
		%>
		<tr>
			<td><%=f.get("filmNo")%></td>
			<td><a href="/sakila/d0326/filmOne.jsp?filmNo=<%=f.get("filmNo")%>"><%=f.get("filmTitle")%></a></td>
		</tr>
		<%
			}
		%>	
	</table>
	<a href="/sakila/d0326/filmList.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0326/filmList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
	
	<%=currentPage %>
	<%
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0326/filmList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0326/filmList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>