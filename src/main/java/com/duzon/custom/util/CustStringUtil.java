package com.duzon.custom.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class CustStringUtil {
	
	public static String isNullToString(Object object) {
        String String = "";

        if (object != null) {
            String = object.toString().trim();
        }

        return String;
    }
	
	public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }
	
	public static boolean isEmpty(String str) {
        return (str == null || str.length() == 0);
    }
	
	public static String osType(){
        String os = System.getProperty("os.name").toLowerCase();
        if(os.indexOf("win") >= 0){
            return "windows";
        }else if(os.indexOf("mac") >= 0){
            return "mac";
        }else if(os.indexOf("nux") >= 0){
            return "linux";
        }else if(os.indexOf("nix") >= 0){
            return "unix";
        }else if(os.indexOf("sunos") >= 0){
            return "solaris";
        }else
        return os;
    }
	
	
	public static List<Map<String,Object>> getJsonToArray(String jsonStr, String[] fields) {

		List<Map<String,Object>> listdata = new ArrayList<Map<String,Object>>();     
		JSONArray jArray = JSONArray.fromObject(jsonStr.toString());
		if (jArray != null) { 
			Map<String,Object> map = null;
		   for (int i=0;i<jArray.size();i++){
			   map = new HashMap<String, Object>();
			   
			   JSONObject json = JSONObject.fromObject(jArray.get(i));
			   
			   for(String s : fields) {
				   map.put(s, json.get(s));
				   
				   
			   }
			   listdata.add(map);
		   } 
		}
		
		return listdata;
		
	}

	public static void main(String[] args) {
		System.out.println(CustStringUtil.amtToStr("123456789"));
	}
	
	public static String amtToStr(String amt)
	{
		String tmpamt ="";
		amt = "000000000000" + amt;
		int j=0;

		for(int i=amt.length();i>0;i--) {
			j++;
		
			if (!amt.substring(i-1,i).equals("0")) {
				if (j%4==2) tmpamt ="십"+tmpamt;
				if (j%4==3) tmpamt ="백"+tmpamt;
				if (j>1 && (j%4)==0) tmpamt ="천"+tmpamt;
			}
		
			if (j==5 && Integer.parseInt(amt.substring(amt.length()-8,amt.length()-4))>0) tmpamt ="만"+tmpamt;
			if (j==9 && Integer.parseInt(amt.substring(amt.length()-12,amt.length()-8))>0) tmpamt ="억"+tmpamt;
			if (j==13 && Integer.parseInt(amt.substring(amt.length()-16,amt.length()-12))>0) tmpamt ="조"+tmpamt;
			
			if (amt.substring(i-1,i).equals("1")) tmpamt ="일"+tmpamt;
			if (amt.substring(i-1,i).equals("2")) tmpamt ="이"+tmpamt;
			if (amt.substring(i-1,i).equals("3")) tmpamt ="삼"+tmpamt;
			if (amt.substring(i-1,i).equals("4")) tmpamt ="사"+tmpamt;
			if (amt.substring(i-1,i).equals("5")) tmpamt ="오"+tmpamt;
			if (amt.substring(i-1,i).equals("6")) tmpamt ="육"+tmpamt;
			if (amt.substring(i-1,i).equals("7")) tmpamt ="칠"+tmpamt;
			if (amt.substring(i-1,i).equals("8")) tmpamt ="팔"+tmpamt;
			if (amt.substring(i-1,i).equals("9")) tmpamt ="구"+tmpamt;
		}
	
		return tmpamt;
	}
}
