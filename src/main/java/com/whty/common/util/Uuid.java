package com.whty.common.util;

import java.util.UUID;

public class Uuid {
	public static String getUUID() {
		String uuid = UUID.randomUUID().toString();
		uuid = uuid.replaceAll("-", "");//去掉“-”，可以跟oracle的sys_guid()方法生成的uuid长度保持一致
		return uuid;
	}
}
