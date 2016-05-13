package com.whty.web.mapper;

import java.util.List;

import com.whty.web.model.User;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

	void deleteByIds(List<String> idList);

	void batchSave(List<User> saveList);

	List<User> selectList(User user);

	User selectOne(User u);
}