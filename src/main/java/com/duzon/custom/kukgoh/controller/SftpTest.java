package com.duzon.custom.kukgoh.controller;

import java.util.HashMap;
import java.util.Map;

import com.duzon.custom.kukgoh.util.SFTPUtil;
import com.duzon.custom.kukgoh.util.Utils;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;

public class SftpTest {
	
	public static void main(String[] args) {
		SFTPUtil sFTPUtil = new SFTPUtil();
	    ChannelSftp channelSftp = new ChannelSftp();
	    Map<String, Object> erpInfo = new HashMap<String, Object>();
	    Utils util = new Utils();
	    
	    try {
	    	
	    	erpInfo.put("id", "leeho");
		    erpInfo.put("pw", "2180");
		    erpInfo.put("ip", "183.97.28.253");
		    erpInfo.put("port", "21");
		    System.out.println("Start");
		    System.out.println();
		    channelSftp = sFTPUtil.connSFTP(erpInfo);
		    
		    System.out.println("@@");
		    channelSftp.mkdir("/KBSN/enaraTest");
		    System.out.println("@@2");
	    } catch (Exception e) {
	    	System.out.println("@@1");
	    	e.printStackTrace();
	    }
	}
	
}
