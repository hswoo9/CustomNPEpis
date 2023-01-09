package com.duzon.custom.common.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.dzcl.common.util.PageInfo;

/**
 * 공통 DAO
 * 필요에 따라 method 추가 가능.
 * @author iguns
 *
 */
@Repository("CommonDAO")
public class CommonDAO extends AbstractDAO{

	public Map<String,Object> selectListPage(String queryId, Map<String,Object> params, PageInfo page){
        
				
		printQueryId(queryId);
		
		String tc = sqlSession.selectOne(queryId+"_TC", params);
		
		page.setTotalCount(tc);
		
		params.put("startIdx", page.getStartIdx());
		params.put("endIdx", page.getEndIdx());
		
		List list = sqlSession.selectList(queryId, params);
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("totalCount", tc);
		resultMap.put("list", list);
        
        return resultMap;
    }
	
	/**
	 * @MethodName : getCode
	 * @author : gato
	 * @since : 2018. 1. 5.
	 * 설명 : 공통코드 조회
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCode(Map<String, String> map) {
		return selectList("common.getCode", map);
	}
	/**
	 * @MethodName : getDept
	 * @author : gato
	 * @since : 2018. 1. 8.
	 * 설명 : 부서명 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getDept(String empSeq) {
		return (Map<String, Object>) selectOne("common.getDept", empSeq);
	}
	/**
		 * @MethodName : getEmpName
		 * @author : gato
		 * @since : 2018. 1. 15.
		 * 설명 : 사원이름조회
		 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getEmpName(String empSeq) {
		return (Map<String, Object>) selectOne("common.getEmpName", empSeq);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCommNm(String code) {
		return (Map<String, Object>) selectOne("common.getCommNm", code);
	}
	@SuppressWarnings("unchecked")
	public Map<String, Object> getCodeOne(Map<String, String> map) {
		return (Map<String, Object>) selectOne("common.getCodeOne", map);
	}
	/**
		 * @MethodName : empInformation
		 * @author : gato
		 * @since : 2018. 1. 23.
		 * 설명 : 사원 선택 팝업
		 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> empInformation(Map<String, Object> map) {
		return selectList("common.empInformation", map);
	}

	public int empInformationTotal(Map<String, Object> map) {
		return (int) selectOne("common.empInformationTotal",map);
	}
	/**
		 * @MethodName : getHoliday
		 * @author : gato
		 * @since : 2018. 1. 24.
		 * 설명 : 휴무일자 가져오기
		 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getHoliday() {
		return (Map<String, Object>) selectOne("common.getHoliday");
	}
	/**
		 * @MethodName : getAllDept
		 * @author : gato
		 * @since : 2018. 2. 6.
		 * 설명 : 모든부서 가져오기
		 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllDept() {
		return selectList("common.getAllDept");
	}
	/**
		 * @MethodName : getUpDept
		 * @author : gato
		 * @since : 2018. 2. 6.
		 * 설명 : 부장, 본부장 가져오기
		 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getUpDept(String deptSeq) {
		return selectList("common.getUpDept", deptSeq);
	}
	/**
		 * @MethodName : getDeptSeq
		 * @author : gato
		 * @since : 2018. 2. 6.
		 * 설명 : 사원정보 가져오기
		 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getUserInfo(String targetSeq) {
		return (Map<String, Object>) selectOne("common.getUserInfo", targetSeq);
	}
	
	/**
		 * @MethodName : getGroupCd
		 * @author : gato
		 * @since : 2018. 2. 26.
		 * 설명 : 공통코드 그룹코드 셀렉트 박스
		 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getGroupCd(Map<String, Object> map) {
		return selectList("common.getGroupCd", map);
	}

	public int getFileSeq(Map<String, Object> map) {
		
		return (int) selectOne("common.getFileSeq", map);
		
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectEmp(Map<String, Object> map) {
		return selectList("common.selectEmp", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDutyPosition(String subKey) {
		return selectList("common.getDutyPosition", subKey);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDeptList(String subKey) {
		return selectList("common.getDeptList", subKey);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEmpDept(String deptSeq) {
		return selectList("common.getEmpDept", deptSeq);
	}
	
	/**
	 * @MethodName : fileList
	 * @author : gato
	 * @since : 2018. 1. 8.
	 * 설명 : 첨부파일 목록 가져오기
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> fileList(Map<String, Object> map) {
		return selectList("common.fileList",map);
	}

	/**
	 * @MethodName : fileDown
	 * @author : gato
	 * @since : 2018. 1. 9.
	 * 설명 : 파일 다운로드
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> fileDown(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("common.fileDown", map);
	}

	public void fileDelete(Map<String, Object> map) {
		delete("common.fileDelete", map);
		
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getRestFund(String empSeq) {
		return (Map<String, Object>) selectOne("common.getRestFund", empSeq);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEmpInfo(String empSeq) {
		return (Map<String, Object>) selectOne("common.getEmpInfo", empSeq);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEmpInfoByName(Map<String, Object> empInfo) {
		return (Map<String, Object>) selectOne("common.getEmpInfoByName", empInfo);
	}

	/**
		 * @MethodName : getEmpSeq
		 * @author : gato
		 * @since : 2018. 4. 18.
		 * 설명 : ERP 사번으로 gw emp_seq 찾기
		 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getEmpSeq(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("common.getEmpSeq", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getFingerBase64(String empSeq) {
		return (Map<String, Object>) selectOne("common.getFingerBase64", empSeq);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getSignFile(Map<String, Object> signMap) {
		return (Map<String, Object>) selectOne("common.getSignFile", signMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCeoSignFile(Map<String, Object> signMap) {
		return (Map<String, Object>) selectOne("common.getCeoSignFile", signMap);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCompInfo() {
		return (Map<String, Object>) selectOne("common.getCompInfo");
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getContractDn(String empSeq) {
		return (Map<String, Object>) selectOne("common.getContractDn", empSeq);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getHeader(String empSeq) {
		return (Map<String, Object>) selectOne("common.getHeader", empSeq);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getRecordsDept() {
		return selectList("common.getRecordsDept");
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getTpfUserInfo(String key) {
		return (Map<String, Object>) selectOne("common.getTpfUserInfo", key);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCalendarEmpInfo(String empSeq) {
		return (Map<String, Object>) selectOne("common.getCalendarEmpInfo", empSeq);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCalendarDelEmpInfo(String userId) {
		return (Map<String, Object>) selectOne("common.getCalendarDelEmpInfo", userId);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> fileInfo(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("common.fileInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getUserList(Map<String, Object> map) {
		return selectList("common.getUserList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDeptList2(Map<String, Object> map) {
		return selectList("common.getDeptList2", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getProjectList(Map<String, Object> map) {
		return selectListMs("common.getProjectList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBudgetList(Map<String, Object> map) {
		return selectListMs("common.getBudgetList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBudgetList2(Map<String, Object> map) {
		return selectListMs("common.getBudgetList2", map);
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, String> getErpGISU(Map<String, Object> map) {
		return (HashMap<String, String>) selectOneMs("common.getErpGisuInfo", map);
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, String> getErpUser(Map<String, Object> map) {
		return (HashMap<String, String>) selectOneMs("common.getErpUser", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPositionList(Map<String, Object> map) {
		return selectList("common.getPositionList", map);
	}

	public void monthlyWorkPlanMake(Map<String, Object> map) {
		update("common.monthlyWorkPlanMake", map);
		
	}

	public void dailyWorkAgree(Map<String, Object> map) {
		update("common.dailyWorkAgree", map);
		
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> ctDept() {
		return selectList("common.ctDept");
	}

	public void setSmsMaster(Map<String, Object>param) {
		insert("common.setSmsMaster", param);
	}
	public void setSmsSub(List<Map<String, Object>> list) {
		insert("common.setSmsSub", list);
	}
	public void updateSmsSubPk(Map<String, Object> map) {
		update("common.updateSmsSubPk", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBankCode() {
		return selectListMs("common.getBankCode");
	}
	
}
