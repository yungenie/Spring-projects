<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Cooking</title>
<link rel="shortcut icon" type="imge/x-icon" href="/project/img/index/메인아이콘.PNG">
<script>

</script>
<style>
form{
	width:200px;
	margin:0px auto;
	padding:30px;
	background:#f4f4f7;
	border-top-left-radius:100px;
	border-bottom-right-radius:100px;
	marign:0px auto;
}
table{
	width:100px;
	height:100px;
	background:#f4f4f7;
	border-top-left-radius:80px;
	border-bottom-right-radius:80px;
	marign:0px auto;
}
#telid{
	height: 50px;
	width: 200px;
	font-size: 15px;
	border-radius: 10px;
}
#checktel{
	border-color:#269463;
	background: white;	
	height: 35px;
	width:200px;
	font-size: 17px;
	border-radius: 10px;
}
</style>
</head>
<body>
<form name="telcheck" action="telCheck_ok.jsp">
<table>
<tr>
	<td><input type="number" name="user_tel" placeholder="Tel" id="telid"></td>
</tr>
<tr>
	<td><input type="submit" value="중복확인" id="checktel"></td>
</tr>
</table>
</form>
</body>
</html>








