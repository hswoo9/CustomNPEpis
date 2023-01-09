package com.duzon.custom.consdocmng.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository("ConsDocMngDAO")
public class ConsDocMngDAO extends AbstractDAO{

	public Object selectConsDocMngList(Map<String, Object> params) throws Exception {
		return selectList("ConsDocMng.selectConsDocMngList", params);
	}

	public Object selectConsDocMngListTotalCount(Map<String, Object> params) throws Exception {
		return selectOne("ConsDocMng.selectConsDocMngListTotalCount", params);
	}

	public Object selectConsDocMngDList(Map<String, Object> params) throws Exception{
		return selectList("ConsDocMng.selectConsDocMngDList", params);
	}

	public Object checkConsBudgetModify(Map<String, Object> params) throws Exception{
		return selectOne("ConsDocMng.checkConsBudgetModify", params);
	}

	public void consBudgetReturn(Map<String, Object> params) throws Exception{
		update("ConsDocMng.consBudgetReturn", params);
	}

	public void consBudgetReturnAmtInsert(Map<String, Object> params) throws Exception {
		insert("ConsDocMng.consBudgetReturnAmtInsert", params);
	}

	public void consHeadInsert(Map<String, Object> params) throws Exception{
		insert("ConsDocMng.consHeadInsert", params);
	}
	
	public void consBudgetInsert(Map<String, Object> params) throws Exception{
		insert("ConsDocMng.consBudgetInsert", params);
	}

	public void consModInsert(Map<String, Object> params) throws Exception{
		insert("ConsDocMng.consModInsert", params);
	}

	public void consModHInsert(Map<String, Object> params) throws Exception{
		insert("ConsDocMng.consModHInsert", params);
	}

	public void consModBInsert(Map<String, Object> params) throws Exception{
		insert("ConsDocMng.consModBInsert", params);
	}

	public void consModHUpdateSeq(Map<String, Object> params) throws Exception{
		update("ConsDocMng.consModHUpdateSeq", params);
	}
	
	public void consModBUpdateSeq(Map<String, Object> params) throws Exception{
		update("ConsDocMng.consModBUpdateSeq", params);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> consModifyEndHListSelect(Map<String, Object> params)throws Exception {
		return selectList("ConsDocMng.consModifyEndHListSelect", params);
		
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> consModifyEndBReturnListSelect(Map<String, Object> params)throws Exception {
		return selectList("ConsDocMng.consModifyEndBReturnListSelect", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> consModifyEndBListSelect(Map<String, Object> params)throws Exception {
		return selectList("ConsDocMng.consModifyEndBListSelect", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> consModifyEndTListSelect(Map<String, Object> params) {
		return selectList("ConsDocMng.consModifyEndTListSelect", params);
	}

	public void consDocModifyEnd(Map<String, Object> params) throws Exception {
		update("ConsDocMng.consDocModifyEnd", params);
	}

	public Object getTreadList(Map<String, Object> params) throws Exception {
		return selectList("ConsDocMng.getTreadList", params);
	}

	public void consModTInsert(Map<String, Object> params) throws Exception {
		insert("ConsDocMng.consModTInsert", params);
	}

	public void consTradeInsert(Map<String, Object> params) throws Exception {
		insert("ConsDocMng.consTradeInsert", params);
	}

	public void consModTUpdateSeq(Map<String, Object> params) throws Exception{
		update("ConsDocMng.consModTUpdateSeq", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> purcContBIdSelect(Map<String, Object> params) {
		return (Map<String, Object>)selectOne("ConsDocMng.purcContBIdSelect", params);
	}
	
	public void purcContBDelete(Map<String, Object> params) throws Exception {
		delete("ConsDocMng.purcContBDelete", params);
	}

	public void purcContBInsert(Map<String, Object> params) throws Exception {
		update("ConsDocMng.purcContBInsert", params);
	}
	
	public void purcContBUpdate(Map<String, Object> params) throws Exception {
		update("ConsDocMng.purcContBUpdate", params);
	}

	public void purcContTDelete(Map<String, Object> params) throws Exception {
		delete("ConsDocMng.purcContTDelete", params);
	}

	public void purcContTInsert(Map<String, Object> params) throws Exception {
		insert("ConsDocMng.purcContTInsert", params);
	}

	public Object checkContract(Map<String, Object> params) {
		return selectOne("ConsDocMng.checkContract", params);
	}

}
