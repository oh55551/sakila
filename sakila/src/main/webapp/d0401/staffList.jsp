<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<%
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	int rowPerPage = 10;
	int startIdx = (currentPage - 1) * rowPerPage;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");

	PreparedStatement stmt = null;
	ResultSet rs = null;
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	String sql ="SELECT category_id, GROUP_CONCAT(film_id) as filmId FROM film_category GROUP BY category_id LIMIT ?, ?";
	String sql2="SELECT COUNT(DISTINCT category_id) AS cnt FROM film_category limit ?,?";
	
	stmt=conn.prepareStatement(sql);
	System.out.println(stmt);
	stmt2=conn.prepareStatement(sql2);
	System.out.println(stmt2);
	stmt.setInt(1, startIdx);      
	stmt.setInt(2, rowPerPage); 
	stmt2.setInt(1, startIdx);      
	stmt2.setInt(2, rowPerPage); 
	rs=stmt.executeQuery();
	rs2=stmt2.executeQuery();
	
	int totalIdx = 0;
	if (rs2.next()) {
	    totalIdx = rs2.getInt("cnt");
	}
 	int lastPage = totalIdx / rowPerPage;
 	if(totalIdx % rowPerPage != 0){
 		lastPage++;
 	}
 	
 	// 1~10페이지
 	int pageGroup = (currentPage-1) / 10;
 	int startPage = pageGroup * 10 + 1;
 	int endPage = startPage + 9;
 	if(endPage>lastPage){
 		endPage=lastPage; }
%>
<h1>StaffList</h1>
<table border="1">
	<tr>
		<th>category_id</th>
		<th>film_id(category_id)</th>
	</tr>
	<%
		while(rs.next()){
	%>
	<tr>
		<td><%=rs.getInt("category_id") %></td>
		<td><%=rs.getString("filmId") %></td>
	</tr>
	
	<% 
		}
	%>
</table>
	
	<a href="/sakila/d0401/staffList.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0401/staffList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
	<%
 		if(startPage>10){
 	%>
 			<a href="/sakila/d0401/staffList.jsp?currentPage=<%=startPage-10 %>">[이전]</a>
 	<% 
 		}
 	%>
 	<%
 		for(int i=startPage;i<=endPage;i++){
 	%>
 			<a href="/sakila/d0401/staffList.jsp?currentPage=<%=i%>">[<%=i%>]</a>
 	<% 
 		}
 	%>
 	<%
 		if(endPage>lastPage){
 	%>
 			<a href="/sakila/d0401/staffList.jsp?currentPage=<%=startPage+10 %>">[다음]</a>
	<%
 		}
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0401/staffList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0401/staffList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>