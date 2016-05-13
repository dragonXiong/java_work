package com.whty.common.util;

import java.io.IOException;
import java.io.InputStream;

import jodd.props.Props;

import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;

public class PropertiesUtil {
	
	private static ResourceLoader resourceLoader = new DefaultResourceLoader();
	
	public static String getValueString(String key){
		String value="";
		InputStream is = null;
	    try {
	    	Props p = new Props();
	    	Resource resource = resourceLoader.getResource("classpath:/properties/application.properties");
	    	is = resource.getInputStream();
			p.load(is);
			value= p.getValue(key);
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			try {
				is.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	    return value;
	}
	
}
