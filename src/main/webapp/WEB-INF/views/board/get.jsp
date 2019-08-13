<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>register</title>
</head>
<body>
<%@include file="../include/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">게시글</div>
			<div class="panel-body">
					<div class="form-group">
						<label>번호</label>
						<input  name="title" class="form-control" value="${board.bno}" readonly="readonly">
					</div>
					<div class="form-group">
						<label>제목</label>
						<input name="title" class="form-control" value="${board.title}" readonly="readonly">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea name="content" class="form-control" readonly="readonly">${board.content}</textarea>
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input type="text" name="writer" class="form-control" readonly="readonly" value="${board.writer}">
					</div>
					<button data-oper="modify" class="btn btn-default">수정</button>
					<button data-oper="list" class="btn btn-info pull-right">목록</button>

				<form id="operForm" action="/board/list" method="get">
					<input type="hidden" id="bno" name="bno" value="${board.bno}">
					<input type="hidden" name="pageNum" value="${cri.pageNum}">
					<input type="hidden" name="amount" value="${cri.amount}">
					<input type="hidden" name="keyword" value="${cri.keyword}">
					<input type="hidden" name="type" value="${cri.type}">
				</form>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글 작성</button>
			</div>
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno="12">
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong>
								<small class="pull-right text-muted">2019----d312</small>
							</div>
							<p>댓글</p>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>

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
				<div class="form-group">
					<label for="">댓글</label>
					<input type="text" class="form-control" name="reply" value="new Reply!">
				</div>
				<div class="form-group">
					<label for="">작성자</label>
					<input type="text" class="form-control" name="replyer" value="replyer">
				</div>
				<div class="form-group">
					<label for="">작성일</label>
					<input type="text" class="form-control" name="replyDate" value="replyDate">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="modalModBtn">수정</button>
				<button type="button" class="btn btn-default" id="modalRemoveBtn">삭제</button>
				<button type="button" class="btn btn-success" id="modalRegisterBtn">등록</button>
				<button type="button" class="btn btn-default" id="modalCloseBtn">닫기</button>
			</div>
		</div>

	</div>
</div>
<%@include file="../include/footer.jsp"%>

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
	$(function () {
		var bnoValue = '${board.bno}';
		var replyUL = $(".chat");
		
		showList(1);
		
		function showList(page) {

			replyService.getList({bno:bnoValue, page:page || 1},function (list) {

				var str = "";
				if(list == null || list.length == 0) {
					replyUL.html("");
					return;
				}
				for (var i = 0 ; i < list.length; i++) {
					str += '<li class="left clearfix" data-rno="'+list[i].rno+'">';
					str += '<div><div class="headers">';
					str += '<strong class="primary-font">'+list[i].replyer+'</strong>'
					str += '<small class="pull-right text-muted">'+replyService.displayTime(list[i].replyDate)+'</small></div>';
					str += '<p>'+ list[i].reply +'<p></div></li>';
					console.log(list[i].replyDate)
				}
				replyUL.html(str);
			})
		}
		// end showList

		var modal = $(".modal");
		var modalInputReplyer = $("input[name='replyer']");
		var modalInputReply = $("input[name='reply']");
		var modalInputReplyDate = $("input[name='replyDate']");

		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");

		$("#addReplyBtn").on("click",function (e) {

			modal.find("input").val("");
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();

			modalRegisterBtn.show();

			$('.modal').modal('show');
		});

		modalRegisterBtn.on("click",function (e) {
			console.log("reply insert.........")

			var reply = {
				reply : modalInputReply.val(),
				replyer : modalInputReplyer.val(),
				bno : bnoValue
			};
			replyService.add(reply,function (result) {
				alert(result);

				modal.find("input").val("");
				modal.modal("hide");

				showList(1);
			});
		});

		modalRemoveBtn.on("click",function (e) {
			var rno = $(".modal").data("rno");

			replyService.remover(rno, function (result) {

				alert(result);
				modal.modal("hide");
				showList(1);
			});
		});

		modalModBtn.on("click",function (e) {
			var reply = {
				reply : modalInputReply.val(),
				rno : modal.data("rno")
			};
			replyService.update(reply,function (result) {
				alert(result);

				modal.modal("hide");
				modal.find("input").val("");
				showList(1);
			});
		});

		$(".chat").on("click","li",function (e) {
			var rno = $(this).data("rno");
			replyService.getRep(rno, function (reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyerDate)).attr("readonly","readonly");
				modal.data("rno", reply.rno);

				modal.find("button[id != modalCloseBtn]").hide();
				modalModBtn.show();
				modalRemoveBtn.show();

				$(".modal").modal("show");
			});
		});

		
	});
</script>

<script>
	$(function () {

		var operForm = $("#operForm");

		$("button[data-oper='modify']").on("click",function (e) {
			operForm.attr("action", "/board/modify").submit();

		});

		$("button[data-oper='list']").on("click",function (e) {

			operForm.find("#bno").remove();
			operForm.attr("action","/board/list").submit();

		})
	})
</script>

</body>
</html>
