<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Core CSS - Include with every page -->
<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link href="/resources/font-awesome/css/font-awesome.css" rel="stylesheet">

<!-- Page-Level Plugin CSS - Tables -->
<link href="/resources/css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">

<!-- SB Admin CSS - Include with every page -->
<link href="/resources/css/sb-admin.css" rel="stylesheet">

<script src="http://code.jquery.com/jquery-1.11.1.min.js" type="text/javascript"></script>

<div class="wrapper">
<nav class="navbar navbar-default navbar-fixed-top" role="navigation" style="margin-bottom: 0">
	<div class="navbar-header">
		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".sidebar-collapse">
			<span class="sr-only">Toggle navigation</span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		<a class="navbar-brand" href="/">SB Admin v2.0</a>
	</div>
	<!-- /.navbar-header -->

	<ul class="nav navbar-top-links navbar-right">

		<!-- /.dropdown -->
		<li class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="#">
				<i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
			</a>
			<ul class="dropdown-menu dropdown-user">
				<sec:authorize access="isAuthenticated()">
					<li><form action="/customLogout" method="post">
							<button style="border: 0px; background-color: white;">
								<i class="fa fa-sign-out fa-fw"></i> Logout
							</button>
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						</form>
					</li>
				</sec:authorize>
				<sec:authorize access="isAnonymous()">
					<li><a href="/customLogin"><i class="fa fa-sign-in fa-fw"></i> Login</a>
					</li>
				</sec:authorize>
			</ul>
			<!-- /.dropdown-user -->
		</li>
		<!-- /.dropdown -->
	</ul>
	<!-- /.navbar-top-links -->

</nav>
<div id="page-wrapper">
