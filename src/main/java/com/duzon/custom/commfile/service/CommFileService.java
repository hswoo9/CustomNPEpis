package com.duzon.custom.commfile.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface CommFileService {

	Map<String, Object> commFileUpLoad(Map<String, Object> map, MultipartHttpServletRequest multi) throws Exception;

	Object getAttachFileList(HashMap<String, Object> paramMap) throws Exception;

}
