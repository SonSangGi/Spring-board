<%--
  Created by IntelliJ IDEA.
  User: sanggi-son
  Date: 2019-08-27
  Time: 10:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>Title</title>

	<!-- Core CSS - Include with every page -->
	<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
	<link href="/resources/font-awesome/css/font-awesome.css" rel="stylesheet">

	<!-- Page-Level Plugin CSS - Tables -->
	<link href="/resources/css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">

	<!-- SB Admin CSS - Include with every page -->
	<link href="/resources/css/sb-admin.css" rel="stylesheet">

	<script src="http://code.jquery.com/jquery-1.11.1.min.js" type="text/javascript"></script>
</head>
<body>
<div class="container">
	<div class="row">
		<div class="col-md-4 col-md-offset-4">
			<div class="login-panel panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Please Sign In</h3>
				</div>
				<div class="panel-body">
					<h1>${error}</h1>
					<h2>${logout}</h2>

					<form action="/login" method="post">
						<fieldset>
							<div class="form-group">
								<input type="text" name="username" placeholder="userid" autofocus class="form-control">
							</div>
							<div class="form-group">
								<input type="password" name="password" placeholder="Password" class="form-control"
								       value="">
							</div>
							<div class="form-group">
								<label>
									<input type="checkbox" name="remember-me"> Remember Me
								</label>
							</div>
							<div>
								<a href="" class="btn btn-lg btn-success btn-block">Login</a>
							</div>
						</fieldset>
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- Core Scripts - Include with every page -->
<script src="/resources/js/bootstrap.min.js"></script>
<script src="/resources/js/plugins/metisMenu/jquery.metisMenu.js"></script>

<!-- Page-Level Plugin Scripts - Tables -->
<script src="/resources/js/plugins/dataTables/jquery.dataTables.js"></script>
<script src="/resources/js/plugins/dataTables/dataTables.bootstrap.js"></script>

<!-- SB Admin Scripts - Include with every page -->
<script src="/resources/js/sb-admin.js"></script>

<script>
	$(".btn-success").on("click",function (e) {
		e.preventDefault();

		$('form').submit();
	})
</script>
</body>
</html>
