package com.duzon.custom.outprocess.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository("OutProcessDAO")
public class OutProcessDAO extends AbstractDAO {

	public void outProcessApp(Map<String, Object> bodyMap) throws Exception {
		insert("OutProcess.outProcessApp",bodyMap);
	}

	public Object outProcessDocSts(Map<String, Object> map) throws Exception {
		return selectOne("OutProcess.outProcessDocSts", map);
	}

	public void outProcessTempInsert(Map<String, Object> map) throws Exception {
		insert("OutProcess.outProcessTempInsert",map);
	}
	
	public void outProcessDocInterlockInsert(Map<String, Object> map) throws Exception {
		insert("OutProcess.outProcessDocInterlockInsert",map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> outProcessSel(Map<String, Object> map) throws Exception {
		return (Map<String, Object>)selectOne("OutProcess.outProcessSel", map);
	}

}
