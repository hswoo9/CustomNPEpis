package com.duzon.custom.commfile.util;

import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.web.multipart.MultipartFile;

import com.duzon.custom.commfile.dao.CommFileDAO;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

public class CommFileUtil {
	
	public static String getFilePath(CommFileDAO commFileDAO, String path, String subPathYn) throws Exception {
		LoginVO loginVO = EgovUserDetailsHelper.getAuthenticatedUser();
		String osType = "linux";
		if(System.getProperty("os.name").toLowerCase().contains("windows")){
			osType = "windows";
		}
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", loginVO.getGroupSeq());
		param.put("pathSeq", "0");
		param.put("osType", osType);
    	Map<String, Object> pathMap = commFileDAO.selectGroupPath(param);
    	String filePath = "";
    	
    	if(pathMap==null || pathMap.size() == 0){
    		filePath = File.separator;
	  	 	if(osType.equals("windows")){
	  	 		filePath = "d:\\upload\\";
	  	 	}
    	}else{
    		filePath = pathMap.get("absol_path")+File.separator;
    	}
    	
    	if(path != null && !"".equals(path)) {
    		filePath = filePath+path+File.separator;
    	}
    	
    	if("Y".equals(subPathYn)) {
    		Calendar cal = Calendar.getInstance();
    		String yyyy = String.valueOf(cal.get(Calendar.YEAR));
    		String mm = String.valueOf(cal.get(Calendar.MONTH) + 1);
    		String subPath = yyyy+File.separator+mm;
    		filePath = filePath+subPath+File.separator;
    	}
    	
		return filePath;
	}
	
	public static void fileWrite(MultipartFile mFile, File saveFile) throws Exception {
   		mFile.transferTo(saveFile);
	}
	
	public static void makeDir(String filePath) throws Exception {
		File dir = new File(filePath);
   		if(!dir.isDirectory()){
				dir.mkdirs();
        }
	}
	
	public static void outputStream(HttpServletResponse response,FileInputStream in ) throws Exception {
		ServletOutputStream binaryOut = response.getOutputStream();
		byte buffer[] = new byte[8 * 1024];
		
		try {
			IOUtils.copy(in, binaryOut);
			binaryOut.flush();
		} catch ( Exception e ) {
		} finally {
			if (in != null) {
				try {
				in.close();
				}catch(Exception e ) {}
			}
			if (binaryOut != null) {
				try {
					binaryOut.close();
				}catch(Exception e ) {}
			}
		}	
	}
	
	
	
}
