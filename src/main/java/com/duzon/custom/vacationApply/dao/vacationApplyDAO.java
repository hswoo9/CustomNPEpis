package com.duzon.custom.vacationApply.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;

@Repository
public class vacationApplyDAO extends AbstractDAO{
	
	public List<Map<String, Object>> viewUserInfo(Object viewUserInfo){
		return selectList("vacationApply.viewUserInfo", viewUserInfo);
	}
	
	/**
	 * @MethodName : codeList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드등록 리스트
	 */
	public List<Map<String, Object>> codeList(Map<String, Object> map){
		
		return selectList("vacationApply.codeList", map);
	}
	
	/**
	 * @MethodName : codeListTotal
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드등록 리스트 토탈
	 */
	public int codeListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.codeListTotal", map);
	}
	
	/**
	 * @MethodName : codeDuplChk
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 코드중복체크
	 */
	public int codeDuplChk(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.codeDuplChk", map);
	}
	
	/**
	 * @MethodName : codeCCRegister
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조내역코드생성
	 */
	public void codeCCRegister(Map<String, Object> map) {
		
		insert("vacationApply.codeCCRegister", map);
		
	}
	
	/**
	 * @MethodName : codeRPRegister
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 관계코드생성
	 */
	public void codeRPRegister(Map<String, Object> map) {
		
		insert("vacationApply.codeRPRegister", map);
		
	}
	
	/**
	 * @MethodName : codeCCDelete
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조내역코드삭제
	 */
	public void codeCCDelete(Map<String, Object> map) {
		
		update("vacationApply.codeCCDelete", map);
		
	}
	
	/**
	 * @MethodName : codeRPDelete
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 관계코드삭제
	 */
	public void codeRPDelete(Map<String, Object> map) {
		
		update("vacationApply.codeRPDelete", map);
		
	}
	
	/**
	 * @MethodName : codeSCHDelete
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 학자금유형코드삭제
	 */
	public void codeSCHDelete(Map<String, Object> map) {
		
		update("vacationApply.codeSCHDelete", map);
		
	}
	
	/**
	 * @MethodName : codeCFDelete
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 학자금구분코드삭제
	 */
	public void codeCFDelete(Map<String, Object> map) {
		
		update("vacationApply.codeCFDelete", map);
		
	}
	
	/**
	 * @MethodName : ccDetailList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조사유형별 리스트 조회
	 */
	public List<Map<String, Object>> ccDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.ccDetailList", map);
	}
	
	/**
	 * @MethodName : ccDetailListTotal
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 경조사유형별 리스트토탈 조회
	 */
	public int ccDetailListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.ccDetailListTotal", map);
	}
	
	/**
	 * @MethodName : spDetailList
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 학자금유형별 리스트 조회
	 */
	public List<Map<String, Object>> spDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.spDetailList", map);
	}
	
	/**
	 * @MethodName : spDetailListTotal
	 * @author : doxx
	 * @since : 2019. 5. 16
	 * 설명 : 학자금유형별 리스트토탈 조회
	 */
	public int spDetailListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.spDetailListTotal", map);
	}
	
	/**
	 * @MethodName : ccDetailRegister
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세등록
	 */
	public void ccDetailRegister(Map<String, Object> map) {
		
		insert("vacationApply.ccDetailRegister", map);
		
	}
	
	/**
	 * @MethodName : ccDetailModify
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세수정
	 */
	public void ccDetailModify(Map<String, Object> map) {
		
		update("vacationApply.ccDetailModify", map);
		
	}
	
	/**
	 * @MethodName : ccDetailDelete
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조사상세삭제
	 */
	public void ccDetailDelete(Map<String, Object> map) {
		
		update("vacationApply.ccDetailDelete", map);
		
	}
	
	/**
	 * @MethodName : spDetailRegister
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세등록
	 */
	public void spDetailRegister(Map<String, Object> map) {
		
		insert("vacationApply.spDetailRegister", map);
		
	}
	
	/**
	 * @MethodName : spDetailModify
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세수정
	 */
	public void spDetailModify(Map<String, Object> map) {
		
		update("vacationApply.spDetailModify", map);
		
	}
	
	/**
	 * @MethodName : spDetailDelete
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 학자금상세삭제
	 */
	public void spDetailDelete(Map<String, Object> map) {
		
		update("vacationApply.spDetailDelete", map);
		
	}
	
	
	/**
	 * @MethodName : ccApplyList
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조신청 리스트
	 */
	public List<Map<String, Object>> ccApplyList(Map<String, Object> map){
		
		return selectList("vacationApply.ccApplyList", map);
	}
	
	/**
	 * @MethodName : ccApplyListTotal
	 * @author : doxx
	 * @since : 2019. 5. 17
	 * 설명 : 경조신청 리스트 토탈
	 */
	public int ccApplyListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.ccApplyListTotal", map);
	}
	

	/**
	 * @MethodName : ccApplySaveInsert
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조금신청 저장 insert
	 */
	public Map<String, Object> ccApplySaveInsert(Map<String, Object> map) {
		
		insert("vacationApply.ccApplySaveInsert", map);
		return map;
	}

	/**
	 * @MethodName : ccApplySaveUpdate
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조금신청 저장 update
	 */
	public Map<String, Object> ccApplySaveUpdate(Map<String, Object> map) {
		
		update("vacationApply.ccApplySaveUpdate", map);
		return map;
	}

	/**
	 * @MethodName : ccApplyDeleteRow
	 * @author : doxx
	 * @since : 2019. 5. 20
	 * 설명 : 경조사신청삭제
	 */
	public void ccApplyDeleteRow(Map<String, Object> map) {
		
		update("vacationApply.ccApplyDeleteRow", map);
		
	}
	
	
	public List<Map<String, Object>> famliyApplyList(Map<String, Object> map){
		
		return selectList("vacationApply.famliyApplyList", map);
	}
	
	public int famliyApplyListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.famliyApplyListTotal", map);
	}
	
	/**
	 * @MethodName : scholarApplyList
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청 리스트
	 */
	public List<Map<String, Object>> scholarApplyList(Map<String, Object> map){
		
		return selectList("vacationApply.scholarApplyList", map);
	}
	
	/**
	 * @MethodName : scholarApplyListTotal
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청 리스트 토탈
	 */
	public int scholarApplyListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.scholarApplyListTotal", map);
	}
	
	/**
	 * @MethodName : scholarApplyDetailList
	 * @author : doxx
	 * @since : 2019. 5. 23
	 * 설명 : 학자금신청상세 리스트
	 */
	public List<Map<String, Object>> scholarApplyDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.scholarApplyDetailList", map);
	}

	/**
	 * @MethodName : scholarDetailList
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 등록학자금 리스트 조회
	 */
	public List<Map<String, Object>> scholarDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.scholarDetailList", map);
	}
	
	
	/**
	 * @MethodName : scholarApplySaveInsert
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 학자금신청 저장
	 */
	public Map<String, Object> scholarApplySaveInsert(Map<String, Object> map) {
		
		insert("vacationApply.scholarApplySaveInsert", map);
		return map;
	}
	
	/**
	 * @MethodName : scholarApplyDetailSave
	 * @author : doxx
	 * @since : 2019. 5. 27
	 * 설명 : 학자금신청 상세내용 저장
	 */
	public void scholarApplyDetailSave(Map<String, Object> map) {
		
		insert("vacationApply.scholarApplyDetailSave", map);
	}
	
	/**
	 * @MethodName : scholarApplyUpdate
	 * @author : doxx
	 * @since : 2019. 6. 01
	 * 설명 : 학자금신청 수정
	 */
	public Map<String, Object> scholarApplyUpdate(Map<String, Object> map) {
		
		update("vacationApply.scholarApplyUpdate", map);
		return map;
	}
	
	/**
	 * @MethodName : scholarApplyDetailUpdate
	 * @author : doxx
	 * @since : 2019. 6. 01
	 * 설명 : 학자금신청 상세내용 기존삭제
	 */
	public Map<String, Object> scholarApplyDetailUpdate(Map<String, Object> map) {
		
		update("vacationApply.scholarApplyDetailUpdate", map);
		return map;
	}
	
	/**
	 * @MethodName : scholarApplyDeleteRow
	 * @author : doxx
	 * @since : 2019. 6.1
	 * 설명 : 학자금신청삭제
	 */
	public void scholarApplyDeleteRow(Map<String, Object> map) {
		
		update("vacationApply.scholarApplyDeleteRow", map);
		
	}

	
	public void scholarApprovalUpdate(Map<String, Object> main) {
		update("vacationApply.scholarApprovalUpdate", main);
	}
	
	public void scholarApprovalCancle(Map<String, Object> main) {
		update("vacationApply.scholarApprovalCancle", main);
	}
	
	/**
	 * @MethodName : scholarApplyDeleteDetail
	 * @author : doxx
	 * @since : 2019. 6.1
	 * 설명 : 학자금신청디테일 삭제
	 */
	public void scholarApplyDeleteDetail(Map<String, Object> map) {
		
		update("vacationApply.scholarApplyDeleteDetail", map);
		
	}
	
	public List<Map<String, Object>> getClubListOperated(Map<String, Object> map){
		
		return selectList("vacationApply.getClubListOperated", map);
	}
	
	public int getClubListOperatedTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.getClubListOperatedTotal", map);
	}
	
	public List<Map<String, Object>> getClubMemberList(Map<String, Object> map){
		
		return selectList("vacationApply.getClubMemberList", map);
	}
	
	public int getClubMemberListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.getClubMemberListTotal", map);
	}
	
	
	/**
	 * @MethodName : clubSaveInsert
	 * @author : doxx
	 * @since : 2020. 3. 15
	 * 설명 : 교양부서 저장 insert
	 */
	public Map<String, Object> clubSaveInsert(Map<String, Object> map) {
		
		insert("vacationApply.clubSaveInsert", map);
		return map;
	}

	/**
	 * @MethodName : clubSaveUpdate
	 * @author : doxx
	 * @since : 2020. 3. 15
	 * 설명 : 교양부서 저장 update
	 */
	public Map<String, Object> clubSaveUpdate(Map<String, Object> map) {
		
		update("vacationApply.clubSaveUpdate", map);
		return map;
	}
	
	/**
	 * @MethodName : getMedicalSubsidyApplyList
	 * @author : doxx
	 * @since : 2020. 3. 16
	 * 설명 : 의료비보조금 리스트 조회
	 */
	public List<Map<String, Object>> getMedicalSubsidyApplyList(Map<String, Object> map){
		
		return selectList("vacationApply.getMedicalSubsidyApplyList", map);
	}
	
	public int getMedicalSubsidyApplyListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.getMedicalSubsidyApplyListTotal", map);
	}
	
	public void fileUploadSave(Map<String, Object> main) {
		insert("vacationApply.fileUploadSave", main);
	}
	
	public void fileUploadActiveUpdate(Map<String, Object> main) {
		update("vacationApply.fileUploadActiveUpdate", main);
	}
	
	public int fileUpload(Map<String, Object> main) {
		return (int)update("vacationApply.fileUpload", main);
	}
	
	public int medicalSubsidyApplyInsert(Map<String, Object> main) {
		return (int)insert("vacationApply.medicalSubsidyApplyInsert", main);
	}
	
	public int medicalSubsidyApplyUpdate(Map<String, Object> main) {
		return (int)update("vacationApply.medicalSubsidyApplyUpdate", main);
	}
	
	public void medicalSubsidyDeleteRow(Map<String, Object> map) {
		update("vacationApply.medicalSubsidyDeleteRow", map);
	}
	
	public void medicalApprovalUpdate(Map<String, Object> main) {
		update("vacationApply.medicalApprovalUpdate", main);
	}
	
	public Map<String, Object> clubDetailSaveInsert(Map<String, Object> map) {
		
		insert("vacationApply.clubDetailSaveInsert", map);
		return map;
	}
	
	public void updateClubMainStatus(Map<String, Object> main) {
		update("vacationApply.updateClubMainStatus", main);
	}
	
	public void updateClubDetailStatus(Map<String, Object> main) {
		update("vacationApply.updateClubDetailStatus", main);
	}
	
	public void memberCountChange(Map<String, Object> main) {
		update("vacationApply.memberCountChange", main);
	}
	
	public void medicalApprovalCancle(Map<String, Object> main) {
		update("vacationApply.medicalApprovalCancle", main);
	}
	
	
	public Map<String, Object> famliyApplySaveInsert(Map<String, Object> map) {
		
		insert("vacationApply.famliyApplySaveInsert", map);
		return map;
	}
	
	public void familyApplyDetailSave(Map<String, Object> map) {
		
		insert("vacationApply.familyApplyDetailSave", map);
	}

	public Map<String, Object> familyApplyUpdate(Map<String, Object> map) {
		
		update("vacationApply.familyApplyUpdate", map);
		return map;
	}
	
	public List<Map<String, Object>> familyApplyDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.familyApplyDetailList", map);
	}
	
	public void familyApplyDeleteRow(Map<String, Object> map) {
		
		update("vacationApply.familyApplyDeleteRow", map);
		
	}
	
	public void familyApplyDeleteDetail(Map<String, Object> map) {
		
		update("vacationApply.familyApplyDeleteDetail", map);
		
	}
	
	public void familyDetailLoseApply(Map<String, Object> map) {
		
		update("vacationApply.familyDetailLoseApply", map);
		
	}
	
	public void familyApplyApprovall(Map<String, Object> map) {
		
		update("vacationApply.familyApplyApprovall", map);
		
	}
	
	public void familyApplyDetailApproval(Map<String, Object> map) {
		
		update("vacationApply.familyApplyDetailApproval", map);
		
	}
	
	public void familyLoseDetailApproval(Map<String, Object> map) {
		
		update("vacationApply.familyLoseDetailApproval", map);
		
	}
	
	public Map<String, Object> benefitSave(Map<String, Object> map) {
		
		insert("vacationApply.benefitSave", map);
		return map;
	}
	
	public void benefitDetailSave(Map<String, Object> map) {
		
		insert("vacationApply.benefitDetailSave", map);
	}
	
	public Map<String, Object> benefitUpdate(Map<String, Object> map) {
		
		update("vacationApply.benefitUpdate", map);
		return map;
	}
	
	public Map<String, Object> benefitDetailUpdate(Map<String, Object> map) {
		
		update("vacationApply.benefitDetailUpdate", map);
		return map;
	}
	
	public Map<String, Object> benefitDetailDelete(Map<String, Object> map) {
		
		update("vacationApply.benefitDetailDelete", map);
		return map;
	}
	
	public List<Map<String, Object>> benefitList(Map<String, Object> map){
		
		return selectList("vacationApply.benefitList", map);
	}
	
	public int benefitListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.benefitListTotal", map);
	}
	
	public List<Map<String, Object>> benefitDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.benefitDetailList", map);
	}
	
	public List<Map<String, Object>> getBenefitTypeList(Map<String, Object> map){
		
		return selectList("vacationApply.getBenefitTypeList", map);
	}
	
	public int getBenefitTypeListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.getBenefitTypeListTotal", map);
	}
	
	public Map<String, Object> benefitPreDataDelete(Map<String, Object> map) {
		
		update("vacationApply.benefitPreDataDelete", map);
		return map;
	}
	
	public Map<String, Object> benefitRebatch(Map<String, Object> map) {
		
		update("vacationApply.benefitRebatch", map);
		return map;
	}
	
	public List<Map<String, Object>> benefitDeleteData(Map<String, Object> map){
		
		return selectList("vacationApply.benefitDeleteData", map);
	}
	
	public List<Map<String, Object>> getScholarshipManageList(Map<String, Object> map){
		
		return selectList("vacationApply.getScholarshipManageList", map);
	}
	
	public int getScholarshipManageListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.getScholarshipManageListTotal", map);
	}
	
	public List<Map<String, Object>> welfareApplyList(Map<String, Object> map){
		
		return selectList("vacationApply.welfareApplyList", map);
	}
	
	public int welfareApplyListTotal(Map<String, Object> map) {
		
		return (int)selectOne("vacationApply.welfareApplyListTotal", map);
	}
	
	public Map<String, Object> welfareApplySaveInsert(Map<String, Object> map) {
		
		insert("vacationApply.welfareApplySaveInsert", map);
		return map;
	}
	
	public void welfareApplyDetailSave(Map<String, Object> map) {
		
		insert("vacationApply.welfareApplyDetailSave", map);
	}

	public Map<String, Object> welfareApplyUpdate(Map<String, Object> map) {
		
		update("vacationApply.welfareApplyUpdate", map);
		return map;
	}
	
	public List<Map<String, Object>> welfareApplyDetailList(Map<String, Object> map){
		
		return selectList("vacationApply.welfareApplyDetailList", map);
	}
	
	public void welfareApplyDeleteRow(Map<String, Object> map) {
		
		update("vacationApply.welfareApplyDeleteRow", map);
		
	}
	
	public void welfareApplyDeleteDetail(Map<String, Object> map) {
		
		update("vacationApply.welfareApplyDeleteDetail", map);
		
	}
	
	public void welfareDetailLoseApply(Map<String, Object> map) {
		
		update("vacationApply.welfareDetailLoseApply", map);
		
	}
	
	public void welfareApplyApprovall(Map<String, Object> map) {
		
		update("vacationApply.welfareApplyApprovall", map);
		
	}
	
	public void welfareApplyDetailApproval(Map<String, Object> map) {
		
		update("vacationApply.welfareApplyDetailApproval", map);
		
	}
	
	public void welfareLoseDetailApproval(Map<String, Object> map) {
		
		update("vacationApply.welfareLoseDetailApproval", map);
		
	}
	
	public void familyBenefitMonthBatch(Map<String, Object> map) {
		
		update("vacationApply.familyBenefitMonthBatch", map);
		
	}
	
	public void welfareBenefitMonthBatch(Map<String, Object> map) {
		
		update("vacationApply.welfareBenefitMonthBatch", map);
		
	}
	
	public Map<String, Object> welrfareBenefitRebatch(Map<String, Object> map) {
		
		update("vacationApply.welrfareBenefitRebatch", map);
		return map;
	}
	
	
}
