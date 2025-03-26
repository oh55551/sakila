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
	int filmNo=Integer.parseInt(request.getParameter("filmNo"));

	Connection conn=null;
	PreparedStatement stmt1=null;
	ResultSet rs1=null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	String sql="SELECT CONCAT(a.first_name, ' ', a.last_name) AS actorName "
				+",fa.actor_id AS actorCode "
				+"from film f "
				+"INNER JOIN film_actor fa ON f.film_id=fa.film_id "
				+"INNER JOIN actor a ON a.actor_id=fa.actor_id "
				+"where f.film_id=? "
				+"order BY f.film_id";
	stmt1 = conn.prepareStatement(sql);
	stmt1.setInt(1, filmNo);
	rs1 = stmt1.executeQuery();
	
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs1.next()){
		HashMap<String, Object> film = new HashMap<String, Object>();
		film.put("actorName", rs1.getString("actorName"));
		film.put("actorCode", rs1.getInt("actorCode"));
		
		list.add(film);
	}
%>

	<h1>캐스팅 목록</h1>
	<h2>filmOne</h2>
	<table border="10">
		<%
				for(HashMap<String, Object> f : list){
		%>
		<tr>
			<th>actor</th>
			<td><a href="/sakila/d0326/actorOne.jsp?actorCode=<%=f.get("actorCode")%>"><%=f.get("actorName") %></a></td>
		</tr>

		<%
			}
		%>	
	</table>
</body>
</html>