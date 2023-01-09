package com.duzon.custom.common.utiles;

import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class Utils {
	
	//ip 호출
    public static String getIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null) {
            ip = request.getHeader("WL-Proxy-Client-IP"); // 웹로직
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    public static String PERMIT = "05";
    public static String REJECT = "02";
    public static String REQUEST_PERMIT = "01";
    public static String REQUEST_APPROVAL = "20";
    public static String getApprovalSts(String checkEvt, String preSts) {
    	if(REQUEST_PERMIT.equals(preSts) && PERMIT.equals(checkEvt)) {
    		return PERMIT;
    	}else if(REQUEST_PERMIT.equals(preSts) && REJECT.equals(checkEvt)) {
    		return REJECT;
    	}else if(PERMIT.equals(preSts) && REQUEST_APPROVAL.equals(checkEvt)) {
    		return REQUEST_APPROVAL;
    	}
    	return "";
    }
    
    
    public static List<Map<String, Object>> defaultMapDeptList(List<Map<String, Object>> list){
		Map<String, Object> defaultMap = new HashMap<String, Object>();
		defaultMap.put("code_kr", "전체");
		defaultMap.put("code", "all");
		list.add(defaultMap);
		
		int length = list.size();
		int temp = length-1;
		for (int i =0; i < temp; i++) {
			length -= 1;
			Collections.swap(list, length-1, length);
			
		}
    	return list; 
    }
    public static void fileCopy() {
    	File source = new File("D://bcl4.txt");
    }
}
