var protocol = window.location.protocol;
var host = window.location.host;
var index = window.location.pathname.lastIndexOf('/');
var project = window.location.pathname.split("/")[1];
var basePath = protocol + "//" + host + "/" + project;
var query;

$.extend($.fn.bootstrapTable.defaults, {
	method:'post',
	pagination:true,
	striped:true,
	flat:true,//这个对应flat-json插件，可以用data-field="user.id"获取多层json里面的值
	sidePagination:'server',
	contentType:'application/x-www-form-urlencoded',
	pageList:[10,20,50],
	queryParamsType:'else',
	queryParams:'postQueryParams',
    responseHandler: function (res) {
        return {total:res.total,rows:res.list};//用于和后台返回的PageInfo对象绑定
    }
});
$.extend($.fn.bootstrapTable.columnDefaults, {
    align: 'center',
    valign: 'middle'
});

function doSearch() {
	//点击搜索按钮后查询条件才生效，防止修改了查询条件，不点搜索，点下一页的时候结果变了
	query = $("#mainForm").serializeArray();
	var cur = $('#table').bootstrapTable('getOptions')['pageNumber'];
	if(cur==1){
		$('#table').bootstrapTable('refresh');
	}else{
		//当pageNumber和当前的相同时，refreshOptions不会执行，第2页之后输入查询条件后点击查询，需跳转到第1页
		$('#table').bootstrapTable('refreshOptions', {pageNumber:1});
	}
}

function postQueryParams(params) {
	if(query&&query.length>0){
		for ( var item in query) {
			params[query[item].name] = query[item].value;
		}
	}
    return params;  
}