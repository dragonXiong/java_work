package com.whty.web.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.whty.common.util.MD5;
import com.whty.common.util.Uuid;
import com.whty.web.mapper.UserMapper;
import com.whty.web.model.User;

@Service
@Transactional
public class UserService{
	
	@Autowired
	private UserMapper userMapper;

	public List<User> selectList(User user) {
		List<User> list = userMapper.selectList(user);
		return list;
	}

	public void deleteByIds(String[] ids) {
		List<String> idList = Lists.newArrayList();
		for (String id : ids) {
			if(null==id){
				continue;
			}
			//过滤超级用户
			if(id.equals("1")){
				continue;
			}
			idList.add(id);
		}
		if(null!=idList&&!idList.isEmpty()){
			userMapper.deleteByIds(idList);
		}
	}

	/**
	 * 批量保存
	 */
	public void batchSave(){
		List<User> saveList = Lists.newArrayList();
		User d = new User();
		d.setId(Uuid.getUUID());
		d.setName("aaa");
		d.setCreateDate(new Date());
		saveList.add(d);
		
		User dd = new User();
		dd.setId(Uuid.getUUID());
		dd.setName("bbb");
		dd.setCreateDate(new Date());
		saveList.add(dd);
		userMapper.batchSave(saveList);
	}

	public void save(User user) {
		entryptPassword(user);
		if(null!=user.getId()){
			userMapper.updateByPrimaryKeySelective(user);
		}else{
			user.setId(Uuid.getUUID());
			user.setCreateDate(new Date());
			userMapper.insertSelective(user);
		}
	}
	
	/**
	 * 设定安全的密码，生成随机的salt并经过1024次 sha-1 hash
	 */
	private void entryptPassword(User user) {
		user.setPassword(MD5.getMD5Str(user.getPassword()));
	}

	public User selectOne(User u) {
		return userMapper.selectOne(u);
	}
	
	public boolean checkPwd(User user,String oldPassword){
		if(user.getPassword().equals(MD5.getMD5Str(oldPassword))){
			return true;
		}else{
			return false;
		}
	}
	
	public Boolean checkLoginName(String loginName) {
		Boolean flag = false;
		User user = new User();
		user.setLoginName(loginName);
		User u = selectOne(user);
		if(null!=u){
			flag = true;
		}
		return flag;
	}
}
