<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
	<title>register</title>

	<style>
		.uploadResult {
			background: lightgray;
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
		}

		.uploadResult ul li img {
			width: 20px;
		}

		.uploadResult il li a {
			color: black;
			text-decoration: none;
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
			background: rgba(43, 43, 43, 0.8);
		}

		.bigPicture{
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

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">File Attach</div>

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
	<div class="bigPicture">

	</div>
</div>

<script>
	$(function () {

		var formObj = $("form[role='form']");

		$("button[type=submit]").on("click",function (e) {
			e.preventDefault();

			console.log("submit clicked");

			var str = "";

			$(".uploadResult ul li").each(function (i,obj) {
				var jobj = $(obj);

				console.dir(jobj);

				str += "<input type='hidden' name='attachList["+i +"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i +"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i +"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i +"].fileType' value='"+jobj.data("type")+"'>";
			});

			formObj.append(str).submit();
		});

		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 1024 * 1024 * 1024 * 50;

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
		}

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

		function showUploadResult(uploadResultArr) {
			if(!uploadResultArr || uploadResultArr.length == 0) {return;}

			var uploadUL = $(".uploadResult ul");
			var str = "";
			$(uploadResultArr).each(function (i, obj) {
				if(!obj.image) {
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/"+obj.uuid+"_"+obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' ";
					str += "data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
					str += "<a href='/download?fileName="+fileCallPath+"'>";
					str += "<i class=\"fas fa-paperclip\"></i>";
					str += obj.fileName.substr(0,10) + "..."+ obj.fileName.substr(obj.fileName.lastIndexOf("."),obj.fileName.length);
					str+= "</a><span data-file=\'"+fileCallPath+"\' data-type='file'> x </span></div></li>";
				} else {
					var originalPath = obj.uploadPath + "/" + obj.uuid + "_"+obj.fileName;
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
					console.log(originalPath);
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' ";
					str += "data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>"
					str += "<a href=\"javascript:showImage(\'"+originalPath+"\')\">";
					str += "<img src='/display?fileName="+fileCallPath+"' style='width:50px' alt=''>";
					str +=	"</a><span data-file=\'"+fileCallPath+"\' data-type='image'> x </span></div></li>";
				}
			})
			uploadUL.append(str);
		}

		$(".bigPictureWrapper").on("click",function () {
			$(".bigPicture").animate({width:'0%',height:'0%'},1000);
			setTimeout(()=> {
				$(this).hide();
			},1000);
		})

		$(".uploadResult").on("click","span",function () {
			var targetFile = $(this).data("file");
			var type = $(this).data("type");

			$(this).parent().remove();
			console.log(targetFile);

			$.ajax({
				url: '/deleteFile',
				data: {fileName: targetFile, type: type},
				dagaType: 'text',
				type: 'post',
				success: function (result) {
					alert(result);
				}
			});

		})
	});


	function showImage(fileCallPath) {

		$(".bigPictureWrapper").css("display","flex").show();

		var imageTag = "<img src='/display?fileName="+encodeURI(fileCallPath)+"'/>";
		$(".bigPicture").html(imageTag).animate({width:'100%',height: '100%'},1000);
	}
</script>
<%@include file="../include/footer.jsp"%>
</body>
</html>
