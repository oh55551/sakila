<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId == null){ // 로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
%>

<div>
	<a href="/sakila/index.jsp">[홈화면으로]</a><br>
	<%=staffId%>님 반갑습니다.
	<a href="/sakila/logout.jsp">[로그아웃]</a>
</div>
<hr>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Rental List</title>
</head>
<body>
<%
	String searchTitle = request.getParameter("searchTitle");
	if(searchTitle == null){
		searchTitle = "";
	}

	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	int rowPerPage = 10;
	int startIdx = (currentPage - 1) * rowPerPage;

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");

	String sql = 
		"SELECT r.rental_id, f.title, CONCAT(c.first_name, ' ', c.last_name) AS customerName, " +
		"r.rental_date, r.return_date, CONCAT(s.first_name, ' ', s.last_name) AS staffName " +
		"FROM rental r " +
		"INNER JOIN inventory i ON r.inventory_id = i.inventory_id " +
		"INNER JOIN film f ON i.film_id = f.film_id " +
		"INNER JOIN customer c ON r.customer_id = c.customer_id " +
		"INNER JOIN staff s ON r.staff_id = s.staff_id ";

	String sql2 = "SELECT COUNT(*) AS cnt FROM rental r INNER JOIN inventory i ON r.inventory_id = i.inventory_id INNER JOIN film f ON i.film_id = f.film_id";

	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	ResultSet rs = null;
	ResultSet rs2 = null;

	if(!searchTitle.equals("")){
		sql += "WHERE f.title LIKE ? ";
		sql2 += " WHERE f.title LIKE ? ";
	}

	sql += "ORDER BY r.rental_date DESC LIMIT ?, ?";

	if(!searchTitle.equals("")){
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + searchTitle + "%");
		stmt.setInt(2, startIdx);
		stmt.setInt(3, rowPerPage);

		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchTitle + "%");
	} else {
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startIdx);
		stmt.setInt(2, rowPerPage);

		stmt2 = conn.prepareStatement(sql2);
	}

	rs = stmt.executeQuery();
	rs2 = stmt2.executeQuery();
	rs2.next();

	int totalIdx = rs2.getInt("cnt");
	int lastPage = totalIdx / rowPerPage;
	if(totalIdx % rowPerPage != 0){
		lastPage++;
	}

	int pageGroup = (currentPage - 1) / 10;
	int startPage = pageGroup * 10 + 1;
	int endPage = startPage + 9;
	if(endPage > lastPage){
		endPage = lastPage;
	}

	ArrayList<HashMap<String, Object>> rentalList = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> map = new HashMap<>();
		map.put("rentalId", rs.getInt("rental_id"));
		map.put("title", rs.getString("title"));
		map.put("customerName", rs.getString("customerName"));
		map.put("rentalDate", rs.getString("rental_date"));
		map.put("returnDate", rs.getString("return_date"));
		map.put("staffName", rs.getString("staffName"));
		rentalList.add(map);
	}

	stmt.close();
	stmt2.close();
	conn.close();
%>

<h2>Rental List</h2>
<form action="/sakila/rentalList.jsp">
	<input type="text" name="searchTitle" value="<%=searchTitle%>">
	<button type="submit">검색</button>
</form>

<table border="1">
	<tr>
		<th>Rental ID</th>
		<th>Film Title</th>
		<th>Customer Name</th>
		<th>Rental Date</th>
		<th>Return Date</th>
		<th>Staff Name</th>
	</tr>
	<%
		for(HashMap<String, Object> r : rentalList){
	%>
	<tr>
		<td><%=r.get("rentalId")%></td>
		<td><%=r.get("title")%></td>
		<td><%=r.get("customerName")%></td>
		<td><%=r.get("rentalDate")%></td>
		<td><%=r.get("returnDate") != null ? r.get("returnDate") : "미반납"%></td>
		<td><%=r.get("staffName")%></td>
	</tr>
	<%
		}
	%>
</table>

<%-- 페이지네이션 --%>
<a href="/sakila/rentalList.jsp?currentPage=1">[첫페이지]</a>
<%
	if(currentPage > 1){
%>
	<a href="/sakila/rentalList.jsp?currentPage=<%=currentPage - 1%>">이전</a>
<%
	}
	if(startPage > 10){
%>
	<a href="/sakila/rentalList.jsp?searchTitle=<%=searchTitle%>&currentPage=<%=startPage - 10%>">[이전]</a>
<%
	}
	for(int i = startPage; i <= endPage; i++){
%>
	<a href="/sakila/rentalList.jsp?searchTitle=<%=searchTitle%>&currentPage=<%=i%>">[<%=i%>]</a>
<%
	}
	if(endPage < lastPage){
%>
	<a href="/sakila/rentalList.jsp?searchTitle=<%=searchTitle%>&currentPage=<%=startPage + 10%>">[다음]</a>
<%
	}
	if(currentPage < lastPage){
%>
	<a href="/sakila/rentalList.jsp?currentPage=<%=currentPage + 1%>">다음</a>
<%
	}
%>
<a href="/sakila/rentalList.jsp?currentPage=<%=lastPage%>">[끝페이지]</a>

</body>
</html>