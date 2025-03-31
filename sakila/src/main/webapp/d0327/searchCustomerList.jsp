<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	Integer inventoryId = null;
	if (request.getParameter("inventoryId") != null) {
	    inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	}

	String searchName = request.getParameter("searchName");
	if (searchName == null) {
	    searchName = "";
	}
	if(staffId == null){ //로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}

	String searchTitle = request.getParameter("searchTitle");
	if(request.getParameter("searchTitle") == null){
		searchTitle = "";
	}
	
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage= Integer.valueOf(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	int startIdx = (currentPage-1)*rowPerPage;

	
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	String sql = "SELECT customer_id as customerId, first_name as firstName, last_name as lastName, email, active from customer where concat(first_name, last_name) like ? LIMIT ?, ?";
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	stmt=conn.prepareStatement(sql);
	stmt.setString(1, "%"+ searchName +"%");
	stmt.setInt(2, startIdx);      
	stmt.setInt(3, rowPerPage);  
	System.out.println(stmt);
	rs=stmt.executeQuery();
	//from customer c where first_name like ? or last_name like ?
	
	PreparedStatement stmt2 = null;
	ResultSet rs2=null;
	String sql2 = "SELECT count(*) as cnt FROM customer WHERE concat(first_name, last_name) LIKE ?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, "%" + searchName + "%");
	rs2=stmt2.executeQuery();
	rs2.next();
	
	int totalIdx = rs2.getInt("cnt");
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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>customerList</h1>
	<table border="1">
		<tr>
			<td>customerId</td>
			<td>firstName</td>
			<td>lastName</td>
			<td>email</td>
			<td>active</td>
			<td>선택</td>
		</tr>
		<%
			while(rs.next()){
		%>
			<tr>
				<td><%=rs.getInt("customerId") %></td>
				<td><%=rs.getString("firstName") %></td>
				<td><%=rs.getString("lastName") %></td>
				<td><%=rs.getString("email") %></td>
				<td><%=rs.getInt("active") %></td>
				<td>
					<%
						if(rs.getInt("active") == 0) {
					%>	
							<a href='/sakila/d0327/updateCustomerAction.jsp?customerId=<%=rs.getInt("customerId")%>&inventoryId=<%=inventoryId%>'>
								휴면상태해지하기<!-- customer.active 0을 1로 변경 -->
							</a>	
					<%
						} else {
					%>
							<a href='/sakila/d0327/insertRental.jsp?customerId=<%=rs.getInt("customerId")%>&inventoryId=<%=inventoryId%>'>
								선택
							</a>
					<%		
						}
					%>
				</td>
			</tr>		
		<%		
			}
		%>
	</table>
	
	<a href="/sakila/d0327/searchCustomerList.jsp?currentPage=1">[첫페이지로]</a>
	<%
		if(currentPage>1){
	%>	<a href="/sakila/d0327/searchCustomerList.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
<%
 		if(startPage>10){
 	%>
 			<a href="/sakila/d0327/searchCustomerList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=startPage-10 %>">[이전]</a>
 	<% 
 		}
 	%>
 	<%
 		for(int i=startPage;i<=endPage;i++){
 	%>
 			<a href="/sakila/d0327/searchCustomerList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=i%>">[<%=i%>]</a>
 	<% 
 		}
 	%>
 	<%
 		if(endPage>lastPage){
 	%>
 			<a href="/sakila/d0327/searchCustomerList.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=startPage+10 %>">[다음]</a>
	<%
 		}
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0327/searchCustomerList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0327/searchCustomerList.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>