package com.duzon.custom.commfile.controller;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.duzon.custom.commfile.service.CommFileService;

@Controller
public class CommFileController {
	private static final Logger logger = LoggerFactory.getLogger(CommFileController.class);
	
	@Resource(name = "CommFileService")
	CommFileService commFileService;
	
	@RequestMapping(value = "/commFile/commFileUpLoad", method = RequestMethod.POST)
	public ModelAndView commFileUpLoad(@RequestParam Map<String, Object> map, MultipartHttpServletRequest multi/*, HttpServletRequest servletRequest*/) {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> resultMap = null;
		try {
			resultMap = commFileService.commFileUpLoad(map, multi);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		mv.addObject("result", resultMap);
		mv.setViewName("jsonView");
		return mv;
	}
	
	/**
	 * loginVO 체크 파일 다운로드(WEB 용)
	 * @param paramMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/commFile/fileDownloadProc.do")
    public void fileDownloadProc(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {

	 	String fullPath = String.valueOf(paramMap.get("path"));
	 	String orignlFileName = "test";
	 			
	 	getCommfileDown(fullPath, orignlFileName, response);
    }
	
	
	/**
	 * 2020. 7. 19.
	 * yh
	 * :공통 파일 어디서 다운받을까
	 * targetTableName
	 * targetId
	 * 단일파일
	 * @throws Exception 
	 */
	@RequestMapping(value = "/commFile/commFileDown", method = RequestMethod.GET)
	public void commFileDown(@RequestParam HashMap<String, Object> map, HttpServletResponse response) throws Exception {
		//단순하가 가자.. 보안은 나중에..
		
		List<Map<String, Object>> list = (List<Map<String, Object>>) commFileService.getAttachFileList(map);
		
		Map<String, Object> file = list.get(0);
		
		String fullPath = String.valueOf(file.get("file_path")) + String.valueOf(file.get("file_name")) + "." + String.valueOf(file.get("file_extension"));
		String fullName = String.valueOf(file.get("real_file_name")) + "." + String.valueOf(file.get("file_extension"));
		
		getCommfileDown(fullPath, fullName, response);
	
	}
	
	
	
	/**
	 * 2020. 7. 19.
	 * yh
	 * :fullPath 전체경로 ex) c:\\upload\\abc.txt
	 * :orignlFileName 파일명 ex) abc.txt
	 */
	private void getCommfileDown(String fullPath, String orignlFileName, HttpServletResponse response) throws Exception{
		
		File file = null;
		FileInputStream fis = null;

		BufferedInputStream in = null;
		ByteArrayOutputStream bStream = null;

		String type = "";
		
		String fileExtsn = fullPath.substring(fullPath.lastIndexOf(".") + 1);
		
		if (fileExtsn != null && !"".equals(fileExtsn)) {
			
			
			if ("jpg".equals(fileExtsn.toLowerCase())) {
				type = "image/jpeg";
			} else {
				type = "image/" + fileExtsn.toLowerCase();
			}
			type = "image/" + fileExtsn.toLowerCase();
			
			
		} else {
			//LOGGER.debug("Image fileType is null.");
		}
		
		
		try {
		    file = new File(fullPath);
		    fis = new FileInputStream(file);

		    in = new BufferedInputStream(fis);
		    bStream = new ByteArrayOutputStream();

		    int imgByte;
		    while ((imgByte = in.read()) != -1) {
		    	bStream.write(imgByte);
		    }

		    String imgExt = "jpeg|bmp|gif|jpg|png";
		    

		    orignlFileName = URLEncoder.encode(orignlFileName, "UTF-8"); 
		    orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해

		    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
		    response.setContentLength(bStream.size());
		    
		    /** 이미지 */
		    if (imgExt.indexOf(fileExtsn) > -1) {
		    	response.setHeader("Content-Type", type);
		    } 
		    /** 일반 */
		    else {
				response.setContentType( "application/x-msdownload" );
				response.setHeader( "Content-Transfer-Coding", "binary" );
		    }


			bStream.writeTo(response.getOutputStream());

			response.getOutputStream().flush();
			response.getOutputStream().close();
			
		} finally {
			if (bStream != null) {
				try {
					bStream.close();
				} catch (Exception ignore) {
				}
			}
			if (in != null) {
				try {
					in.close();
				} catch (Exception ignore) {
				}
			}
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
				}
			}
		}
		
	}
	
	
}
