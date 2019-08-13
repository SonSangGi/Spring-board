<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>register</title>
</head>
<body>
<%@include file="../include/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 수정</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">게시글 수정</div>
			<div class="panel-body">

				<form role="form" action="/board/modify" method="post">
					<input type="hidden" value="${board.bno}" name="bno">
					<input type="hidden" value="${cri.pageNum}" name="pageNum">
					<input type="hidden" value="${cri.amount}" name="amount">
					<input type="hidden" value="${cri.keyword}" name="keyword">
					<input type="hidden" value="${cri.type}" name="type">
					<div class="form-group">
						<label>제목</label>
						<input type="text" name="title" class="form-control" value="${board.title}">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea name="content" class="form-control">${board.content}</textarea>
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input type="text" name="writer" class="form-control" value="${board.writer}" readonly="readonly">
					</div>
					<button type="submit" class="btn btn-primary">수정</button>
					<button type="submit" data-oper="remove" class="btn btn-danger">삭제</button>
					<button type="submit" data-oper="list" class="btn btn-default pull-right">목록</button>
				</form>
			</div>
		</div>
	</div>
</div>

<script>
	$(function () {
		var formObj = $("form");
		$("button").on("click",function (e) {

			e.preventDefault();

			var operation = $(this).data("oper");

			console.log(operation);

			if(operation === 'remove') {
				formObj.attr("action","/board/remove");
			} else if (operation === 'list') {
				formObj.attr("action","/board/list").attr("method","get");
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword]").clone();
				var typeTag = $("input[name='type']").clone();

				formObj.empty();
				formObj.append(pageNumTag)
					.append(amountTag)
					.append(keywordTag)
					.append(typeTag);
			}
			formObj.submit();
		})
	})
</script>

<%@include file="../include/footer.jsp"%>
</body>
</html>
