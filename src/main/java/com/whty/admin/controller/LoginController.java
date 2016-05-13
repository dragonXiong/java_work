package com.whty.admin.controller;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.mgt.RealmSecurityManager;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class LoginController {
	
	//登陆
	@RequestMapping(value="login" ,method = RequestMethod.GET)
	public String login() {
		return "login";
	}

	//登陆失败
	@RequestMapping(value="login",method = RequestMethod.POST)
	public String fail(@RequestParam(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM) String userName, Model model) {
		model.addAttribute(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM, userName);
		return "login";
	}
	
	//登出
	@RequestMapping(value="logout")
	public String logout(Model model) {
		RealmSecurityManager securityManager =  (RealmSecurityManager) SecurityUtils.getSecurityManager();
		UserRealm userRealm = (UserRealm) securityManager.getRealms().iterator().next();
		Subject subject = SecurityUtils.getSubject();
		subject.logout();
		userRealm.clearCache(subject.getPrincipals());
		return "login";
	}
	
	@RequestMapping(value="/")
	public ModelAndView jump(){
		return new ModelAndView("redirect:/index");
	}
	
	
	@RequestMapping(value="index")
	public String index(){
		return "index";
	}
	
}
