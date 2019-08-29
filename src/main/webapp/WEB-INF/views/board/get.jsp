<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<title>register</title>
	<style>
		.uploadResult {
			width: 100%;
			background-color: grey;
		}

		.uploadResult ul {
			display: flex;
			flex-flow: row;
			justify-content: center;
			align-items: center;
		}

		.uploadResult ul li {
			list-style: none;
			padding: 10px;
			align-content: center;
			text-align: center;
		}

		.uploadResult ul li img {
			width: 100px;
		}

		.uploadResult ul li span {
			color: white;
		}

		.bigPictureWrapper {
			position: fixed;
			display: none;
			justify-content: center;
			align-items: center;
			top: 0%;
			width: 100%;
			height: 100%;
			background-color: grey;
			z-index: 100;
			background: rgba(255, 255, 255, 0.5);
		}

		.bigPicture {
			position: relative;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.bigPicture img {
			width: 600px;
		}
	</style>
</head>
<body>
<%@include file="../include/header.jsp" %>

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
					<input name="title" class="form-control" value="${board.bno}" readonly="readonly">
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
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper="modify" class="btn btn-default">수정</button>
					</c:if>
				</sec:authorize>
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
				Files
			</div>
			<div class="panel-body">

				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글 작성</button>
				</sec:authorize>
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
			<div class="panel-footer text-center">

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
					<label>댓글</label>
					<input type="text" class="form-control" name="reply" value="new Reply!">
				</div>
				<div class="form-group">
					<label>작성자</label>
					<input type="text" class="form-control" name="replyer" value="replyer" readonly>
				</div>
				<div class="form-group">
					<label>작성일</label>
					<input type="text" class="form-control" name="replyDate" value="replyDate">
				</div>
			</div>
			<div class="modal-footer">
				<sec:authorize access="isAuthenticated()">

				<button type="button" class="btn btn-primary" id="modalModBtn">수정</button>
				<button type="button" class="btn btn-default" id="modalRemoveBtn">삭제</button>
				<button type="button" class="btn btn-success" id="modalRegisterBtn">등록</button>
				</sec:authorize>
				<button type="button" class="btn btn-default" id="modalCloseBtn" data-dismiss="modal">닫기</button>
			</div>
		</div>

	</div>
</div>
<%@include file="../include/footer.jsp" %>

<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
	$(function () {
		var bnoValue = '${board.bno}';
		var replyUL = $(".chat");

		showList(1);

		//최초 파일 리스트 화면 처리
		$.getJSON("/board/getAttachList", {bno: bnoValue}, function (arr) {
			console.log(arr);

			var str = "";

			$(arr).each(function (i, attach) {
				if (attach.fileType) {
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "'";
					str += " data-type='" + attach.fileType + "' data-filename='" + attach.fileName + "' >";
					str += "<div> <img src='/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				} else {
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "'";
					str += " data-type='" + attach.fileType + "' data-filename='" + attach.fileName + "' >";
					str += "<span>" + attach.fileName + "</span>";
					str += "<div> <img src='/resources/img/attach.png'>";
					str += "</div>";
					str += "</li>";
				}
				$(".uploadResult ul").html(str);
			});
		});

		// 파일 클릭 이벤트 처리(이미지, 파일)
		$(".uploadResult").on("click", "li", function (e) {

			console.log("view image");

			var liObj = $(this);

			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));

			if (liObj.data("type")) {
				showImage(path.replace(new RegExp(/\\/g), "/"));
			} else {
				self.location = "/download?fileName=" + path;
			}
		});

		// 이미지 뷰어
		function showImage(fileCallPath) {

			$(".bigPictureWrapper").css("display", "flex").show();

			$(".bigPicture")
				.html("<img src='/display?fileName=" + fileCallPath + "'>")
				.animate({width: '100%', height: '100%'}, 500);
		}

		$(".bigPictureWrapper").on("click", function (e) {
			$(".bigPicture").animate({width: "0%", height: "0%"}, 500);
			setTimeout(function () {
				$(".bigPictureWrapper").hide();
			}, 500);
		});

		// 댓글 리스트 화면처리

		function showList(page) {

			replyService.getList({bno: bnoValue, page: page || 1}, function (replyCnt, list) {

				if (page == -1) {
					pageNum = Math.ceil(replyCnt / 10.0);
					showList(pageNum);
					return;
				}
				var str = "";

				if (list == null || list.length == 0) {
					replyUL.html("");
					return;
				}

				for (var i = 0; i < list.length; i++) {
					str += '<li class="left clearfix" data-rno="' + list[i].rno + '">';
					str += '<div><div class="headers">';
					str += '<strong class="primary-font">' + list[i].replyer + '</strong>'
					str += '<small class="pull-right text-muted">' + replyService.displayTime(list[i].replyDate) + '</small></div>';
					str += '<p>' + list[i].reply + '<p></div></li>';
				}
				replyUL.html(str);

				showReplyPage(replyCnt);
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

		var replyer = null;

		<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username"/>'
		</sec:authorize>

		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";

		// ajax 요청 헤더 설정
		$(document).ajaxSend(function (e, xhr, options) {
			xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
		})

		// 댓글 모달 표시
		$("#addReplyBtn").on("click", function (e) {

			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();

			modalRegisterBtn.show();

			$('.modal').modal('show');
		});

		// 댓글 작성 이벤트
		modalRegisterBtn.on("click", function (e) {
			console.log("reply insert.........")

			var reply = {
				reply: modalInputReply.val(),
				replyer: modalInputReplyer.val(),
				bno: bnoValue
			};
			replyService.add(reply, function (result) {

				modal.find("input").val("");
				modal.modal("hide");

				showList(-1);
			});
		});

		// 댓글 삭제 이벤트
		modalRemoveBtn.on("click", function (e) {
			var rno = $(".modal").data("rno")

			if(!replyer) {
				alert("로그인 후 삭제 가능합니다.");
				modal.modal("hide");
				return;
			}

			var originalReplyer = modalInputReplyer.val();

			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제 가능합니다.");
				modal.modal("hide");
				return;
			}

			replyService.remover(rno, originalReplyer, function (result) {

				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});

		// 댓글 수정 이벤트
		modalModBtn.on("click", function (e) {

			var originalReplyer = modalInputReplyer.val();

			var reply = {
				rno: modal.data("rno"),
				reply: modalInputReply.val(),
				replyer: originalReplyer
			};

			if(!reply) {
				alert("로그인 후 수정 가능합니다.");
				modal.modal("hide");
				return;
			}

			if(reply.replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정 가능합니다.");
				modal.modal("hide");
				return;
			}

			replyService.update(reply, function (result) {
				console.log(result);
				modal.modal("hide");
				modal.find("input").val("");
				showList(pageNum);
			});
		});


		// 댓글 클릭 시 정보표시 모달
		$(".chat").on("click", "li", function (e) {
			var rno = $(this).data("rno");
			replyService.getRep(rno, function (reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);

				modal.find("button[id != modalCloseBtn]").hide();
				modalModBtn.show();
				modalRemoveBtn.show();

				$(".modal").modal("show");
			});
		});


		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");

		<!-- 댓글 페이징 처리 -->
		function showReplyPage(replyCnt) {
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;

			var prev = startNum != 1;
			var next = false;

			if (endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt / 10.0);
			}

			if (endNum * 10 < replyCnt) {
				next = true;
			}
			var str = "<ul class='pagination pull-right'>";

			if (prev) {
				str += "<li class='paginate_button previous'><a class='page-link' href='" + (startNum - 1) + "'>prev</a><li>";
			}

			for (var i = startNum; i <= endNum; i++) {
				console.log("i:", i, "startNum:", startNum, "endNum:", endNum)
				var active = pageNum == i ? "active" : "";

				str += "<li class='pagination_button " + active + "'><a class='page-link' href='" + i + "'>" + i + "</a></li>";
			}

			if (next) {
				str += "<li class='paginate_button'><a class='page-link' href=" + (endNum + 1) + ">next</a></li>";
			}

			str += "</ul></div>";

			console.log(str);

			replyPageFooter.html(str);
		}

		replyPageFooter.on("click", "li a", function (e) {
			e.preventDefault();
			var targetPageNum = $(this).attr("href");

			pageNum = targetPageNum;

			showList(pageNum);
		})

	});
</script>

<script>
	$(function () {

		var operForm = $("#operForm");

		$("button[data-oper='modify']").on("click", function (e) {
			operForm.attr("action", "/board/modify").submit();

		});

		$("button[data-oper='list']").on("click", function (e) {

			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();

		});

	})
</script>

</body>
</html>
