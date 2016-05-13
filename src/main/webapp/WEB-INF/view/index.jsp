<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>  
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>系统管理</title>
<link type="text/css" rel="stylesheet"
	href="${path}/css/bootstrap.min.css" />
<link type="text/css" rel="stylesheet"
	href="${path}/css/metisMenu.min.css" />
<script type="text/javascript" src="${path}/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="${path}/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${path}/js/metisMenu.min.js"></script>
</head>

<style>
.navbar {
	margin-left: 0;
	margin-right: 0;
	border: 0;
	-webkit-box-shadow: none;
	box-shadow: none;
	border-radius: 0;
	margin: 0;
	background: #428bca;
}

.navbar .navbar-nav>li>a, .navbar .navbar-nav>li>a:hover, .navbar .navbar-nav>li>a:focus
	{
	font-size: 13px;
	text-shadow: none;
	color: #fff;
}

.navbar .navbar-brand {
	color: #fff;
	font-size: 24px;
	text-shadow: none;
	padding-top: 10px;
	padding-bottom: 10px;
}

.sidebar {
	position: fixed;
	width: 220px;
	z-index: 2001;
	height: 100%;
	border-right: 1px solid #ddd;
}

.sidebar-shortcuts {
	background-color: #1ab394;
	border-bottom: 1px solid #ddd;
	text-align: center;
	line-height: 36px;
	color: #fff;
}

.sidebar-nav ul {
	padding: 0;
	margin: 0;
	list-style: none;
}

.sidebar-nav ul li, .sidebar-nav ul a {
	display: block;
}

.sidebar-nav ul a {
	padding: 10px 20px;
	color: #616161;
	background-color: #ebf2f9;
	border-top: 1px solid #ddd;
}

.sidebar-nav ul a:hover, .sidebar-nav ul a:focus, .sidebar-nav ul a:active
	{
	color: #000;
	text-decoration: none;
	background-color: #ebf2f9;
}

.sidebar-nav ul ul a {
	padding: 5px 30px;
	color: #616161;
	background-color: #f2f2f2;
}

.sidebar-nav ul ul a:hover, .sidebar-nav ul ul a:focus, .sidebar-nav ul ul a:active
	{
	color: #fff;
	text-decoration: none;
	background-color: #3280fc;
}

.sidebar-nav-item {
	padding-left: 5px;
}

.sidebar-nav-item-icon {
	padding-right: 5px;
}

.content {
	margin-left: 220px;
	height: 100%;
	overflow: hidden;
	width: auto;
}

.breadcrumb {
	margin-bottom: 0px;
}

.main-breadcrumb {
	background-color: #f2f2f2;
	margin-left: 220px;
}
</style>
<body style="overflow-y: hidden;">
			<!-- 顶栏header-->
			<nav class="navbar navbar-default">
				  <div class="container-fluid">
				  <!-- 左侧logo项目名称等等 -->
				    <div class="navbar-header">
				      <a class="navbar-brand" href="${path}/index">后台管理系统</a>
				    </div>
				    <!-- 右侧账号信息 -->
				    <div class="collapse navbar-collapse" >
				      <ul class="nav navbar-nav navbar-right">
				        <li class="dropdown">
				          <a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
				          		<shiro:user>
									<shiro:principal/>
								</shiro:user>
				          		 <span class="caret"></span>
				          </a>
				          <ul class="dropdown-menu">
				            <li><a href="javascript:void(0)" data-html="${path}/user/updatePwd">修改密码</a></li>
				            <li role="separator" class="divider"></li>
				            <li><a href="${path}/logout">安全退出</a></li>
				          </ul>
				        </li>
				      </ul>
				    </div>
				  </div>
				</nav>
			<!-- 顶栏header-->
		<div class="sidebar">
			<div class="sidebar-shortcuts" id="sidebar-shortcuts">项目结构</div>
			<nav class="sidebar-nav">
				<ul class="metismenu" id="menu">
					<li>
						<a>网络<span class="glyphicon arrow"></span></a>
						<ul>
							<li><a href="http://www.qq.com" data-html="http://www.qq.com">qq</a></li>
							<li><a href="javascript:void(0)" data-html="http://www.163.com">163</a></li>
						</ul>
					</li>
					<li class="active">
						<a>本地<span class="glyphicon arrow"></span></a>
						<ul>
							<li><a href="${path}/user/userList" data-html="${path}/user/userList">用户列表</a></li>
							<li><a href="${path}/user/add" data-html="${path}/user/add">新增用户</a></li>
						</ul>
					</li>
				</ul>
			</nav>
		</div>


			<div class="main-breadcrumb">
				<ol class="breadcrumb">
					<li><i class="glyphicon glyphicon-home"></i> <a href="#">首页</a>
					</li>
					<li class="active" id="pathname"></li>
				</ol>
			</div>
			<div id="content" class="content"></div>
</body>

<script>
	$(function() {
		$("#menu").metisMenu();
		$("a[data-html]")
				.click(
						function(e) {
							e.preventDefault();
							var url = $(this).attr("data-html");
							var iframe = $('<iframe id="mainframe" onload="iFrameHeight()" frameborder="no" height="800px" width="100%" src="'
									+ url + '" ></iframe>');
							var pathname=$(this).text();
							$("#pathname").html(pathname);
							$("#content").html(iframe);
						});
	})
	//调整iframe大小
	function iFrameHeight() {
		var dheight=$(window).height()-90;
		var ifm = document.getElementById("mainframe");
		ifm.height=dheight;
	}
	window.onresize = function () {iFrameHeight();}//改变浏览器窗口大小时，调整iframe大小
</script>
</html>