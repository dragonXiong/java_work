<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../inc/common.jsp"%>
<link type="text/css" rel="stylesheet" href="${path}/js/webuploader/webuploader.css" />
<script type="text/javascript" src="${path}/js/webuploader/webuploader.min.js"></script>
<style>
span.state{
	margin-left:10px;
}
.progress{
	margin-bottom:0px;
}
</style>
<body>
	<input type="hidden" name="uploadType" id="uploadType" value="${type}">
	<input type="hidden" name="maxNum" id="maxNum" value="${maxNum}">
	<div class="main-body">
				<div class="panel panel-default">
						<div class="panel-heading">
								<div  id="picker"  style="float:left;width:100px;">选择文件</div>
								<button id="ctlBtn" class="btn btn-success" type="button" style="height: 40px;">开始上传</button>（最多${maxNum}个，单文件最大300M）
						</div>
						<div class="panel-body" style="height:300px;">
									<ul class="list-group" id="thelist">
									</ul>
						</div>
				</div>
				<div  style="text-align:center;bottom: 20px;width: 100%;">
								<button class="btn btn-info" type="button" onclick="javascript:add()" >确定添加</button>
				</div>
	</div>
</body>
<script type="text/javascript">
var $btn = $('#ctlBtn');
var state = 'pending';
var maxNum =  $('#maxNum').val();
var uploader = WebUploader.create({
    // swf文件路径
    swf: basePath + '/js/webuploader/Uploader.swf',
    // 文件接收服务端。
    server: basePath+'/file/saveFile',
    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
    pick: '#picker',
    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
    resize: false,
    //上传文件总数
    fileNumLimit :maxNum,
    //可以上传的文件类型,服务端配置文件里面也有限制
    accept:{
    	extensions: 'doc,docx,xls,xlsx,ppt,txt,zip,rar,exe,gif,jpg,jpeg,png,bmp'
    },
    fileSingleSizeLimit:100*1024*1024 //单个文件大小限制 300M，服务端spring-mvc.xml里面也有限制
});

//当文件被加入队列之前触发
uploader.on( 'beforeFileQueued', function( file ) {
	var name = file.name;
	if(name.length>50){
		alert("文件名过长");
		return false;
	}
});
//当有文件被添加进队列的时候
uploader.on( 'fileQueued', function( file ) {
	$('#thelist').append('<li class="list-group-item" id="' + file.id + '"><input type="hidden" id="hid_'+file.id+'"/>'+file.name +
			' <span class="state">等待上传...</span><span class="glyphicon glyphicon-remove delete" data-id="'+file.id+'"></span></li>');
});
//文件上传过程中创建进度条实时显示。
uploader.on( 'uploadProgress', function( file, percentage ) {
    var $li = $( '#'+file.id ),
        $percent = $li.find('.progress .progress-bar');
    // 避免重复创建
    if ( !$percent.length ) {
        $percent = $('<div class="progress progress-striped active">' +
          '<div class="progress-bar" role="progressbar" style="width: 0%">' +
          '</div>' +
        '</div>').appendTo( $li ).find('.progress-bar');
    }
    $li.find('p.state').text('上传中');
    $percent.css( 'width', percentage * 100 + '%' );
});
//上传成功时的操作
uploader.on( 'uploadSuccess', function( file,response) {
	if(response.code=='1'){
		$('#hid_'+file.id).attr('data-org',response.orgName);
		$('#hid_'+file.id).attr('data-new',response.newName);
		$( '#'+file.id ).find('span.state').text('已上传');
	}else{
		$( '#'+file.id ).find('span.state').text('上传失败：'+response.msg);
	}
});
//添加到队列出错时的提示
uploader.on( 'error', function(code) {
	switch( code ) {
    case 'Q_EXCEED_NUM_LIMIT':
        alert( '文件数量超出');
        break;
    case 'Q_EXCEED_SIZE_LIMIT':
    	alert( '文件总大小超出了限制');
        break;
    case 'Q_TYPE_DENIED':
    	alert( '不允许上传该格式文件');
        break;
    case 'F_EXCEED_SIZE':
    	alert( '文件太大了');
        break;
    case 'F_DUPLICATE':
    	alert( '文件重复了');
        break;
    default:
    	alert('上传失败，请重试');
        break;
}
});

uploader.on( 'uploadError', function( file ) {
    $( '#'+file.id ).find('span.state').text('上传出错');
});
uploader.on( 'uploadComplete', function( file ) {
    $( '#'+file.id ).find('.progress').fadeOut();
});

uploader.on( 'all', function( type ) {
    if ( type === 'startUpload' ) {
        state = 'uploading';
    } else if ( type === 'stopUpload' ) {
        state = 'paused';
    } else if ( type === 'uploadFinished' ) {
        state = 'done';
    }
    if ( state === 'uploading' ) {
        $btn.text('暂停上传');
    } else {
        $btn.text('开始上传');
    }
});
$btn.on( 'click', function() {
    if ( state === 'uploading' ) {
        uploader.stop();
    } else {
        uploader.upload();
    }
});
$("#thelist").on("click",".delete",function() {
	var fileid=$(this).attr('data-id');
	var newName = $('#hid_'+fileid).attr('data-new');//获得新文件的名字
	$( '#'+fileid ).remove();//删掉整个页面元素
	uploader.removeFile(fileid);//从队列中删除文件，以便再次添加
	if(newName){//从服务器上删除
		$.ajax({
			url:basePath+'/file/deleteFile',
			type:'post',
			data:{newFileName:newName},
			success:function(data){
				if(data.code == "1"){
					console.log('删除成功：'+newName);	
				}else{
					console.log('删除失败：'+newName);	
				}
			}
		});	
	}
});
var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
function add(){
	var type=$("#uploadType").val();//type:弹窗序号，用于单页面加载多个上传
	var stats = uploader.getStats();
	var sucNum = stats.successNum;
	var progressNum = stats.progressNum;
	layer.confirm('上传成功数:'+sucNum+',正在上传数:'+progressNum+',确定要添加吗？', {icon: 3}, function(){
		var obj={};
		$("#thelist input[type='hidden']").each(function(){
			var orgName = $(this).attr('data-org');
			var newName = $(this).attr('data-new');
			if(orgName&&newName){
				obj[newName] = orgName;
			}
		});
		parent.getSelectedFiles(obj,type);
	    parent.layer.close(index);
	})
}
</script>
</html>