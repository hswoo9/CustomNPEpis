package com.duzon.custom.bsrp.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class BsrpDAO extends AbstractDAO {

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> bsrpAdminListSerch(Map<String, Object> map) {
		return selectList("bsrp.bsrpAdminListSerch", map);
	}

	public int bsrpAdminListSerchTotal(Map<String, Object> map) {
		return (int) selectOne("bsrp.bsrpAdminListSerchTotal", map);
	}

	public void bsrpAdminSave(Map<String, Object> map) {
		insert("bsrp.bsrpAdminSave", map);
	}

	public void bsrpAdminUpdate(Map<String, Object> map) {
		update("bsrp.bsrpAdminUpdate", map);
	}

	public void bsrpAdminDel(Map<String, Object> map) {
		update("bsrp.bsrpAdminDel", map);
	}

	public void whthrcTrvctSave(Map<String, Object> map) {
		insert("bsrp.whthrcTrvctSave", map);
	}

	public void whthrcTrvctUpdate(Map<String, Object> map) {
		update("bsrp.whthrcTrvctUpdate", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> whthrcTrvctListSerch(Map<String, Object> map) {
		return selectList("bsrp.whthrcTrvctListSerch", map);
	}

	public int whthrcTrvctListSerchTotal(Map<String, Object> map) {
		return (int) selectOne("bsrp.whthrcTrvctListSerchTotal", map);
	}

	public void bsrpAdminPositionSave(Map<String, Object> map) {
		insert("bsrp.bsrpAdminPositionSave", map);
	}

	public void positionSave(Map<String, Object> map) {
		insert("bsrp.positionSave", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> bsrpAdminPositionListSerch(Map<String, Object> map) {
		return selectList("bsrp.bsrpAdminPositionListSerch", map);
	}

	public int bsrpAdminPositionListSerchTotal(Map<String, Object> map) {
		return (int) selectOne("bsrp.bsrpAdminPositionListSerchTotal", map);
	}

	public void bsrpAdminPositionUpdate(Map<String, Object> map) {
		update("bsrp.bsrpAdminPositionUpdate", map);
	}

	public void positionDel(Map<String, Object> map) {
		update("bsrp.positionDel", map);
	}

	public void bsrpAdminPositionDel1(Map<String, Object> map) {
		update("bsrp.bsrpAdminPositionDel1", map);
	}

	public void bsrpAdminPositionDel2(Map<String, Object> map) {
		update("bsrp.bsrpAdminPositionDel2", map);
	}

	public void whthrcTrvctApp(Map<String, Object> map) {
		update("bsrp.whthrcTrvctApp", map);
	}

	public void whthrcTrvctAppCancel(Map<String, Object> map) {
		update("bsrp.whthrcTrvctAppCancel", map);		
	}

	public void whthrcTrvctCancel(Map<String, Object> map) {
		update("bsrp.whthrcTrvctCancel", map);		
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getUserPosition(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("bsrp.getUserPosition", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getUserPositionEmp(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("bsrp.getUserPositionEmp", map);
	}

	public void bsrpSave(Map<String, Object> map) {
			insert("bsrp.bsrpSave", map);
	}

	public void bsrpApp(Map<String, Object> bodyMap) {
		update("bsrp.bsrpApp", bodyMap);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> bsrpReqstListSerch(Map<String, Object> map) {
		return selectList("bsrp.bsrpReqstListSerch", map);
	}

	public int bsrpReqstListSerchTotal(Map<String, Object> map) {
		return (int) selectOne("bsrp.bsrpReqstListSerchTotal", map);
	}

	public Object getBsrpInfo(Map<String, Object> map) {
		return selectOne("bsrp.getBsrpInfo", map);
	}

	public void bsrpReportSave(Map<String, Object> map) {
		update("bsrp.bsrpReportSave", map);
	}

	public void bsrpRApp(Map<String, Object> bodyMap) {
		update("bsrp.bsrpRApp", bodyMap);
	}

	public void docIdUpdate(Map<String, Object> bodyMap) {
		update("bsrp.docIdUpdate", bodyMap);
	}

	public void abdocu_b_update(Map<String, Object> report_json) {
		update("bsrp.abdocu_b_update", report_json);
	}

	public void abdocu_t_update(Map<String, Object> report_json) {
		update("bsrp.abdocu_t_update", report_json);
	}

	public Object bsrpStatementListSerch(Map<String, Object> map) {
		return selectList("bsrp.bsrpStatementListSerch", map);
	}

	public Object bsrpStatementListSerchTotal(Map<String, Object> map) {
		return (int) selectOne("bsrp.bsrpStatementListSerchTotal", map);
	}

	public void paymentDtSave(Map<String, Object> map) {
		update("bsrp.paymentDtSave", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getErpGwLink(Map<String, Object> map) {
		return (Map<String, Object>)selectOne("bsrp.getErpGwLink", map);
	}

	public void bsrpReturn(Map<String, Object> map) {
		update("bsrp.bsrpReturn", map);
	}

	public void erpgwlinkDel(Map<String, Object> tempObj) {
		delete("bsrp.erpgwlinkDel", tempObj);
	}
	
	public String getReturnJson(Map<String, Object> map) {
		return (String)selectOne("bsrp.getReturnJson", map);
	}
	
	public void bsrpReturnCancel(Map<String, Object> map) {
		update("bsrp.bsrpReturnCancel", map);
	}

	public void erpgwlinkInsert(Map<String, Object> tempObj) {
		insert("bsrp.erpgwlinkInsert", tempObj);
	}

	public Object getBsrpMileage(Map<String, Object> map) {
		return selectOne("bsrp.getBsrpMileage", map);
	}

	public void bsrpMileageSave(Map<String, Object> map) {
		insert("bsrp.bsrpMileageSave", map);
	}

	public void bsrpMileageActive(Map<String, Object> map) {
		update("bsrp.bsrpMileageActive", map);
	}

	public void bsrpMileageDel(Map<String, Object> map) {
		delete("bsrp.bsrpMileageDel", map);
	}

	public Object getBsrpMileageInfo(Map<String, Object> map) {
		return selectOne("bsrp.getBsrpMileageInfo", map);
	}
	
	public String getMileageJson(Map<String, Object> map) {
		return (String)selectOne("bsrp.getMileageJson", map);
	}

	public Object bsrpMileageListSerch(Map<String, Object> map) {
		return selectList("bsrp.bsrpMileageListSerch", map);
	}
	
	public Object bsrpMileageListSerchTotal(Map<String, Object> map) {
		return selectOne("bsrp.bsrpMileageListSerchTotal", map);
	}

	public void bsrpMileageUpdate(Map<String, Object> map) {
		update("bsrp.bsrpMileageUpdate", map);
	}
}
