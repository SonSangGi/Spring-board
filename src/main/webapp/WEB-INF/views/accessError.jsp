<%--
  Created by IntelliJ IDEA.
  User: sanggi-son
  Date: 2019-08-27
  Time: 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
	<title>Title</title>
</head>
<body>
<h1>Access Denied Page</h1>

<h2>${SPRING_SECURITY_403_EXCEPTION.getMessage()}</h2>

<h2>${msg}</h2>
</body>
</html>
