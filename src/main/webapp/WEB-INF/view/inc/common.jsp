<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!-- 
页面样式组件：http://www.bootcss.com/
分页：http://bootstrap-table.wenzhixin.net.cn/zh-cn/documentation/
css3动画：http://daneden.github.io/animate.css/
表单校验：http://niceue.com/validator/
弹窗：http://layer.layui.com/
 -->
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>系统管理</title>
<link  type="text/css" rel="stylesheet" href="${path}/css/bootstrap.min.css"/>
<link  type="text/css" rel="stylesheet" href="${path}/css/bootstrap-table.css"/>
<link  type="text/css" rel="stylesheet" href="${path}/js/nicevalidator/jquery.validator.css"/>
<link  type="text/css" rel="stylesheet" href="${path}/css/base.css"/>
<!-- 下面这个是css3动画效果，纯好玩,不喜欢可以删掉 使用：在元素class后跟'animated fadeInRight'，fadeInRight是特效名称，自己替换，见上面的链接-->
<%-- <link  type="text/css" rel="stylesheet" href="${path}/css/animate.min.css"/> --%>
<script type="text/javascript" src="${path}/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="${path}/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${path}/js/bootstrap-table.min.js"></script>
<script type="text/javascript" src="${path}/js/bootstrap-table-zh-CN.min.js"></script>
<script type="text/javascript" src="${path}/js/bootstrap-table-flat-json.min.js"></script>
<script type="text/javascript" src="${path}/js/layer/layer.js"></script>
<script type="text/javascript" src="${path}/js/laydate/laydate.js"></script>
<script type="text/javascript" src="${path}/js/nicevalidator/jquery.validator.js"></script>
<script type="text/javascript" src="${path}/js/nicevalidator/zh-CN.js"></script>
<script type="text/javascript" src="${path}/js/common.js?time=<%=System.currentTimeMillis()%>"></script>
</head>
