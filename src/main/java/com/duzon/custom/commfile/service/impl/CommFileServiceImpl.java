package com.duzon.custom.commfile.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.commfile.dao.CommFileDAO;
import com.duzon.custom.commfile.service.CommFileService;
import com.duzon.custom.commfile.util.CommFileUtil;

@Service("CommFileService")
public class CommFileServiceImpl implements CommFileService {
	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(CommFileServiceImpl.class);
	
	@Resource(name = "CommFileDAO")
	CommFileDAO commFileDAO;

	@Override
	public Map<String, Object> commFileUpLoad(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 파일 저장 경로
		String path = String.valueOf(map.get("path"));
       	String subPathYn = "Y";
       	String filePath="";

    	if(multi.getServerName().contains("localhost") || multi.getServerName().contains("127.0.0.1")) {
    		 filePath ="C:/Users/dev-jitsu/Desktop/aaa/";
		}else{
			 filePath = CommFileUtil.getFilePath(commFileDAO, path, subPathYn);
		}
       	// 파일 저장 경로
       	
       	ArrayList<Map<String, Object>> commFileList = new ArrayList<Map<String, Object>>();
       	
       	
       	List<MultipartFile> a = multi.getFiles("file_name");
       	for (MultipartFile mFile : a) {
       		String fileName = mFile.getOriginalFilename();
			String fileSize = String.valueOf(mFile.getSize());
			if(fileName.equals("")) { 
//				System.out.println(uploadFile+" is Empty");
			}else{
				map.put("fileSeq", commFileDAO.getCommFileSeq(map));
				commFileDAO.commFileInfoInsert(map);
				
	           	String fileNm = map.get("attach_file_id") +"."+ fileName.substring(fileName.lastIndexOf(".")+1);
	           	int Idx = fileName.lastIndexOf(".");
	           	String _fileName = fileName.substring(0, Idx);
	           	String ext = fileName.substring(fileName.lastIndexOf(".")+1);
//	           	System.out.println(filePath+_fileName+ext);
	           	
	           	// 파일저장
	           	CommFileUtil.makeDir(filePath);	           	
	           	File saveFile = new File(filePath + fileNm);
	           	CommFileUtil.fileWrite(mFile, saveFile);
	           	// 파일저장
	           	
	           	Map<String,Object> returnMap =new HashMap<String, Object>();
	           	
	           	returnMap.put("filePath", filePath);
	           	returnMap.put("fileNm", _fileName);
	           	returnMap.put("ext", ext);
	           	returnMap.put("fileSize", fileSize);
	           	returnMap.put("attach_file_id", map.get("attach_file_id"));
	           	returnMap.put("fileSeq", map.get("fileSeq"));
	           	returnMap.put("path", map.get("path"));
	           	returnMap.put("targetId", map.get("targetId"));
	           	returnMap.put("targetTableName", map.get("targetTableName"));
	           	
	            commFileDAO.commFileInfoUpdate(returnMap);
	            
	            
	            commFileList.add(returnMap);
           }
		}
       	
		/*Iterator<String> files = multi.getFileNames();
		ArrayList<Map<String, Object>> commFileList = new ArrayList<Map<String, Object>>();
		while(files.hasNext()){
			String uploadFile = files.next();
			MultipartFile mFile = multi.getFile(uploadFile);            
			String fileName = mFile.getOriginalFilename();
			String fileSize = String.valueOf(mFile.getSize());
			if(fileName.equals("")) { 
				System.out.println(uploadFile+" is Empty");
			}else{
				map.put("fileSeq", commFileDAO.getCommFileSeq(map));
				commFileDAO.commFileInfoInsert(map);
	           	String fileNm = map.get("attach_file_id") +"."+ fileName.substring(fileName.lastIndexOf(".")+1);
	           	int Idx = fileName.lastIndexOf(".");
	           	String _fileName = fileName.substring(0, Idx);
	           	String ext = fileName.substring(fileName.lastIndexOf(".")+1);
	           	System.out.println(filePath+_fileName+ext);
	           	
	           	// 파일저장
	           	CommFileUtil.makeDir(filePath);	           	
	           	File saveFile = new File(filePath + fileNm);
	           	CommFileUtil.fileWrite(mFile, saveFile);
	           	// 파일저장
	           	
	            map.put("filePath", filePath);
	            map.put("fileNm", _fileName);
	            map.put("ext", ext);
	            map.put("fileSize", fileSize);
	            commFileDAO.commFileInfoUpdate(map);
	            commFileList.add(map);
           }
		}*/
		resultMap.put("commFileList", commFileList);
		return resultMap;
	}

	@Override
	public Object getAttachFileList(HashMap<String, Object> paramMap) throws Exception {
		return commFileDAO.getAttachFileList(paramMap);
	}

}
