package com.whty.web.job;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DemoTask {
	
	protected Logger log = LoggerFactory.getLogger(getClass());
	
	private static boolean isRunning = false;
	
	public void run(){
		log.info("===========================定时任务开始=================================");
		if (isRunning) {
			log.info("=========定时任务正在运行，此次运行结束。。。。。============");
			return;
		}
		isRunning = true;
		try {
			log.info("==========定时任务running----------"+ new Date());
		} catch (Exception e) {
			log.error("定时任务出错", e);
		}finally {
			isRunning = false;
			log.info("===========================定时任务结束=================================");
		}
	}
}
