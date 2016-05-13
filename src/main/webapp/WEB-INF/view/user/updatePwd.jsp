<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../inc/common.jsp"%>
<body>
	<div class="main-body">
		<div class="panel panel-default">
			<div class="panel-heading animated fadeInRight">
				更改密码
			</div>
			<div class="panel-body animated fadeInUp">
				<form class="form-horizontal" id="saveForm" name="saveForm" method="post" 
					  autocomplete="off" >
				  <div class="form-group">
				    <label class="col-sm-1 control-label">原密码</label>
				    <div class="col-sm-4">
				      <input type="password" class="form-control" name="orgPwd" placeholder="请输入原密码" data-rule="原密码:required">
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
				    <div class="col-sm-offset-1 col-sm-1">
				      <button type="submit" class="btn btn-info">保存</button>
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
    timely: 2,
    //验证成功
    valid: function(form) {
        $.ajax({
            url: basePath + '/user/savePwd',
            type: 'POST',
            data: $(form).serialize(),
            success: function(d){
            	if(d.code=='1'){
            		alert('修改成功,请重新登陆');//这里用alert,阻断
            		top.location.href = basePath+'/logout';	
            	}else if(d.code=='2'){
            		layer.alert('原密码不正确');
            	}else{
            		layer.alert('修改失败');
            	}
            	
            }
        });
    }
});
//就写这么点吧,懒得写了，自己去common.jsp最上面的文档地址去看，中文文档，很详细
</script>
</html>