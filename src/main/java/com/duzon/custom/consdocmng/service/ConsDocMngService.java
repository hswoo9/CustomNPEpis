package com.duzon.custom.consdocmng.service;

import java.util.Map;

public interface ConsDocMngService {

	Object selectConsDocMngList(Map<String, Object> params) throws Exception;

	Object selectConsDocMngListTotalCount(Map<String, Object> params) throws Exception;

	Object selectConsDocMngDList(Map<String, Object> params) throws Exception;

	Object checkConsBudgetModify(Map<String, Object> params) throws Exception;

	Object consDocModify(Map<String, Object> params) throws Exception;

	Object getTreadList(Map<String, Object> params) throws Exception;

	void consDocModifyEnd(Map<String, Object> params) throws Exception;

	Object checkContract(Map<String, Object> params) throws Exception;

}
