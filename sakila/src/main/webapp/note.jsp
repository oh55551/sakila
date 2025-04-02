<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//SQL
	//inner join은 교집합
	//left join은 왼쪽꺼에 있으면 무조건나옴(오른쪽꺼엔 null)
	//group by A,B : A로 먼저 묶고, 그 안에서 B로 또 묶는다
	//order by A,B : A -> B 순서로 정렬
	//GROUP_CONCAT() : mysql에서만 쓸 수 있는건데, group by에 있는것중에서 모아주는함수
	//distinct : 중복을 제거하고 유일한 값만 가져오는 것
	//JOIN B ON A.기준컬럼 = B.기준컬럼
	//count(*) : 행의 개수를 셈 / 조건이 없으면 전체행의 개수(null포함) /group by 랑 같이쓰면 그룹별 개수
	//where : 어떤 행(row)을 가져올지 조건을 정하는 부분
	//like : 문자열 안에 특정 패턴이 있는지 찾을 때 
	//in : 이 값들 중 하나라도 해당되면 통과!
		//SELECT * FROM users WHERE name IN ('철수', '민수'); -> users 테이블에서 이름이 철수나 민수인 사람들의 정보를 모두 보여줘
	//🔹 sql → 실제로 데이터를 가져오는 쿼리 (LIMIT ?, ? 써서 페이징)
	//🔹 sql2 (count쓴 쿼리) → 전체 데이터 개수를 COUNT로 미리 세는 쿼리
	
	//SELECT 가져와(ResultSet rs = stmt.executeQuery(sql); 하고 rs.next() 써서 한 줄씩 읽어옴) 
	//INSERT 넣어 / UPDATE 고쳐 / DELETE 없애 (이 구문쓰면 int row = stmt.executeUpdate(); 이걸로)
	
	//rs.next(); 한 번만	한 줄만 출력됨 (true/false)
	//while(rs.next()) { ... }	모든 줄 반복 출력
%>