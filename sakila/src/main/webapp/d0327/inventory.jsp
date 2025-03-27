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

	String sql =  "SELECT t1.inventory_id AS id, t1.title AS title, t2.ISrental AS rental, t2.return_date AS returndate "
		    + "FROM (SELECT i.inventory_id, f.title "
		    + "FROM inventory i INNER JOIN film f "
		    + "ON i.film_id = f.film_id) t1 "
		    + "LEFT JOIN (SELECT inventory_id, rental_date, return_date, " // ← return_date 추가됨
		    + "CASE WHEN return_date IS NULL THEN '대여불가' "
		    + "ELSE '대여가능' END AS ISrental "
		    + "FROM rental WHERE (inventory_id, rental_date) IN ("
		    + "SELECT inventory_id, MAX(rental_date) FROM rental GROUP BY inventory_id) "
		    + ") t2 ON t1.inventory_id = t2.inventory_id "
		    + "LIMIT ?, ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startIdx);
	stmt.setInt(2, rowPerPage);
	rs=stmt.executeQuery();
	
	PreparedStatement stmt2 = null;
	ResultSet rs2=null;	
	String sql2="select count(*) cnt from inventory";
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
		HashMap<String, Object> inventory = new HashMap<String, Object>();
		inventory.put("inventoryId", rs.getString("id"));
		inventory.put("filmTitle", rs.getString("title"));
		inventory.put("rental", rs.getString("rental"));
		inventory.put("returnDate", rs.getString("returndate"));
		
		list.add(inventory);
	}
%>

	<h2>inventoryList</h2>
	<table border="10">
		<tr> 
			<th>inventoryId</th>
			<th>filmTitle</th>
			<th>rental</th>
			<th>returnDate</th>
		</tr>
		<%
				for(HashMap<String, Object> f : list){
		%>
		<tr>
			<td><%=f.get("inventoryId")%></td>
			<td><%=f.get("filmTitle")%></td>
			<td><%=f.get("rental")%></td>
			<td><%=f.get("returnDate")%></td>
		</tr>
		<%
			}
		%>	
	</table>
	<a href="/sakila/d0327/inventory.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0327/inventory.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
	
	<%=currentPage %>
	<%
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0327/inventory.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0327/inventory.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>