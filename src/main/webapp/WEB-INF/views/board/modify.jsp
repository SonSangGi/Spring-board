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
			background: rgba(255,255,255,0.5);
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

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				Files
			</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
</div>

<script>
	$(function () {
		var formObj = $("form");
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 1024 * 1024 * 1024 * 50;

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
		});

		var bnoValue = ${board.bno}
		//파일 리스트 출
		$.getJSON("/board/getAttachList",{bno:bnoValue},function (arr) {
			console.log(arr);

			var str = "";

			$(arr).each(function (i, attach) {
				var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_"+attach.uuid + "_" + attach.fileName);
				if(attach.fileType) {

					str += "<li data-path='" + attach.uploadPath+"' data-uuid='" + attach.uuid + "'";
					str += " data-type='"+attach.fileType + "' data-filename='" + attach.fileName + "' >";
					str += "<span>" + attach.fileName + "</span>";
					str += "<button type='button' data-file='"+fileCallPath+"\' data-type='image'";
					str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					str += "<div> <img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				} else {
					str += "<li data-path='" + attach.uploadPath+"' data-uuid='" + attach.uuid + "'";
					str += " data-type='"+attach.fileType + "' data-filename='" + attach.fileName + "' >";
					str += "<span>" + attach.fileName + "</span>";
					str += "<button type='button' data-file='"+fileCallPath+"\' data-type='image'";
					str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					str += "<div> <img src='/resources/img/attach.png'>";
					str += "</div>";
					str += "</li>";
				}
				$(".uploadResult ul").html(str);
			});
		});

		function showUploadResult(uploadResultArr) {
			if(!uploadResultArr || uploadResultArr.length == 0) {return;}

			var uploadUL = $(".uploadResult ul");
			var str = "";
			$(uploadResultArr).each(function (i, obj) {
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/"+obj.uuid+"_"+obj.fileName);
				if(!obj.image) {
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' ";
					str += "<span>";
					str += obj.fileName.substr(0,10) + "..."+ obj.fileName.substr(obj.fileName.lastIndexOf("."),obj.fileName.length);
					str += "</span>";
					str += "<button type='button' data-file='"+fileCallPath+"\' data-type='file'";
					str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					str += "<div> <img src='/resources/img/attach.png'>";
					str+= "</div></li>";
				} else {
					var originalPath = obj.uploadPath + "/" + obj.uuid + "_"+obj.fileName;
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' ";
					str += "data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>"
					str += "<span>" + obj.fileName + "</span>";
					str += "<button type='button' data-file='"+fileCallPath+"\' data-type='image'";
					str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str +=	"</div></li>";
				}
			})
			uploadUL.append(str);
		}

		$(".uploadResult").on("click","button",function (e) {

			console.log("delete file");

			if(confirm("remove this file?")) {

				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});

		function checkExtension(fileName, fileSize) {

			if(fileSize > maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}

			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 첨부할 수 없습니다.");
				return false;
			}
			return true;
		};

		$("input[type=file]").on("change",function (e) {
			var formData = new FormData();

			var inputFile = $("input[name='uploadFile']");

			var files = inputFile[0].files;

			for (var i = 0; i < files.length; i++) {
				if(!checkExtension(files[i].name,files[i].size)) {
					return false;
				}
				formData.append("uploadFile",files[i]);
				console.log("file : "+files[i].name);
				console.log("formData : " + formData);
			}
			// 파일 업로드 ajax 처리 시 꼭 processData, contentType을 false로 설정하자.
			$.ajax({
				url: '/uploadAjaxAction',
				data : formData,
				processData: false,
				contentType: false,
				type: 'post',
				dataType: 'json',
				success: function (result) {
					console.log(result);
					showUploadResult(result);
				}
			}); // ajax
		});



	})
</script>

<%@include file="../include/footer.jsp"%>
</body>
</html>
