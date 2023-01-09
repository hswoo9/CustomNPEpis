package main.web;

import java.util.Locale;

import org.springframework.context.NoSuchMessageException;
import org.springframework.context.support.MessageSourceAccessor;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

public class BizboxAMessage {

	private static MessageSourceAccessor msAcc = null;
	
	
	public void setMessageSourceAccessor(MessageSourceAccessor msAcc){
		BizboxAMessage.msAcc = msAcc;
	}
	
	public static String getMessage(String key, String defaultStr){
		
		String returnStr = defaultStr;
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String langCode = (loginVO == null ? "kr" : loginVO.getLangCode());
		
		try{
				
			
			
			if("kr".equals(langCode)){
				Locale.setDefault(Locale.KOREA);
				//defaultLocale = "ko_KR";
			}else if("en".equals(langCode)){
				Locale.setDefault(Locale.US);
				//defaultLocale = "en_US";
			}else if("jp".equals(langCode)){
				Locale.setDefault(Locale.JAPAN);
				//defaultLocale = "ja_JP";
			}else if("cn".equals(langCode)){
				Locale.setDefault(Locale.CHINA);
				//defaultLocale = "zh_CN";
			}else{
				Locale.setDefault(Locale.KOREA);
				//defaultLocale = "ko_KR";
			}
			
			/*if(loginVO.getGroupSeq().equals("dev")){
				//영어 테스트
				Locale.setDefault(Locale.US);
			}*/
				
			if(msAcc.getMessage(key, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
				if(Locale.getDefault().equals("ko_KR")){
					returnStr = defaultStr;
				}else{
					Locale.setDefault(Locale.KOREA);
					if(msAcc.getMessage(key, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
						returnStr = defaultStr;
					}else{
						returnStr = msAcc.getMessage(key, Locale.getDefault());
					}
				}
			}else{
				returnStr = msAcc.getMessage(key, Locale.getDefault());
			}
		
		}catch(NullPointerException ne){
			return defaultStr;
		}catch(NoSuchMessageException ne){
			return defaultStr;
		}
		
		return returnStr.replaceAll("\r\n", " ");
	}
	
	public static String getMessage(String key, Object[] objs, String defaultStr){
		
		String returnStr = defaultStr;
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		String langCode = (loginVO == null ? "kr" : loginVO.getLangCode());
		
		try{
					
			if("kr".equals(langCode)){
				Locale.setDefault(Locale.KOREA);
			}else if("en".equals(langCode)){
				Locale.setDefault(Locale.US);
			}else if("jp".equals(langCode)){
				Locale.setDefault(Locale.JAPAN);
			}else if("cn".equals(langCode)){
				Locale.setDefault(Locale.CHINA);
			}else{
				Locale.setDefault(Locale.KOREA);
			}
			
			/*if(loginVO.getGroupSeq().equals("dev")){
				//영어 테스트
				Locale.setDefault(Locale.US);
			}*/
			
				
			if(msAcc.getMessage(key, objs, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
				if(Locale.getDefault().equals("ko_KR")){
					returnStr = defaultStr;
				}else{
					Locale.setDefault(Locale.KOREA);
					if(msAcc.getMessage(key, objs, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
						returnStr = defaultStr;
					}else{
						returnStr = msAcc.getMessage(key, objs, Locale.getDefault());
					}
				}
			}else{
				returnStr = msAcc.getMessage(key, objs, Locale.getDefault());
			}
			
		}catch(NullPointerException ne){
			return defaultStr;
		}catch(NoSuchMessageException ne){
			return defaultStr;
		}
		
		return returnStr.replaceAll("\r\n", " ");
	}
	
	public static String getMessage(String key, String defaultStr, String getLangCode){
		
		String returnStr = defaultStr;
		String langCode = "";
		
		try{
				
			if(getLangCode == null || "".equals(getLangCode)){
				langCode = "kr";
			}else{
				langCode = getLangCode;
			}
			 
			
			if("kr".equals(langCode)){
				Locale.setDefault(Locale.KOREA);
				//defaultLocale = "ko_KR";
			}else if("en".equals(langCode)){
				Locale.setDefault(Locale.US);
				//defaultLocale = "en_US";
			}else if("jp".equals(langCode)){
				Locale.setDefault(Locale.JAPAN);
				//defaultLocale = "ja_JP";
			}else if("cn".equals(langCode)){
				Locale.setDefault(Locale.CHINA);
				//defaultLocale = "zh_CN";
			}else{
				Locale.setDefault(Locale.KOREA);
				//defaultLocale = "ko_KR";
			}
			
			/*if(loginVO.getGroupSeq().equals("dev")){
				//영어 테스트
				Locale.setDefault(Locale.US);
			}*/
				
			if(msAcc.getMessage(key, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
				if(Locale.getDefault().equals("ko_KR")){
					returnStr = defaultStr;
				}else{
					Locale.setDefault(Locale.KOREA);
					if(msAcc.getMessage(key, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
						returnStr = defaultStr;
					}else{
						returnStr = msAcc.getMessage(key, Locale.getDefault());
					}
				}
			}else{
				returnStr = msAcc.getMessage(key, Locale.getDefault());
			}
		
		}catch(NullPointerException ne){
			return defaultStr;
		}catch(NoSuchMessageException ne){
			return defaultStr;
		}
		
		return returnStr.replaceAll("\r\n", " ");
	}
	
	public static String getMessage(String key, Object[] objs, String defaultStr, String getLangCode){
		
		String returnStr = defaultStr;
		String langCode = "";
		
		try{
		
			if(getLangCode == null || "".equals(getLangCode)){
				langCode = "kr";
			}else{
				langCode = getLangCode;
			}
			
			if("kr".equals(langCode)){
				Locale.setDefault(Locale.KOREA);
			}else if("en".equals(langCode)){
				Locale.setDefault(Locale.US);
			}else if("jp".equals(langCode)){
				Locale.setDefault(Locale.JAPAN);
			}else if("cn".equals(langCode)){
				Locale.setDefault(Locale.CHINA);
			}else{
				Locale.setDefault(Locale.KOREA);
			}
			
			/*if(loginVO.getGroupSeq().equals("dev")){
				//영어 테스트
				Locale.setDefault(Locale.US);
			}*/
			
				
			if(msAcc.getMessage(key, objs, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
				if(Locale.getDefault().equals("ko_KR")){
					returnStr = defaultStr;
				}else{
					Locale.setDefault(Locale.KOREA);
					if(msAcc.getMessage(key, objs, Locale.getDefault()) == null || "".equals(msAcc.getMessage(key, Locale.getDefault()))){
						returnStr = defaultStr;
					}else{
						returnStr = msAcc.getMessage(key, objs, Locale.getDefault());
					}
				}
			}else{
				returnStr = msAcc.getMessage(key, objs, Locale.getDefault());
			}
			
		}catch(NullPointerException ne){
			return defaultStr;
		}catch(NoSuchMessageException ne){
			return defaultStr;
		}
		
		return returnStr.replaceAll("\r\n", " ");
	}
	
}
