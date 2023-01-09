package com.duzon.custom.bsrp.service;

import java.util.Map;

public interface BsrpService {

	Map<String, Object> bsrpAdminListSerch(Map<String, Object> map);

	void bsrpAdminSave(Map<String, Object> map);

	void bsrpAdminDel(Map<String, Object> map);

	Map<String, Object> getFareListSearch(Map<String, Object> map);

	void whthrcTrvctSave(Map<String, Object> map);

	Map<String, Object> whthrcTrvctListSerch(Map<String, Object> map);

	void bsrpAdminPositionSave(Map<String, Object> map);

	Map<String, Object> bsrpAdminPositionListSerch(Map<String, Object> map);

	void bsrpAdminPositionDel(Map<String, Object> map);

	void whthrcTrvctApp(Map<String, Object> map);

	void whthrcTrvctAppCancel(Map<String, Object> map);

	void whthrcTrvctCancel(Map<String, Object> map);

	Map<String, Object> getUserPosition(Map<String, Object> map);

	Map<String, Object> getErpToEmpInfo(Map<String, Object> map);

	void bsrpSave(Map<String, Object> map);

	void bsrpApp(Map<String, Object> bodyMap);

	Map<String, Object> bsrpReqstListSerch(Map<String, Object> map);

	Map<String, Object> getBsrpInfo(Map<String, Object> map);

	void bsrpReportSave(Map<String, Object> map);
	
	void bsrpRApp(Map<String, Object> bodyMap);

	Map<String, Object> bsrpStatementListSerch(Map<String, Object> map);

	void paymentDtSave(Map<String, Object> map);

	void bsrpReturn(Map<String, Object> map);
	
	void bsrpReturnCancel(Map<String, Object> map);

	Map<String, Object> getBsrpMileage(Map<String, Object> map);

	Map<String, Object> bsrpMileageListSerch(Map<String, Object> map);

	void bsrpMileageUpdate(Map<String, Object> map);
}
