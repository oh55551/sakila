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
	
	String sql ="select `cu`.`customer_id` AS `ID`,concat(`cu`.`first_name`,_utf8mb4' ',`cu`.`last_name`) AS `name`,`a`.`address` AS `address`,`a`.`postal_code` AS `zip code`,`a`.`phone` AS `phone`,`city`.`city` AS `city`,`country`.`country` AS `country`,if(`cu`.`active`,_utf8mb4'active',_utf8mb4'') AS `notes`,`cu`.`store_id` AS `SID` " 
			+"from (((`customer` `cu`" 
					+"inner join `address` `a` on((`cu`.`address_id` = `a`.`address_id`))) "
					+"inner join `city` on((`a`.`city_id` = `city`.`city_id`))) "
					+"inner join `country` on((`city`.`country_id` = `country`.`country_id`))) "
					+"limit ?,?";
	String sql2="select COUNT(*) AS cnt FROM customer";
	
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
<h1>CustomerList</h1>
<table border="1">
	<tr>
		<th>customerId</th>
		<th>Name</th>
		<th>country</th>
	</tr>
	<%
		while(rs.next()){
	%>
	<tr>
		<td><%=rs.getInt("ID") %></td>
		<td><%=rs.getString("name") %></td>
		<td><%=rs.getString("country") %></td>
	</tr>
	
	<% 
		}
	%>
</table>

	<a href="/sakila/d0401/customerListList.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0401/customerListList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
	<%
 		if(startPage>10){
 	%>
 			<a href="/sakila/d0401/customerListList.jsp?currentPage=<%=startPage-10 %>">[이전]</a>
 	<% 
 		}
 	%>
 	<%
 		for(int i=startPage;i<=endPage;i++){
 	%>
 			<a href="/sakila/d0401/customerListList.jsp?currentPage=<%=i%>">[<%=i%>]</a>
 	<% 
 		}
 	%>
 	<%
 		if(endPage>lastPage){
 	%>
 			<a href="/sakila/d0401/customerListList.jsp?currentPage=<%=startPage+10 %>">[다음]</a>
	<%
 		}
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0401/customerListList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0401/customerListList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>