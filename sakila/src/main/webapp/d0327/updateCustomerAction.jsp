<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null){ //로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
	
	String searchName = request.getParameter("searchName");
	if (searchName == null || searchName.equals("")) {
	    searchName = "";
	}
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	int customerId = Integer.parseInt(request.getParameter("customerId"));
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	
	String sql = "UPDATE customer SET active = 1 WHERE active = 0 and customer_id = ?"; 
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	stmt=conn.prepareStatement(sql);
	stmt.setInt(1, customerId);
	int row = stmt.executeUpdate();
	 System.out.println(row);
	
	response.sendRedirect("/sakila/d0327/searchCustomerList.jsp?inventoryId=" + inventoryId + "&searchName=" + searchName);
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