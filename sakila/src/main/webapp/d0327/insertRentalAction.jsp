<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer customerId = null;
	if(request.getParameter("customerId") !=null){
    	customerId = Integer.parseInt(request.getParameter("customerId")); 
    }
	String searchName = request.getParameter("searchName");

	if(staffId == null){ //로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	ResultSet rs=null;
	 String sql = "INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, last_update) "
             + "VALUES (NOW(), ?, ?, ?, NOW())";
 	PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setInt(1, inventoryId);
    stmt.setInt(2, customerId);
    stmt.setInt(3, staffId);
	
    int row = stmt.executeUpdate();
    System.out.println(row);
	
    
    response.sendRedirect("/sakila/rentalList.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>

</body>
</html>