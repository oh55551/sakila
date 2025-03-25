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
	//검색
	String searchWord = request.getParameter("searchWord");
		if(searchWord == null){
			searchWord = "";
		}
		
	int storeId = 0;
	if (request.getParameter("storeId") != null) {
		storeId = Integer.parseInt(request.getParameter("storeId"));
	}
	
	//페이징
	int currentPage=1;
	if(request.getParameter("currentPage")!=null){
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage=10;
	int startRow=(currentPage-1)*rowPerPage;
	
	System.out.println("searchWord: " + searchWord);
	System.out.println("startRow: " + startRow);
	System.out.println("rowPerPage: " + rowPerPage);
	//
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");

	String sql = "SELECT " +
            "r.rental_id AS rentalId, " +
            "f.title AS filmTitle, " +
            "r.inventory_id AS inventoryId, " +
            "CONCAT(c.first_name, ' ', c.last_name) AS customerId, " +  
            "r.rental_date AS rentalDate, " +
            "COALESCE(r.return_date, NOW()) AS returnDate " +
            "FROM rental r " +
            "INNER JOIN inventory i ON r.inventory_id = i.inventory_id " +
            "INNER JOIN film f ON i.film_id = f.film_id " +
            "INNER JOIN customer c ON r.customer_id = c.customer_id " +
            "WHERE f.title LIKE ? " +
            "ORDER BY r.rental_date DESC " +
            "LIMIT ?, ?";
	System.out.println("Executing SQL: " + sql);
	stmt=conn.prepareStatement(sql);
	
	stmt.setString(1, "%"+searchWord+"%");
	stmt.setInt(2, startRow);
	stmt.setInt(3, rowPerPage);
	rs=stmt.executeQuery();
	
	//count(*)
	ResultSet rs2=null;	
	PreparedStatement stmt2 = null;
	String sql2 = "SELECT " +
	        "count(*) CNT " +
	        "FROM rental r " +
	        "INNER JOIN inventory i ON r.inventory_id = i.inventory_id " +
	        "INNER JOIN film f ON i.film_id = f.film_id " +
	        "INNER JOIN customer c ON r.customer_id = c.customer_id " +
	        "WHERE f.title LIKE ?";
	stmt2=conn.prepareStatement(sql2);
	stmt2.setString(1, "%"+searchWord+"%");
	rs2 = stmt2.executeQuery();
	rs2.next();

	int totalCnt= rs2.getInt("CNT");
	int lastPage=totalCnt/rowPerPage;
	if(totalCnt%rowPerPage !=0){
		lastPage=lastPage+1;
	}
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> rental = new HashMap<String, Object>();
		rental.put("rentalId", rs.getString("rentalId"));
		rental.put("filmTitle", rs.getString("filmtitle"));
		rental.put("inventoryId", rs.getString("inventoryId"));
		rental.put("name", rs.getString("customerId"));
		rental.put("rentalDate", rs.getString("rentalDate"));
		rental.put("returnDate", rs.getString("returnDate"));
		
		list.add(rental);
	}
%>	
	<h1>Rental List</h1>
	<form action="/sakila/d0325/rentalList.jsp">
		Store :
		<select name="storeId">
			<option value="0">전체</option>
			<option value="1">1지점</option>
			<option value="2">2지점</option>
		</select> 
		<button type="submit">검색</button>
	</form>
	
	<table border="1">
		<tr>
			<th>rentalId</th>
			<th>filmTitle</th>			<!-- 영화이름으로 검색되게 -->
			<th>inventoryId</th>
			<th>name(customerId)</th>	<!-- name=first_name + last_name -->
										<!-- 클릭하면 상세정보 나오게 -->
			<th>rentalDate</th>			
			<th>returnDate</th>			
		</tr>
		<%
				for(HashMap<String, Object> r : list){
		%>
		<tr>
			<td><%=r.get("rentalId")%></td>
			<td><%=r.get("filmTitle")%></td>
			<td><%=r.get("inventoryId")%></td>
			<td><%=r.get("name")%></td>
			<td><%=r.get("rentalId")%></td>
			<td><%=r.get("returnDate")%></td>
		</tr>
		<%
			}
		%>	
		
	</table>
	<form action="/sakila/d0325/rentalList.jsp">
		filmTitle Search Word :
		<input type="text" name="searchWord" value="<%= searchWord %>">
		<button type="submit">검색</button>
	</form>
	
	
	<!-- 페이징 -->
	<a href="/sakila/d0325/rentalList.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
	
	<%=currentPage %>
	<%
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0325/rentalList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>