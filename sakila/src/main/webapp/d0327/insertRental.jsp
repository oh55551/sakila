<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId == null){ //로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
	//rental_id 
	//rental_date curdate()ornow() or sysdate...
	//inventory_id request
	//customer_id 직접입력
	//return_date null
	//staff_id session
	
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
    Integer customerId = null;
    if(request.getParameter("customerId") !=null){
    	//이름검색후 customerListByName갔다오면 customerId를 받아 온다. 
    	customerId = Integer.parseInt(request.getParameter("customerId")); //integer로 받는이유는 null쓰게
    }
	
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	String sql = "SELECT i.inventory_id AS inventoryId, i.film_id AS filmId, i.store_id AS storeId, f.title AS title "
	           + "FROM inventory i INNER JOIN film f "
	           + "ON i.film_id = f.film_id "
	           + "WHERE i.inventory_id = ?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	stmt=conn.prepareStatement(sql);
	stmt.setInt(1,inventoryId);
	System.out.println(stmt);
	rs=stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>Insert Rental Inventory</h1>
	<%
		if(rs.next()){
	%>
		<form action="/sakila/d0327/searchCustomerList.jsp" method="post">
			<input type="hidden" name="inventoryId" value="<%=inventoryId%>">
			<input type="text" name="searchName">
			<button type="submit"> 이름으로 customerId검색 </button> <!-- 검색결과페이지로이동 // insertRental-> 이름검색 -> 
																						customrListByName.jsp ->(inventoryId값) insertRental.jsp -->
		</form>
	<form action="/sakila/d0327/insertRentalAction.jsp" method="post"readonly>
		<table border="1">
			<tr>
				<td>customerId</td>
				<td>
					<input type="text" name="customerId" value="<%=customerId%>"readonly>
				</td>
			</tr>
			<tr>
				<td>inventoryId</td>
				<td><input type="text" name="inventoryId" value="<%=inventoryId%>"readonly></td>
			</tr>
			<tr>
				<td>filmId</td>
				<td>
					<input type="text" name="filmId" value="<%=rs.getInt("filmId") %>"readonly> /
					<input type="text" name="title" value="<%=rs.getString("title") %>"readonly>
				</td>
			</tr>
			<tr>
				<td>storeId</td>
				<td><input type="text" name="storeId" value="<%=rs.getInt("storeId") %> " readonly></td>
			</tr>
			<tr>
				<td>staffId</td>
				<td>
				<input type="text" name="customerId" value="<%=staffId %>">
				</td>
			</tr>
		</table>
		<button type="submit"> 대여하기 </button>
		</form>
	<% 
		}
	%>
	
	
</body>
</html>