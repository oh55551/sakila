<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId == null){ //로그아웃 상태라면 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/loginForm.jsp");	
		return;
	}
%>
	<div><a href="/sakila/d0327/insertRental.jsp?inventoryId=1">대여하기</a></div>

	<div>
		<a href="/sakila/index.jsp">[홈화면으로]</a>
	<br>
		<%=staffId%>님 반갑습니다.
		<a href="/sakila/logout.jsp">[로그아웃]</a>
	</div>
	<hr>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<% 
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

	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn=null;
	PreparedStatement stmt = null;
	ResultSet rs=null;
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila","root","java1234");
	PreparedStatement stmt2 = null;
	ResultSet rs2=null;	

	String sql =  "SELECT t1.inventory_id AS id, t1.title AS title, t2.ISrental AS rental, t2.return_date AS returndate "
		    + "FROM (SELECT i.inventory_id, f.title "
		    + "FROM inventory i INNER JOIN film f "
		    + "ON i.film_id = f.film_id) t1 "
		    + "LEFT JOIN (SELECT inventory_id, rental_date, return_date, " 
		    + "CASE WHEN return_date IS NULL THEN '대여불가' "
		    + "ELSE '대여가능' END AS ISrental "
		    + "FROM rental WHERE (inventory_id, rental_date) IN ("
		    + "SELECT inventory_id, MAX(rental_date) FROM rental GROUP BY inventory_id) "
		    + ") t2 ON t1.inventory_id = t2.inventory_id ";
	String sql2="select count(*) cnt "
		    + "FROM (SELECT i.inventory_id, f.title "
		    + "FROM inventory i INNER JOIN film f "
		    + "ON i.film_id = f.film_id) t1 "
		    + "LEFT JOIN (SELECT inventory_id, rental_date, return_date, " 
		    + "CASE WHEN return_date IS NULL THEN '대여불가' "
		    + "ELSE '대여가능' END AS ISrental "
		    + "FROM rental WHERE (inventory_id, rental_date) IN ("
		    + "SELECT inventory_id, MAX(rental_date) FROM rental GROUP BY inventory_id) "
		    + ") t2 ON t1.inventory_id = t2.inventory_id ";

	if(searchTitle.equals("")){ // 검색어 입력하지 않았을 때
 		sql += " limit ?,?";
 		stmt = conn.prepareStatement(sql);
 		stmt2 = conn.prepareStatement(sql2);
 		stmt.setInt(1,startIdx);
 		stmt.setInt(2,rowPerPage);
 	}else{ // 검색어 입력했을 때
 		sql += " where title like ? limit ?,?";
 		sql2 += " where title like ?";
 		stmt = conn.prepareStatement(sql);
 		stmt2 = conn.prepareStatement(sql2);
 		stmt.setString(1,"%"+searchTitle+"%");
 		stmt.setInt(2,startIdx);
 		stmt.setInt(3,rowPerPage);
 		stmt2.setString(1,"%"+searchTitle+"%");
 	}
	
	rs=stmt.executeQuery();
	rs2 = stmt2.executeQuery();
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
	<form action="/sakila/d0327/inventory.jsp">
 		<input type="text" name="searchTitle">
 		<button type="submit">검색</button>
 	</form>
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
			<td>
				<%
					String rentalStatus = (String)f.get("rental");
					String inventoryId = (String)f.get("inventoryId");
					if ("대여가능".equals(rentalStatus)) {
				%>
						<a href="/sakila/d0327/insertRental.jsp?inventoryId=<%=inventoryId%>">대여하기</a>
				<%
					} else {
				%>
						<%=rentalStatus != null ? rentalStatus : "정보없음"%>
				<%
					}
				%>
			</td>
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
<%
 		if(startPage>10){
 	%>
 			<a href="/sakila/d0327/inventory.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=startPage-10 %>">[이전]</a>
 	<% 
 		}
 	%>
 	<%
 		for(int i=startPage;i<=endPage;i++){
 	%>
 			<a href="/sakila/d0327/inventory.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=i%>">[<%=i%>]</a>
 	<% 
 		}
 	%>
 	<%
 		if(endPage>lastPage){
 	%>
 			<a href="/sakila/d0327/inventory.jsp?searchTitle=<%=searchTitle %>&currentPage=<%=startPage+10 %>">[다음]</a>
	<%
 		}
		if(currentPage<lastPage){
	%> 	
		<a href="/sakila/d0327/inventory.jsp?currentPage=<%=currentPage+1 %>">다음</a>
	<%
		}
	%>
	<a href="/sakila/d0327/inventory.jsp?currentPage=<%=lastPage%>">[끝페이지로]</a>
</body>
</html>