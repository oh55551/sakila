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
	int actorCode=Integer.parseInt(request.getParameter("actorCode"));

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	
	String sql="SELECT f.film_id AS filmNo "
			+",f.title AS filmTitle "
			+",fa.actor_id AS actorCode "
			+"from film f "
			+"INNER JOIN film_actor fa ON f.film_id=fa.film_id "
			+"INNER JOIN actor a ON a.actor_id=fa.actor_id "
			+"where fa.actor_id= ? "
			+"order BY f.film_id";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, actorCode);
	rs=stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> film = new HashMap<String, Object>();
		film.put("filmNo", rs.getString("filmNo"));
		film.put("filmTitle", rs.getString("filmTitle"));
		film.put("actorCode", rs.getInt("actorCode"));
		
		list.add(film);
	}
%>

	<h1>출연작 정보</h1> 
	<h2>actorOne</h2>
	<table border="10">
		<tr>
			<th>filmNo</th>
			<th>filmTitle</th>
		</tr>
		<%
			for(HashMap<String, Object> f : list){
		%>
		<tr>
			<th><%=f.get("filmNo") %></th>
			<td><a href="/sakila/d0326/filmOne.jsp?filmNo=<%=f.get("filmNo")%>"><%=f.get("filmTitle") %></a></td>
		</tr>
		<%
			}
		%>
</body>
</html>