<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<title>Start Bootstrap - SB Admin Version 2.0 Demo</title>



</head>

<body>
	<%@include file="../include/header.jsp"%>

		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Tables</h1>
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- /.row -->
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-heading"> 게시판
						<button id="regBtn" type="button" class="btn btn-xs btn-primary pull-right">글쓰기</button>
					</div>
					<!-- /.panel-heading -->
					<div class="panel-body">
							<table class="table table-striped table-bordered table-hover"s>
								<thead>
								<tr>
									<th>#번호</th>
									<th>제목</th>
									<th>작성자</th>
									<th>작성일</th>
									<th>수정일</th>
								</tr>
								</thead>
								<tbody>
									<c:forEach items="${list}" var="board">
										<tr>
											<td>${board.bno}</td>
											<td><a href="${board.bno}" class="move">${board.title}</a></td>
											<td>${board.writer}</td>
											<td><fmt:formatDate value="${board.regdate}" pattern="YYYY-MM-dd"/></td>
											<td><fmt:formatDate value="${board.updateDate}" pattern="YYYY-MM-dd"/></td>
										</tr>
									</c:forEach>
									<c:if test="${empty list}">
										<h2>게시물이 존재하지 않습니다.</h2>
									</c:if>
								</tbody>
							</table>

						<div class="row">
							<div class="col-lg-12">

								<form action="/board/list" id="actionForm" class="form-group" method="get" style="text-align: center;">
									<select name="type" style="width:8%;display: inline-block;">
										<option value="TCW" ${pageMaker.cri.type == 'TCW' ? 'selected' : ''}>모두</option>
										<option value="T" ${pageMaker.cri.type == 'T' ? 'selected' : ''}>제목</option>
										<option value="C" ${pageMaker.cri.type == 'C' ? 'selected' : ''}>내용</option>
										<option value="W" ${pageMaker.cri.type == 'W' ? 'selected' : ''}>작성자</option>
										<option value="TC" ${pageMaker.cri.type == 'TC' ? 'selected' : ''}>제목,내용</option>
										<option value="TW" ${pageMaker.cri.type == 'TW' ? 'selected' : ''}>제목,작성자</option>
									</select>
									<input type="text" name="keyword" value="${pageMaker.cri.keyword}" class="form-control" style="display: inline-block;width: 40%;">
									<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
									<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
									<button class="btn btn-primary">검색</button>
								</form>
							</div>
						</div>

						<div class="row">
							<div class="text-center">
								<ul class="pagination">

									<c:if test="${pageMaker.prev}">
										<li class="paginate_button previous">
											<a href="${pageMaker.startPage - 1}">prev</a>
										</li>
									</c:if>

									<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
										<li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : ''}">
											<a href="${num}">${num}</a>
										</li>
									</c:forEach>

									<c:if test="${pageMaker.next}">
										<li class="paginate_button">
											<a href="${pageMaker.endPage + 1}">next</a>
										</li>
									</c:if>
								</ul>
							</div>
						</div>

						<!-- /.table-responsive -->
					</div>
					<!-- /.panel-body -->
				</div>
				<!-- /.panel -->
			</div>
			<!-- /.col-lg-12 -->
		</div>
		<!-- /.row -->

	<!-- Modal -->
	<div id="myModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Modal Header</h4>
				</div>
				<div class="modal-body">
					<p>처리가 완료되었습니다.</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>



		<%@include file="../include/footer.jsp"%>

	<script>
		$(function () {
			console.log('${cri.type}');
			var result = '${result}';
			checkModal(result);

			history.replaceState({},null,null);

			function checkModal(reult) {
				if (result === '' || history.state ) {
					return;
				}
				if(parseInt(result) > 0) {
					$('.modal-body').html("게시글 " + parseInt(result) + "번이 등록되었습니다.");
				}
				$('#myModal').modal('show');
			}


			$("#regBtn").on("click",function () {
				self.location = "/board/register"
			})

			var actionForm = $("#actionForm");

			$(".paginate_button a").on("click",function (e) {
				e.preventDefault();

				actionForm.find("input[name='pageNum']").val($(this).attr("href"));

				actionForm.submit();
			})

			$("#actionForm button").on("click", function (e) {
				e.preventDefault();

				actionForm.find("input[name='pageNum']").val("1");

				actionForm.submit();
			})

			$('.move').on("click",function (e) {
				e.preventDefault();
				actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
				actionForm.attr("action","/board/get");
				actionForm.submit();
			})
		})
	</script>

<script>

</script>
</body>

</html>
