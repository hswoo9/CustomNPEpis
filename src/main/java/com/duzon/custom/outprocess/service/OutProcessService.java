package com.duzon.custom.outprocess.service;

import java.util.Map;

public interface OutProcessService {

	void outProcessApp(Map<String, Object> bodyMap) throws Exception;

	Object outProcessDocSts(Map<String, Object> map) throws Exception;

	void outProcessTempInsert(Map<String, Object> map) throws Exception;

	Map<String, Object> outProcessSel(Map<String, Object> map) throws Exception;
	
	String makeFileKey(Map<String, Object> map) throws Exception;

	Object makeEncFileKey(Map<String, Object> map) throws Exception;

	void outProcessDocInterlockInsert(Map<String, Object> map) throws Exception;
}
