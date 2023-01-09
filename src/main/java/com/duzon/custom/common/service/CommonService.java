package com.duzon.custom.common.service;

import java.util.List;
import java.util.Map;

import javax.naming.NoPermissionException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface CommonService {

	void ctFileUpLoad(Map<String, Object> map, MultipartHttpServletRequest multi);

	/**
	 * @MethodName : commonGetEmpInfo
	 * @author : gato
	 * @since : 2018. 1. 5.
	 * 설명 : 로그인 세션 정보 가져오기
	 */
	Map<String, Object> commonGetEmpInfo(HttpServletRequest servletRequest) throws NoPermissionException;
	
	/**
	 * @MethodName : getCode
	 * @author : gato
	 * @since : 2018. 1. 5.
	 * 설명 : 공통코드 가져오기
	 */
	List<Map<String, Object>> getCode(String code, String orderby);

	Map<String, Object> getDept(String empSeq);

	void fileDownLoad(String fileNm, String path, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	void fileDown2(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) throws Exception;

	Map<String, Object> getEmpName(String empSeq);

	Map<String, Object> getCommNm(String code);

	Map<String, Object> getCodeOne(String groupCode, String code);

	List<Map<String, Object>> empInformation(Map<String, Object> map);

	int empInformationTotal(Map<String, Object> map);

	Map<String, Object> getHoliday();

	List<Map<String, Object>> getAllDept();

	List<Map<String, Object>> getUpDept(String deptSeq);

	Map<String, Object> getUserInfo(String targetSeq);

	List<Map<String, Object>> getGroupCd(Map<String, Object> map);

	List<Map<String, Object>> selectEmp(Map<String, Object> map);

	List<Map<String, Object>> getDutyPosition(String subKey);

	List<Map<String, Object>> getDeptList(String subKey);

	List<Map<String, Object>> getEmpDept(String deptSeq);

	/**
	 * @MethodName : systemFileList
	 * @author : gato
	 * @since : 2018. 1. 8.
	 * 설명 : 첨부파일 목록 가져오기
	 */
	List<Map<String, Object>> fileList(Map<String, Object> map);

	/**
	 * @MethodName : fileDown
	 * @author : gato
	 * @since : 2018. 1. 9.
	 * 설명 : 파일 다운로드
	 */
	void fileDown(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response);

	void fileDelete(Map<String, Object> map);

	Map<String, Object> getRestFund(String empSeq);

	Map<String, Object> getEmpInfo(String empSeq);

	Map<String, Object> getEmpInfoByName(Map<String, Object> empInfo);

	Map<String, Object> getEmpSeq(Map<String, Object> map);

	Map<String, Object> getFingerBase64(String loginID);

	Map<String, Object> getSignFile(Map<String, Object> signMap);

	Map<String, Object> getCeoSignFile(Map<String, Object> signMap);

	Map<String, Object> getCompInfo();

	Map<String, Object> getContractDn(String empSeq);

	Map<String, Object> getHeader(String empSeq);

	List<Map<String, Object>> getRecordsDept();

	Map<String, Object> getTpfUserInfo(String key);

	Map<String, Object> getCalendarEmpInfo(String empSeq);

	Map<String, Object> getCalendarDelEmpInfo(String userId);

	Map<String, Object> fileInfo(Map<String, Object> map);
	
	Map<String, Object> getUserList(Map<String, Object> map);
	
	Map<String, Object> getDeptList2(Map<String, Object> map);

	Map<String, Object> getProjectList(Map<String, Object> map);
	
	Map<String, Object> getBudgetList(Map<String, Object> map);
	
	Map<String, Object> getBudgetList2(Map<String, Object> map);

	Map<String, Object> getErpUserInfo(Map<String, Object> map);

	Map<String, Object> getPosition(Map<String, Object> map);

	void monthlyWorkPlanMake(Map<String, Object> map);

	void dailyWorkAgree(Map<String, Object> map);

	String ctDept(String string);
	
	void sendSmsByBizTongAgent(String title, String content, List<String> numberArray);

	List<Map<String, Object>> getBankCode();
}
