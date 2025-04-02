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
	
	String sql ="select `a`.`actor_id` AS `actor_id`,`a`.`first_name` AS `first_name`,`a`.`last_name` AS `last_name`, "
			+"group_concat(distinct concat(`c`.`name`,': ',(select group_concat(`f`.`title` order by `f`.`title` ASC SEPARATOR ', ') "
					+"from ((`film` `f`" 
					+"inner join `film_category` `fc` on((`f`.`film_id` = `fc`.`film_id`))) "
					+"inner join `film_actor` `fa` on((`f`.`film_id` = `fa`.`film_id`))) " 
					+"where ((`fc`.`category_id` = `c`.`category_id`) and (`fa`.`actor_id` = `a`.`actor_id`)))) order by `c`.`name` ASC separator '; ') AS `film_info` "
					+"from (((`actor` `a` left join `film_actor` `fa` on((`a`.`actor_id` = `fa`.`actor_id`))) "
					+"left join `film_category` `fc` on((`fa`.`film_id` = `fc`.`film_id`))) "
					+"left join `category` `c` on((`fc`.`category_id` = `c`.`category_id`))) "
					+"group by `a`.`actor_id`,`a`.`first_name`,`a`.`last_name`  LIMIT ?, ?";
	String sql2="select COUNT(*) AS cnt FROM actor";
	
	stmt=conn.prepareStatement(sql);
	System.out.println(stmt);
	stmt2=conn.prepareStatement(sql2);
	System.out.println(stmt2);
	stmt.setInt(1, startIdx);      
	stmt.setInt(2, rowPerPage); 
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
<h1>actor info</h1>
<table border="1">
	<tr>
		<th>actor_id</th>
		<th>Name</th>
		<th>film_info</th>
	</tr>
	<%
		while(rs.next()){
	%>
	<tr>
		<td><%=rs.getInt("actor_id") %></td>
		<td><%=rs.getString("first_name") %><br><%=rs.getString("last_name") %></td>
		<td><%=rs.getString("film_info") %></td>
	</tr>
	
	<% 
		}
	%>
</table>

	<a href="/sakila/d0401/actorInfoList.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0401/actorInfoList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
	<%
 		if(startPage>10){
 	%>
 			<a href="/sakila/d0401/actorInfoList.jsp?currentPage=<%=startPage-10 %>">[이전]</a>
 	<% 
 		}
 	%>
 	<%
 		for(int i=startPage;i<=endPage;i++){
 	%>
 			<a href="/sakila/d0401/actorInfoList.jsp?currentPage=<%=i%>">[<%=i%>]</a>
 	<% 
 		}
 	%>
 	<%
 		if(endPage>lastPage){
 	%>
 			<a href="/sakila/d0401/actorInfoList.jsp?currentPage=<%=startPage+10 %>">[다음]</a>
	<%
 		}
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0401/actorInfoList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0401/actorInfoList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>