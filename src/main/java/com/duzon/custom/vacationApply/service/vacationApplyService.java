package com.duzon.custom.vacationApply.service;

import java.util.List;
import java.util.Map;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface vacationApplyService {
	
	public List<Map<String, Object>> viewUserInfo(Object viewUserInfo);
	
	/**
	 * @MethodName : codeList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드등록 리스트
	 */
	public Map<String, Object> codeList( Map<String, Object> map);
	
	/**
	 * @MethodName : codeDuplChk
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드중복체크
	 */
	public boolean codeDuplChk( Map<String, Object> map);
	
	/**
	 * @MethodName : codeAdd
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드등록
	 */
	public void codeAdd( Map<String, Object> map);
	
	/**
	 * @MethodName : codeDelete
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드삭제
	 */
	public void codeDelete( Map<String, Object> map);
	
	/**
	 * @MethodName : ccDetailList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조사유형별 리스트 조회
	 */
	public Map<String, Object> ccDetailList( Map<String, Object> map);
	
	/**
	 * @MethodName : spDetailList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 학자금유형별 리스트 조회
	 */
	public Map<String, Object> spDetailList( Map<String, Object> map);
	
	/**
	 * @MethodName : ccDetailRegister
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세등록
	 */
	public void ccDetailRegister( Map<String, Object> map);
	
	/**
	 * @MethodName : ccDetailModify
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세수정
	 */
	public void ccDetailModify( Map<String, Object> map);
	
	/**
	 * @MethodName : ccDetailDelete
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세삭제
	 */
	public void ccDetailDelete( Map<String, Object> map);
	
	/**
	 * @MethodName : spDetailRegister
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세등록
	 */
	public void spDetailRegister( Map<String, Object> map);
	
	/**
	 * @MethodName : spDetailModify
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세수정
	 */
	public void spDetailModify( Map<String, Object> map);
	
	/**
	 * @MethodName : spDetailDelete
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세삭제
	 */
	public void spDetailDelete( Map<String, Object> map);
	
	/**
	 * @MethodName : ccApplyList
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조신청 리스트
	 */
	public Map<String, Object> ccApplyList( Map<String, Object> map);
	
	/**
	 * @MethodName : ccApplySave
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조금신청 저장
	 */
	public Map<String, Object> ccApplySave( Map<String, Object> map);
	
	/**
	 * @MethodName : ccApplyDeleteRow
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조사신청삭제
	 */
	public void ccApplyDeleteRow( Map<String, Object> map);
	
	/**
	 * @MethodName : scholarApplyList
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청 리스트
	 */
	public Map<String, Object> scholarApplyList( Map<String, Object> map);
	
	/**
	 * @MethodName : scholarApplyDetailList
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청상세 리스트
	 */
	public Map<String, Object> scholarApplyDetailList( Map<String, Object> map);
	
	/**
	 * @MethodName : scholarDetailList
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 등록학자금 리스트 조회
	 */
	public Map<String, Object> scholarDetailList( Map<String, Object> map);
	
	/**
	 * @MethodName : scholarApplySave
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 학자금신청 저장
	 */
	public Map<String, Object> scholarApplySave( Map<String, Object> map);
	
	/**
	 * @MethodName : scholarApplyDeleteRow
	 * @author : doxx
	 * @since : 2019. 6. 1
	 * 설명 : 학자금신청삭제
	 */
	public void scholarApplyDeleteRow( Map<String, Object> map);
	
	public Map<String, Object> scholarApprovalUpdate( Map<String, Object> map);
	public Map<String, Object> scholarApprovalCancle( Map<String, Object> map);
	public Map<String, Object> scholarApplyFileSave(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception;
	/**
	 * @MethodName : getClubListOperated
	 * @author : doxx
	 * @since : 2020. 3. 15
	 * 설명 : 교양부서 리스트 조회
	 */
	public Map<String, Object> getClubListOperated( Map<String, Object> map);
	public Map<String, Object> getClubMemberList( Map<String, Object> map);
	
	/**
	 * @MethodName : clubSave
	 * @author : doxx
	 * @since : 2020. 3. 15
	 * 설명 : 교양부서 저장
	 */
	public Map<String, Object> clubSave( Map<String, Object> map);
	public Map<String, Object> clubDetailSaveInsert( Map<String, Object> map);
	
	/**
	 * @MethodName : getMedicalSubsidyApplyList
	 * @author : doxx
	 * @since : 2020. 3. 16
	 * 설명 : 의료비보조금 리스트 조회
	 */
	public Map<String, Object> getMedicalSubsidyApplyList( Map<String, Object> map);
	
	public Map<String, Object> medicalSubsidyApply(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception;
	
	public Map<String, Object> medicalApprovalUpdate( Map<String, Object> map);

	public void clubRegisterApproval(Map<String, Object> map);
	
	public void updateClubDetailStatus(Map<String, Object> map);
	
	public int fileUploadService(int fileSeq, MultipartFile mFile, Map<String, Object> map) throws Exception;
	
	public void medicalSubsidyDeleteRow( Map<String, Object> map);
	
	public Map<String, Object> medicalApprovalCancle( Map<String, Object> map);
	
	public Map<String, Object> famliyApplyList( Map<String, Object> map);
	
	public Map<String, Object> famliyApplySave( Map<String, Object> map);
	
	public Map<String, Object> famliyApplyFileSave(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception;
	
	public Map<String, Object> familyApplyDetailList( Map<String, Object> map);
	
	public void familyApplyDeleteRow( Map<String, Object> map);
	
	public Map<String, Object> familyApprovalUpdate( Map<String, Object> map);
	
	public Map<String, Object> benefitSave( Map<String, Object> map);
	
	public Map<String, Object> benefitList( Map<String, Object> map);
	
	public Map<String, Object> benefitDetailList( Map<String, Object> map);
	
	public Map<String, Object> getBenefitTypeList( Map<String, Object> map);
	
	public Map<String, Object> getScholarshipManageList( Map<String, Object> map);
	
	public Map<String, Object> welfareApplyList( Map<String, Object> map);
	
	public Map<String, Object> welfareApplySave( Map<String, Object> map);
	
	public Map<String, Object> welfareApplyFileSave(Map<String, Object> map, MultipartHttpServletRequest multi, Model model) throws Exception;
	
	public Map<String, Object> welfareApplyDetailList( Map<String, Object> map);
	
	public void welfareApplyDeleteRow( Map<String, Object> map);
	
	public Map<String, Object> welfareApprovalUpdate( Map<String, Object> map);
	
	public void familyBenefitMonthBatch();
	
	public void welfareBenefitMonthBatch();
	
	
	
	
}
