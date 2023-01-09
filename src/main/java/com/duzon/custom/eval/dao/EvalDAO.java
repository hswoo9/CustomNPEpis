package com.duzon.custom.eval.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;
import com.duzon.custom.eval.vo.CareerVO;
import com.duzon.custom.eval.vo.CommitteeVO;
import com.duzon.custom.eval.vo.DegreeVO;
import com.duzon.custom.eval.vo.EvalVO;
import com.duzon.custom.eval.vo.LicenseVO;
@Repository
public class EvalDAO extends AbstractDAO{

	public void setCommissionerPoolInsert(EvalVO evalVo) {
		insert("eval.setCommissionerPoolInsert", evalVo);
	}

	public void setCommissionerDetailInsert(EvalVO evalVo) {
		insert("eval.setCommissionerDetailInsert", evalVo);
		
	}

	public void setEvalDegreeInsert(DegreeVO dv) {
		insert("eval.setEvalDegreeInsert", dv);
		
	}

	public void setEvalCareerInsert(CareerVO cv) {
		insert("eval.setEvalCareerInsert", cv);
		
	}

	public void setEvalLicenseInsert(LicenseVO lv) {
		insert("eval.setEvalLicenseInsert", lv);
		
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvaluationCommitteeListSearch(Map<String, Object> map) {
		return selectList("eval.getEvaluationCommitteeListSearch", map);
	}

	public int getEvaluationCommitteeListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.getEvaluationCommitteeListSearchTotal", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCommitteePool(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getCommitteePool", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getCommitteeDetail(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getCommitteeDetail", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalDegree(Map<String, Object> map) {
		return selectList("eval.getEvalDegree", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCareer(Map<String, Object> map) {
		return selectList("eval.getEvalCareer", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalLicense(Map<String, Object> map) {
		return selectList("eval.getEvalLicense", map);
	}

	public void setCommissionerPoolUpdate(EvalVO evalVo) {
		update("eval.setCommissionerPoolUpdate", evalVo);
	}

	public void setCommissionerDetailUpdate(EvalVO evalVo) {
		update("eval.setCommissionerDetailUpdate", evalVo);
		
	}

	public void setEvalDegreeUpdate(DegreeVO dv) {
		update("eval.setEvalDegreeUpdate", dv);
	}

	public void setEvalCareerUpdate(CareerVO cv) {
		update("eval.setEvalCareerUpdate", cv);
	}

	public void setEvalLicenseUpdate(LicenseVO lv) {
		update("eval.setEvalLicenseUpdate", lv);
	}

	public void evaluationCommitteeDel(Map<String, Object> map) {
		update("eval.evaluationCommitteeDel", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalBizTypeListSearch(Map<String, Object> map) {
		return selectList("eval.evalBizTypeListSearch", map);
	}

	public int evalBizTypeListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.evalBizTypeListSearchTotal", map);
	}

	public void setEvalBizTypeUpdate(Map<String, Object> map) {
		update("eval.setEvalBizTypeUpdate", map);
	}

	public void setEvalBizTypeSave(Map<String, Object> map) {
		insert("eval.setEvalBizTypeSave", map);
	}

	public void setEvalBizTypeDel(Map<String, Object> map) {
		delete("eval.setEvalBizTypeDel", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalTypeSearch(Map<String, Object> map) {
		return selectList("eval.evalTypeSearch", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalBizTypeItemListSearch(Map<String, Object> map) {
		return selectList("eval.evalBizTypeItemListSearch", map);
	}

	public int evalBizTypeItemListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.evalBizTypeItemListSearchTotal", map);
	}

	public void evalBizTypeItemDel(Map<String, Object> map) {
		delete("eval.evalBizTypeItemDel", map);
	}

	public void evalBizTypeItemSave(Map<String, Object> map) {
		insert("eval.evalBizTypeItemSave", map);
	}

	public void evalBizTypeItemUpdate(Map<String, Object> map) {
		update("eval.evalBizTypeItemUpdate", map);
	}

	public void evaluationProposalViewSave(CommitteeVO committeeVO) { insert("eval.evaluationProposalViewSave", committeeVO); }

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evaluationProposalListSearch(Map<String, Object> map) {
		return selectList("eval.evaluationProposalListSearch", map);
	}

	public int evaluationProposalConfigurationListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.evaluationProposalListSearchTotal", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evaluationProposalConfigurationListSearch(Map<String, Object> map) {
		return selectList("eval.evaluationProposalConfigurationListSearch", map);
	}

	public int evaluationProposalListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.evaluationProposalConfigurationListSearchTotal", map);
	}

	public void evaluationProposalListDel(Map<String, Object> map) {
		update("eval.evaluationProposalListDel", map);		
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvaluationProposal(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvaluationProposal", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvaluationIdListSearch(Map<String, Object> map) {
		return selectList("eval.getEvaluationIdListSearch", map);
	}

	public int getEvaluationIdListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.getEvaluationIdListSearchTotal", map);
	}

	public void evaluationIdViewSave(Map<String, Object> map) {
		insert("eval.evaluationIdViewSave", map);
	}

	public void evaluationIdViewUpdate(Map<String, Object> map) {
		update("eval.evaluationIdViewUpdate", map);
	}

	public void evaluationIdViewDel(Map<String, Object> map) {
		delete("eval.evaluationIdViewDel", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalItemList(Map<String, Object> map) {
		return selectList("eval.getEvalItemList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCommList(Map<String, String> map) {
		return selectList("eval.getEvalCommList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCommListPop(Map<String, Object> map) {
		return selectList("eval.getEvalCommListPop", map);
	}

	public void evalCompanyInsert(Map<String, Object> join) {
		insert("eval.evalCompanyInsert", join);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCompany(Map<String, Object> map) {
		return selectList("eval.getEvalCompany", map);
	}

	public void setEvalCommSave(Map<String, Object> comm) {
		insert("eval.setEvalCommSave", comm);
	}

	public void setEvalCommissionerCnt(Map<String, Object> map) {
		update("eval.setEvalCommissionerCnt", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCommUserList(Map<String, Object> map) {
		return selectList("eval.getEvalCommUserList", map);
	}

	public void setEvalCommitteeTypeSave(Map<String, Object> data) {
		insert("eval.setEvalCommitteeTypeSave", data);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCommTypeList(Map<String, Object> map) {
		return selectList("eval.getEvalCommTypeList", map);
	}

	public void setEmptyEvalCommissioner(Map<String, Object> map) {
		update("eval.setEmptyEvalCommissioner", map);
	}

	public void setEvalCommitteeTypeDel(Map<String, Object> map) {
		update("eval.setEvalCommitteeTypeDel", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalIdList(Map<String, Object> map) {
		return selectList("eval.getEvalIdList", map);
	}

	public void setevalIdSave(Map<String, Object> map) {
		update("eval.setevalIdSave", map);
	}

	public void setevalIdDel(Map<String, Object> map) {
		update("eval.setevalIdDel", map);
	}

	public void setEvalItemSave(Map<String, Object> item) {
		insert("eval.setEvalItemSave", item);
	}

	public void setEvalItemDel(CommitteeVO committeeVO) {
		update("eval.setEvalItemDel", committeeVO);
	}

	public void evaluationProposalViewUpdate(CommitteeVO committeeVO) {
		update("eval.evaluationProposalViewUpdate", committeeVO);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getcommItem(Map<String, Object> map) {
		return  selectList("eval.getcommItem", map);
	}

	public void setEvalItemResult(Map<String, Object> comm) {
		insert("eval.setEvalItemResult", comm);
	}

	public void setEmptyEvalItemResult(Map<String, Object> map) {
		update("eval.setEmptyEvalItemResult", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalUserIdChk(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalUserIdChk", map);
	}

	public void setEvalCompanyRemark(Map<String, Object> comm) {
		insert("eval.setEvalCompanyRemark", comm);
	}

	public void setEmptyEvalCompanyRemark(Map<String, Object> map) {
		update("eval.setEmptyEvalCompanyRemark", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> joinOrgGridListSearch(Map<String, Object> map) {
		return selectList("eval.joinOrgGridListSearch", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalItemGridListSearch(Map<String, Object> map) {
		return selectList("eval.evalItemGridListSearch", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalitem(Map<String, Object> map) {
		return selectList("eval.getEvalitem", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvaCommList(Map<String, Object> map) {
		return selectList("eval.getEvaCommList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getItemColList(Map<String, Object> map) {
		return selectList("eval.getItemColList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalResultList(Map<String, Object> map) {
		return selectList("eval.getEvalResultList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalResultTotal(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalResultTotal", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalCompanyListSearch(Map<String, Object> map) {
		return selectList("eval.evalCompanyListSearch", map);
	}

	public int evalCompanyListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.evalCompanyListSearchTotal", map);
	}
	
	public int getEvalCommListPopTotal(Map<String, Object> map) {
		return (int) selectOne("eval.getEvalCommListPopTotal", map);
	}

	public void evalCompanySave(Map<String, Object> map) {
		insert("eval.evalCompanySave", map);
	}

	public void evalCompanyUpdate(Map<String, Object> map) {
		update("eval.evalCompanyUpdate",map);
	}

	public void evalCompanyDel(Map<String, Object> map) {
		update("eval.evalCompanyDel",map);
	}

	public void evalCommFix(Map<String, Object> map) {
		update("eval.evalCommFix",map);
	}

	public void evalCommFixUpdate(Map<String, Object> map) {
		update("eval.evalCommFixUpdate",map);
	}

	public void evalTransPaySave(Map<String, Object> map) {
		update("eval.evalTransPaySave",map);
	}

	public void setBizTypeCodeInsert(EvalVO evalVo) {
		insert("eval.setBizTypeCodeInsert", evalVo);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommitteeBizTypeList(Map<String, Object> map) {
		return selectList("eval.getCommitteeBizTypeList", map);
	}

	public void setCommissionerBizTypeDel(EvalVO evalVo) {
		update("eval.setCommissionerBizTypeDel",evalVo);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> purcListSearch(Map<String, Object> map) {
		return selectList("eval.purcListSearch", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPurcBiddingList(Map<String, Object> map) {
		return selectList("eval.getPurcBiddingList", map);
	}

	public void regStateUpdate(CommitteeVO committeeVO) {
		update("eval.regStateUpdate",committeeVO);
	}

	public void evalCommCancel(Map<String, Object> map) {
		update("eval.evalCommCancel",map);
		update("eval.evalCommissionerCntReSum",map);
	}

	public void setDjPurcReqDel(Map<String, Object> map) {
		update("eval.setDjPurcReqDel",map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalAnListSearch(Map<String, Object> map) {
		return selectList("eval.evalAnListSearch", map);
	}

	public int evalAnListSearchTotal(Map<String, Object> map) {
		return (int) selectOne("eval.evalAnListSearchTotal", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> evalStradeListSearch(Map<String, Object> map) {
        return selectListMs("eval_erp.evalStradeListSearch", map);
	}

	public void evalCompanyDelete(CommitteeVO committeeVO) {
		delete("eval.evalCompanyDelete", committeeVO);
	}

	public String getEvalDocNum() {
		return (String) selectOne("eval.getEvalDocNum");
	}

	public void setEvalAnInsert(Map<String, Object> map) {
		insert("eval.setEvalAnInsert", map);
	}

	public void setEvalAnUpdate(Map<String, Object> map) {
		update("eval.setEvalAnUpdate", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommissionerAnUserList(Map<String, Object> map) {
		return selectList("eval.getCommissionerAnUserList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalAnData(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalAnData", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommissionerList(Map<String, Object> map) {
		return selectList("eval.getCommissionerList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalConfirmData(Map<String, Object> map) {
		return selectList("eval.getEvalConfirmData", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommissionerAnUserListTemp(Map<String, Object> map) {
		return selectList("eval.getCommissionerAnUserListTemp", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getErpUserInfo(Map<String, Object> vo) {
		return (Map<String, Object>) selectOneMs("eval_erp.getErpUserInfo", vo);
	}

	public void evalAnOutProcess(Map<String, Object> map) {
		update("eval.evalAnOutProcess", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCommissionerList(Map<String, Object> map) {
		return selectList("eval.getEvalCommissionerList", map);
	}

	public void finalApprovalActiveSave(Map<String, Object> map) {
		update("eval.finalApprovalActiveSave", map);	
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> evalProposalModFileDownload(Map<String,Object> map){
		return (Map<String, Object>) selectOne("eval.evalProposalModFileDownload", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> evalProposalModFileDownload2(Map<String,Object> map){
		return (Map<String, Object>) selectOne("eval.evalProposalModFileDownload2", map);
	}
	
	public void insertCommissionerPoolExcel(Map<String,Object> map) {
		insert("eval.insertCommissionerPoolExcel", map);
	}
	
	public void insertCommissionerDetailExcel(Map<String,Object> map) {
		insert("eval.insertCommissionerDetailExcel", map);
	}
	
	public void insertBizTypeCodeExcel(List<Map<String,Object>> list) {
		insert("eval.insertBizTypeCodeExcel", list);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String,Object> selectBirthDateYN(Map<String,Object> map) {
		return (Map<String,Object>) selectOne("eval.selectBirthDateYN", map);
	}

	public void updateCommissionerPoolExcel(Map<String, Object> map) {
		update("eval.updateCommissionerPoolExcel", map);	
	}
	public void updateCommissionerDetailExcel(Map<String, Object> map) {
		update("eval.updateCommissionerDetailExcel", map);	
	}
	public void deleteBizTypeCodeExcel(Map<String, Object> map) {
		delete("eval.deleteBizTypeCodeExcel", map);
	}

	@SuppressWarnings("unchecked")
	public void setEvalDocInfoUpD(Map<String, Object> params) { update("eval.setEvalDocInfoUpD", params); }
	@SuppressWarnings("unchecked")
	public void setEvalChangeDocApproveUp(Map<String, Object> params) { update("eval.setEvalChangeDocApproveUp", params); }

	public void setEvalDocApproveRetrieve(Map<String, Object> params) { update("eval.setEvalDocApproveRetrieve", params);}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalCommOne(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalCommOne", map);
	}

	public Map<String, Object> getJangName(Map<String, Object> login){
		return (Map<String, Object>) selectOne("eval.getJangName", login);
	}
}
