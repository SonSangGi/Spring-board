<%--
  Created by IntelliJ IDEA.
  User: sanggi-son
  Date: 2019-08-27
  Time: 10:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>Title</title>
</head>
<body>

<form action="/customLogout" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	<button>로그아웃</button>
</form>


</body>
</html>
