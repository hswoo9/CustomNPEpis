package com.duzon.custom.kukgoh.util;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.duzon.custom.kukgoh.service.KukgohService;
import com.jcraft.jsch.SftpException;

public class KukgohThread extends Thread {
	@Autowired
	KukgohService kukgohService;
	
	
	public void searchRcvFile() throws InterruptedException, SftpException, IOException {
		int i = 0;
		try {
			while (i < 5) {
				System.out.println("스레드 슬립 : " + i);
				Thread.sleep(5000);
		    	long start = System.currentTimeMillis();
		        String ip = "SYSTEM";
				String empSeq = "SYSTEM";
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("EMP_SEQ", empSeq);
				map.put("EMP_IP", ip);
				map.put("CODE_VAL", "0");
		    	kukgohService.getRemoteFile(map);
		    	long end = System.currentTimeMillis();
		    	System.out.println( "실행 시간 : " + ( end - start )/1000.0 );
				
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

	}

	@Override
	public void run() {
		try {
			searchRcvFile();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (SftpException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
