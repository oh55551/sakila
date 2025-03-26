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
	
	String sql="SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS actorName "
			+",fa.actor_id AS actorCode "
			+"from film f "
			+"INNER JOIN film_actor fa ON f.film_id=fa.film_id "
			+"INNER JOIN actor a ON a.actor_id=fa.actor_id "
			+"order BY fa.actor_id "
			+"limit ?,? ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startIdx);
	stmt.setInt(2, rowPerPage);
	rs=stmt.executeQuery();
	
	PreparedStatement stmt2 = null;
	ResultSet rs2=null;	
	String sql2="select count(*) cnt from actor";
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
		film.put("actorName", rs.getString("actorName"));
		film.put("actorCode", rs.getString("actorCode"));
		 
		list.add(film);
	}
	%>
	
	<h1>배우 리스트</h1>
	<h2>actorList</h2>
	<table border="10">
		<tr>
			<th>actorCode</th>
			<th>actorName</th>
	
		</tr>
		<%
				for(HashMap<String, Object> f : list){
		%>
		<tr>
			<td><%=f.get("actorCode")%></td>
			<td><a href="/sakila/d0326/actorOne.jsp?actorCode=<%=f.get("actorCode")%>"><%=f.get("actorName")%></a></td>
		</tr>
		<%
			}
		%>	
	</table>
	
		<a href="/sakila/d0326/actorList.jsp?currentPage=1">[첫페이지로]</a>
		<%
			if(currentPage>1){
		%>	<a href="/sakila/d0326/actorList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%
			}
		%>
		
		<%=currentPage %>
		<%
			if(currentPage<lastPage){
		%> 	
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
		<%
			}
		%>
		<a href="/sakila/d0326/actorList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>