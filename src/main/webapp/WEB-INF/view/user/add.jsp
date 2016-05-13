<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../inc/common.jsp"%>
<link type="text/css" rel="stylesheet" href="${path}/js/webuploader/webuploader.css" />
<script type="text/javascript" src="${path}/js/webuploader/webuploader.min.js"></script>
<style>
.deleteImg{
   z-index: 99;
    position: relative;
    left: -10px;
    top: -40px;
    color: red;
    cursor: pointer;
}
</style>
<body>
	<div class="main-body">
		<div class="panel panel-default">
			<div class="panel-heading animated fadeInRight">
				新增用户
			</div>
			<div class="panel-body animated fadeInUp">
				<form class="form-horizontal saveForm" id="saveForm" name="saveForm" method="post" 
					  autocomplete="off" >
				  <div class="form-group">
				    <label class="col-sm-1 control-label">登陆名</label>
				    <div class="col-sm-4">
				      <input type="text" class="form-control" name="loginName" placeholder="登陆名" data-rule="登陆名:required;username;remote[checkLoginName, loginName]">
				    </div>
				  </div>
				  <div class="form-group">
				    <label class="col-sm-1 control-label">真实名</label>
				    <div class="col-sm-4">
				      <input type="text" class="form-control" name="name" placeholder="请输入真实名"><!--这个校验见下面的js,两种写法  -->
				    </div>
				  </div>
				  <div class="form-group">
				    <label class="col-sm-1 control-label">密码</label>
				    <div class="col-sm-4">
				      <input type="password" class="form-control" name="password" placeholder="请输入密码" data-rule="密码:required;password">
				    </div>
				  </div>
				  <div class="form-group">
				    <label class="col-sm-1 control-label">确认密码</label>
				    <div class="col-sm-4">
				      <input type="password" class="form-control" name="againPwd" placeholder="请再次输入密码" data-rule="确认密码:required;password;match(password)">
				    </div>
				  </div>
				  <div class="form-group">
				    <label class="col-sm-1 control-label">图片上传</label>
				    <div class="col-sm-2">
							     <div id="picker">选择图片</div>
				    </div>
				    <div class="col-sm-8">
				    			<div id="imageList">
				    				<!-- 存放图片列表 -->
							   </div>
				    </div>
				  </div>
				  <div class="form-group">
				  		 <label class="col-sm-1 control-label">文件上传</label>
				  		 <div class="col-sm-4">
						     	<button type="button" onclick="javascript:uploadFile(1,5)" class="btn btn-info">选择</button>
						     	<a href="${path }/file/download?fileName=7fe4e3aae9d8450ca1036802513cb8de.zip">下载（这里改为自己要下载的文件名）</a>
							    <!--用来存放文件信息-->
							    <ul class="list-group" id="fileList">
								</ul>
					    </div>
				 </div>
				  <div class="form-group">
				    <div class="col-sm-offset-1 col-sm-1">
				      <button type="submit" class="btn btn-info">保存</button>
				    </div>
				    <div class="col-sm-1">
				    	<button type="button" class="btn btn-default" onclick="javascript:window.location.href = basePath+'/user/userList'">取消</button>
				    </div>
				  </div>
				</form>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$('#saveForm').validator({ 
    theme: 'yellow_right_effect',
    focusCleanup: true,
    stopOnError:false,
    //debug: true,
    timely: 2,
    //自定义规则（PS：建议尽量在全局配置中定义规则，统一管理）
    rules: {
        username: [/^[a-zA-Z0-9]+$/, '用户名无效! 仅支持字母与数字。']
    },
    fields: {
        "name": {
            rule: "required",
            tip: "输入你的真实名",
            ok: "名字很棒。",
            msg: {required: "真实名必填!"}
        },
    },
    //验证成功
    valid: function(form) {
        $.ajax({
            url: basePath + '/user/save',
            type: 'POST',
            data: $(form).serialize(),
            success: function(d){
            	window.location.href = basePath+'/user/userList';
            }
        });
    }
});
/*-----------------------------------------文件上传start----------------------------------*/
//弹出文件上传对话框
function uploadFile(type,maxNum){//type:弹窗序号，用于单页面加载多个上传; maxNum:最大上传个数
	layer.open({
	    type: 2,
	    title: '上传文件',
	    area: ['90%', '90%'],
	    shadeClose: false,
		shade:0.8,
		content:  basePath+'/file/uploadFile?type='+type+'&maxNum='+maxNum,scrolling:'no',
	}); 
}
//删除文件
$("#fileList").on("click",".delete",function() {
	var $li=$(this).parent('.list-group-item');
	var newName = $li.attr('data-new');
	$li.remove();
	resetFileIndex();
	if(newName){//从服务器上删除
		$.ajax({
			url:basePath+'/file/deleteFile',
			type:'post',
			data:{newFileName:newName},
			success:function(data){
				if(data.code == "1"){
				}else{
					layer.alert('删除失败：'+newName);	
				}
			}
		});	
	}
});
//文件选择后回调
function getSelectedFiles(obj,type){
	if(obj){
		var str = "";
		var m = 0;
		$.each(obj,function(name,value) {
			str +='<li class="list-group-item" data-new="'+name+'"><input type="text"   value="'+value+'" style="width:220px;"/>'
						+'<input type="hidden"  value="'+name+'"/><span class="glyphicon glyphicon-remove delete"></span></li>';
		});
	}
	console.log(type);
	$("#fileList").append(str); 
	resetFileIndex();
	/*根据type的不同添加到不同的#fileList中去，并添加相应的delete和resetIndex的方法即可
	*例如：
	* if(type==1){
	*			$("#fileList").append(str); 
	*		resetFileIndex();
	*	}elseif(type==2){
	*			$("#fileList2").append(str); 
	*			resetFileIndex2();//增加个resetFileIndex2方法，再添加个上面的delete方法：$("#fileList2").on("click",".delete",function() {
	*	}else{...}
	*/
}
//重置传输到后台的文件list的顺序,单文件的时候不需要这个，直接在要上传的元素上加name属性
function resetFileIndex(){
	var m = 0;
	$("#fileList li[data-new]").each(function(){
		$(this).find("input[type='text']").attr('name','fileList['+m+'].orgName');
		$(this).find("input[type='hidden']").attr('name','fileList['+m+'].newName');
		m=m+1;
	})
}
/*-----------------------------------------文件上传end----------------------------------*/
 
 
/*-----------------------------------------图片上传start，最上面还有段删除图标的CSS----------------------------------*/
var uploader = WebUploader.create({
    swf: basePath + '/js/Uploader.swf',
    server:basePath+'/file/saveFile',
    pick: '#picker',
    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
    resize: false,
    auto :true,
    formData:{isImage:1},//是否是图片
    accept:{
        title: 'Images',
        extensions: 'gif,jpg,jpeg,bmp,png',
        mimeTypes: 'image/*'
    }
});
uploader.on( 'uploadSuccess', function( file,response) {
	if(response.code=='1'){
		var img = '<img src="'+basePath+'/file/download?fileName='+response.newName+'&isImage=1" width="80px" height="80px"/>';
		var hidden = '<input type="hidden"  value="'+response.newName+'"/> ' ;
		var deleteImg = '<span class="deleteImg" data-new="'+response.newName+'" data-fileid="'+file.id+'"><i class="glyphicon glyphicon-remove"></i> </span>';
		$( '#imageList' ).append('<span class="imgli">'+img+hidden+deleteImg+'</span>');
		resetImageIndex();
	}else{
		layer.alert('上传失败：'+response.msg);
	}
});
//删除图片
$("#imageList").on("click",".deleteImg",function() {
	var $li=$(this).parent('.imgli');
	var fileid=$(this).attr('data-fileid');
	var newName = $(this).attr('data-new');
	$li.remove();//删除整个页面元素
	resetImageIndex();//重置列表id
	uploader.removeFile(fileid);//从队列中删除，以便再次添加
	if(newName){//从服务器上删除
		$.ajax({
			url:basePath+'/file/deleteFile',
			type:'post',
			data:{newFileName:newName,isImage:1},
			success:function(data){
				if(data.code == "1"){
				}else{
					layer.alert('删除失败：'+newName);	
				}
			}
		});	
	}
});
//重置传输到后台的图片的list的顺序,
function resetImageIndex(){
	var m = 0;
	$("#imageList .imgli").each(function(){
		$(this).find("input[type='hidden']").attr('name','imageList['+m+'].name');
		m=m+1;
	})
}
/*-----------------------------------------图片上传end，最上面还有段删除图标的CSS----------------------------------*/
</script>
</html>