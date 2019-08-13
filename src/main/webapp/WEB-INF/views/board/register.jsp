<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>register</title>
</head>
<body>
<%@include file="../include/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 작성</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">게시글 작성</div>
			<div class="panel-body">

				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>제목</label>
						<input type="text" name="title" class="form-control">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea name="content" class="form-control"></textarea>
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input type="text" name="writer" class="form-control">
					</div>
					<button type="submit" class="btn btn-default">전송</button>
					<button type="reset" class="btn btn-danger pull-right">리셋</button>
				</form>
			</div>
		</div>
	</div>
</div>


<%@include file="../include/footer.jsp"%>
</body>
</html>
