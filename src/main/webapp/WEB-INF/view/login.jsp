<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ page import="org.apache.shiro.authc.ExcessiveAttemptsException"%>
<%@ page import="org.apache.shiro.authc.IncorrectCredentialsException"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%
String error = (String) request.getAttribute(FormAuthenticationFilter.DEFAULT_ERROR_KEY_ATTRIBUTE_NAME);
request.setAttribute("error", error);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>系统管理</title>
<link type="text/css" rel="stylesheet" href="${path}/css/bootstrap.min.css" />
<script type="text/javascript" src="${path}/js/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="${path}/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${path}/js/jQuery.md5.js"></script>
<script>
var captcha;
function refreshCaptcha(){  
    $("#img_captcha").attr('src',"${path}/images/kaptcha.jpg?t=" + Math.random());
}  
</script>

<body style="background-color: #f3f3f4;">
	<div style="padding: 100px 0 170px 0;">
		<div class="center-block" style="width:400px;padding: 20px !important;">
			<div class="panel panel-info">
				<div class="panel-heading" style="text-align: center;">
					<span style="font-size:18px;">欢迎使用后台管理系统</span>
				</div>
				<div class="panel-body">
					<form action="${path}/login" method="post" id="loginForm">
						  <div class="form-group">
						    <label>用户名（默认admin/123456）</label>
						    <input type="text" class="form-control" name="username" placeholder="请输入用户名" required>
						  </div>
						  <div class="form-group">
						    <label>密码</label>
						    <input type="password" class="form-control" name="password" id="user_pwd" placeholder="请输入密码" required>
						  </div>
						  <div class="form-group">
						  	<label>验证码</label>
						    <input type="text" id="captcha" name="captcha" class="form-control" placeholder="请输入验证码" required style="width:150px;"/>
							<img alt="验证码" src="${path}/images/kaptcha.jpg" title="点击更换" id="img_captcha" onclick="javascript:refreshCaptcha();" style="float:right;height:40px;margin-top:-40px;"/>
						  </div>
						  <div class="form-group" style="color:red;" id="errortip">
						  </div>
						  <c:choose>
								<c:when test="${error eq 'com.whty.admin.filter.CaptchaException'}">
									<script>
										$("#errortip").html("验证码错误，请重试");
									</script>
								</c:when>
								<c:when test="${error eq 'org.apache.shiro.authc.UnknownAccountException'}">
									<script>
										$("#errortip").html("用户名或密码错误，请重试");
									</script>
								</c:when>
								<c:when test="${error eq 'org.apache.shiro.authc.IncorrectCredentialsException'}">
									<script>
										$("#errortip").html("用户名或密码错误，请重试");
									</script>
								</c:when>
						  </c:choose>
						  <button type="button" onclick="javascript:login()" class="btn btn-lg btn-primary btn-block">登录</button>
					</form>
				</div>
			</div>
		</div>
		
	</div>

</body>
<script type="text/javascript">

	$(function() {
		//回车键提交表单
		document.onkeydown = function(e) { 
			var ev = document.all ? window.event : e;
			if (ev.keyCode == 13) {
					login();
			}
		}
	});
	function login() {
		$("#user_pwd").val($.md5($("#user_pwd").val()));//md5加密后提交
		$("#loginForm").submit();
	}
</script>
</html>
