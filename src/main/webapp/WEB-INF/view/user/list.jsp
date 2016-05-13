<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../inc/common.jsp"%>
<body>
	<!-- form的固定id="mainForm"，已封装获得表单查询参数 
		 搜索按钮固定调用doSearch()方法，
		 结果table列表固定id="table"
		col-lg-12 这种通过后面的数字改变宽度-->
	<div class="main-body">
		<div class="panel panel-default">
			<div class="panel-heading animated fadeInRight">
				<div class="row">
					<div class="col-lg-12">
						<form class="form-horizontal" name="mainForm" id="mainForm"
							method="post">
							<div class="form-group">
								<label class="col-sm-1 control-label" >名称</label>
								<div class="col-sm-2">
									<input type="text" class="form-control" name="name">
								</div>
								<label class="col-sm-1 control-label" >xxx</label>
								<div class="col-sm-2">
									<select name="XXX" class="form-control">
										<option value="">-- 不限 --</option>
										<option value="">-- apple --</option>
										<option value="">-- microsoft --</option>
									</select>
								</div>
							</div>
							
							<div class="form-group">
								<label class="col-sm-1 control-label" >开始时间</label>
								<div class="col-sm-2">
									<input type="text" class="form-control" id="start" name="startDate">
								</div>
								<label class="col-sm-1 control-label">结束时间</label>
								<div class="col-sm-2">
									<input type="text" class="form-control" id="end" name="endDate" >
								</div>
								<div class="col-sm-1" style="width: 70px;">
									<button class="btn btn-primary" type="button" style="width:80px;"
										onclick="javascript:doSearch()">搜索</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>

			<div class="panel-body animated fadeInUp">
				<div id="toolbar">
					<button class="btn btn-success btn-sm" type="button"
										onclick="javascript:add()">
						<span class="glyphicon glyphicon-plus" aria-hidden="true"></span> 新增
					</button>	
		            <button class="btn btn-danger btn-sm" type="button"
										onclick="javascript:deleteItems()">批量删除</button>
		        </div>
				<table id="table" data-toolbar="#toolbar" data-show-columns="true">
					<thead>
						<tr>
							<th data-checkbox="true" ></th>
							<th data-field="id">ID</th>
			                <th data-field="loginName"  data-formatter="longLength">登陆名</th>
			                <th data-field="name"  data-formatter="longLength">真实名</th>
			                <th data-field="createDate" >创建时间</th>
			                <th data-formatter="operator">操作</th>
		                </tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var start = {
	    elem: '#start',
	    format: 'YYYY-MM-DD',
	    //min: laydate.now(), //设定最小日期为当前日期
	    max: laydate.now(), //最大日期
	    istoday: false,
	    choose: function(datas){
	         end.min = datas; //开始日选好后，重置结束日的最小日期
	         end.start = datas //将结束日的初始值设定为开始日
	    }
	};
	var end = {
	    elem: '#end',
	    format: 'YYYY-MM-DD',
	    //min: laydate.now(),
	    max:laydate.now(),
	    istoday: false,
	    choose: function(datas){
	        start.max = datas; //结束日选好后，重置开始日的最大日期
	    }
	};
	laydate(start);
	laydate(end);
	
	$(document).ready(function() {
		$('#table').bootstrapTable({
		    url: basePath + '/user/userPageList'
		});
	});
	
	function add() {
		window.location.href = basePath+'/user/add';
	}
	
	function operator(value,row,index){
		var str = '<button type="button" class="btn btn-info btn-xs" onclick="javascript:layer.alert(\''
			+ row.id
			+ '\')"><span class="glyphicon glyphicon-search" aria-hidden="true"></span> 查看</button>';
		str += '		<button type="button" class="btn btn-warning btn-xs" onclick="javascript:layer.alert(\''
			+ row.id
			+ '\')"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span> 编辑</button>';
		str += '		<button type="button" class="btn btn-danger btn-xs" onclick="javascript:deleteItem(\''
			+ row.id
			+ '\')"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 删除</button>';
		return str;
	}
	
	//删除
	function deleteItem(id) {
		layer.confirm('你确定删除吗？', {icon: 3}, function(index){
			layer.close(index);
			$.ajax({
				url:basePath+'/user/delete?ids='+ id,
				type:'post',
				success:function(data){
					if(data.code == "1"){
						layer.alert(data.msg);
					}else{
						layer.alert(data.msg);
					}
					doSearch();
				}
			});	
		});	
	}

	function deleteItems() {
		var ids = $.map($('#table').bootstrapTable('getSelections'), function(
				row) {
			return row.id
		});
		if(ids.length<=0){
			layer.alert("请选择");
			return;
		}
		layer.confirm('你确定删除吗？', {icon: 3}, function(index){
		    layer.close(index);
		    $.ajax({
				url: basePath+'/user/delete',
				type : 'post',
				data : {
					"ids" : ids.toString()
				},
				success : function(data) {
					if(data.code == "1"){
						layer.alert(data.msg);
					}else{
						layer.alert(data.msg);
					}
					doSearch();
				}
			});
		});
	}
	
	
	function longLength(value,row,index) {//字段超长截取字符串
        if (value&&value.length > 20) {
            return '<span title="'+value+'">'+value.substring(0, 17) + '...'+'</span>';
        } else {
            return value;
        }
    }
</script>
</html>