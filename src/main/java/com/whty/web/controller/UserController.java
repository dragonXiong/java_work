package com.whty.web.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Maps;
import com.whty.common.util.CacheUtils;
import com.whty.common.vo.PageVo;
import com.whty.web.model.User;
import com.whty.web.service.UserService;

@Controller
@RequestMapping(value="/user")
public class UserController {
	
	protected Logger log = LoggerFactory.getLogger(getClass());
	
	
	@Autowired
	private UserService userService;
	
	@Value("#{configProp['service.code']}")
	private Integer code;//读取配置文件
	
	@RequestMapping(value="index")
	public String index(){
		return "user/index";
	}
	
	@RequestMapping(value="add")
	public String add(){
		return "user/add";
	}
	
	
	//校验登录名是否重复
	@RequestMapping(value="checkLoginName")
	@ResponseBody
	public Map<String,Object> checkLoginName(String loginName){
		Map<String,Object> result = Maps.newHashMap();
		Boolean flag = userService.checkLoginName(loginName);
		if(flag){
			result.put("error", "该登陆名已存在");
		}else{
			result.put("ok", "登陆名可用！");
		}
		return result;
	}
	
	//用于接口，通过改变produces控制返回类型（xml或json）
	@RequestMapping(value="get",method = RequestMethod.GET,produces={MediaType.APPLICATION_XML_VALUE,MediaType.TEXT_XML_VALUE})
	@ResponseBody
	public User get(){
		log.info("进入get()方法");
		User d = new User();
		d.setId("fdsj233");
		d.setName("aaa");
		return d;
	}
	
	//结合页面分页的例子
	@RequestMapping(value="userList")
	public String userList(){
		return "user/list";
	}
	
	@RequestMapping(value="userPageList")
	@ResponseBody
	public PageInfo<User> userPageList(User user,PageVo pageVo){
		if(user == null){
			user = new User();
		}
		PageHelper.startPage(pageVo.getPageNumber(), pageVo.getPageSize());//分页工具类，自动拦截它之后的查询
		List<User> userList = userService.selectList(user);
		PageInfo<User> pageInfo = new PageInfo<User>(userList);
		return pageInfo;
	}
	
	
	@RequestMapping(value="save")
	@ResponseBody
	public Map<String,Object> save(User user){
		Map<String,Object> result = Maps.newHashMap();
		try {
			if(user!=null){
				userService.save(user);
			}
			result.put("code", 1);
			result.put("msg", "保存成功");
		} catch (Exception e) {
			log.error("保存用户失败", e);
			result.put("code", 0);
			result.put("msg", "保存失败");
		}
		return result;
	}
	
	@RequestMapping(value="getProp")
	@ResponseBody
	public Integer getProp(){
		Integer aa = (Integer) CacheUtils.get("code");
		if(aa==null){
			CacheUtils.put("code", code);
			aa = code;
		}
		return aa;
	}
	
	@RequestMapping(value = "delete")
	@ResponseBody
	public Map<String,Object> delete(String[] ids) {
		Map<String,Object> result = Maps.newHashMap();
		try {
			if (ids != null && ids.length > 0) {
				userService.deleteByIds(ids);
			}
			result.put("code", 1);
			result.put("msg", "删除成功");
		} catch (Exception e) {
			log.error("删除用户失败", e);
			result.put("code", 0);
			result.put("msg", "删除用户失败");
		}
		return result;
	}
	
	//修改密码
	@RequestMapping(value="updatePwd")
	public String updatePwd(){
		return "user/updatePwd";
	}
	
	@RequestMapping(value="savePwd")
	@ResponseBody
	public Map<String,Object> savePwd(String orgPwd,String password,HttpSession session){
		Map<String,Object> result = Maps.newHashMap();
		try {
			if(userService.checkPwd((User) session.getAttribute("user"),orgPwd)){
				User user = (User) session.getAttribute("user");
				user.setPassword(password);
				userService.save(user);
				result.put("code", 1);
			}else{
				result.put("code", 2);//原密码不对
			}
		} catch (Exception e) {
			log.error("修改密码失败",e);
			result.put("code", 0);
		}
		
		return result;
	}
}
